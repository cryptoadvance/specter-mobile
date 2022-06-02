import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeScanner.dart';
import 'package:specter_rust/specter_rust.dart';

import '../../CEntropyExternalGenerationService.dart';
import '../CControlTransactionsService.dart';
import '../CGenerateSeedService.dart';
import '../CRecoverySeedService.dart';
import 'CCryptoProvider.dart';

class CCryptoProviderRust extends CCryptoProvider {
  int maxGenerateIterations = 10;
  GenerateSeedOptions? currentGenerateSeedOptions;
  String _mnemonic = '';

  SGenerateEntropyExternalEvent? _entropyExternalEvent;

  var rnd = Random.secure();

  @override
  void startGenerateSeed() {
    print('startGenerateSeed');
    if (currentGenerateSeedOptions == null) {
      throw 'generateSeedOptions is not set';
    }

    //
    Future.delayed(Duration(milliseconds: 1), () {
      _generateSeed();
    });
  }

  void _generateSeed() async {
    if (currentGenerateSeedOptions!.entropySource == ENTROPY_SOURCE.CAMERA && _entropyExternalEvent == null) {
      _mnemonic = '';
      _addEvent();
      return;
    }

    //
    int seedBitSize = (currentGenerateSeedOptions!.seedComplexity == SEED_COMPLEXITY.SIMPLE)?128:256;

    //
    int bytes = (seedBitSize / 8).round();
    Uint8List seedList = getRandomSeed(bytes);

    //
    String mnemonicFromRust = SpecterRust.mnemonic_from_entropy(HEX.encode(seedList));

    //
    _mnemonic = mnemonicFromRust;

    //
    _addEvent();
  }

  void _addEvent() {
    addEvent(CryptoProviderEventType.GENERATE_SEED_EVENT, SGenerateSeedEvent(
        mnemonicKey: _mnemonic,
        completePercent: 100
    ));
  }

  static int entropyGenIterations = 100;

  Uint8List getRandomSeed(int bytes) {
    if (bytes < 16) {
      throw 'to small bytes';
    }
    if (entropyGenIterations < 10) {
      throw 'to low entropyGenIterations';
    }

    Uint8List seedList = Uint8List(bytes);
    for (int seedIdx = 0; seedIdx < bytes; seedIdx++) {
      seedList[seedIdx] = 0;
    }

    for (int genIdx = 0; genIdx < entropyGenIterations; genIdx++) {
      for (int seedIdx = 0; seedIdx < bytes; seedIdx++) {
        int a = seedList[seedIdx];
        a = a ^ rnd.nextInt(256) ^ rnd.nextInt(256) ^ rnd.nextInt(256);
        seedList[seedIdx] = a;
      }
    }

    if (_entropyExternalEvent != null) {
      List<int> digest = _entropyExternalEvent!.digest!;

      for (int seedIdx = 0; seedIdx < bytes; seedIdx++) {
        int useIndex = seedIdx % digest.length;
        int externalEntropy = digest[useIndex];
        int a = seedList[seedIdx];
        a = a ^ externalEntropy;
        seedList[seedIdx] = a;
      }
    }

    return seedList;
  }

  @override
  void stopGenerateSeed() {
    _mnemonic = '';
    _entropyExternalEvent = null;
  }

  @override
  void setGenerateSeedOptions(GenerateSeedOptions generateSeedOptions) {
    if (generateSeedOptions.entropySource == ENTROPY_SOURCE.NONE) {
      _entropyExternalEvent = null;
    }
    currentGenerateSeedOptions = generateSeedOptions;
    _generateSeed();
  }

  @override
  void addExternalEntropy(SGenerateEntropyExternalEvent entropyExternalEvent) {
    print('add external entropy');
    _entropyExternalEvent = entropyExternalEvent;
    _generateSeed();
  }

  @override
  void cleanGeneratedSeed() {
   _mnemonic = '';
   _addEvent();
  }

  @override
  Future<RecoverySeedResult?> verifyRecoveryPhrase(List<String> recoveryPhrases) async {
    String mnemonic = '';
    bool finishRead = false;
    recoveryPhrases.forEach((recoveryPhrase) {
      if (finishRead) {
        return;
      }
      if (recoveryPhrase.isEmpty) {
        finishRead = true;
        return;
      }
      if (mnemonic.isNotEmpty) {
        mnemonic += ' ';
      }
      mnemonic += recoveryPhrase;
    });

    if (mnemonic.isEmpty) {
      return null;
    }

    try {
      SpecterRust.mnemonic_to_root_key(mnemonic, '');
    } catch(e) {
      return null;
    }

    return RecoverySeedResult(
      seedKey: mnemonic
    );
  }

  @override
  SMnemonicRootKey mnemonicToRootKey(String mnemonic, String pass) {
    var obj = SpecterRust.mnemonic_to_root_key(mnemonic, pass);
    return SMnemonicRootKey(
      rootPrivateKey: obj['xprv'],
      sign: obj['fingerprint']
    );
  }

  @override
  SWalletDescriptor getDefaultDescriptor(SMnemonicRootKey mnemonicRootKey, WalletNetwork net) {
    var obj = SpecterRust.get_default_descriptors(mnemonicRootKey.rootPrivateKey, net.toShortString().toLowerCase());

    String descriptor = obj['recv_descriptor'];
    SWalletDescriptor desc = getParsedDescriptor(mnemonicRootKey, descriptor, net);
    if (desc.recv != obj['recv_descriptor']) {
      throw 'wrong recv_descriptor';
    }
    if (desc.change != obj['change_descriptor']) {
      throw 'wrong change_descriptor';
    }

    return desc;
  }

  @override
  SWalletDescriptor getParsedDescriptor(SMnemonicRootKey mnemonicRootKey, String descriptor, WalletNetwork net) {
    var obj = SpecterRust.parse_descriptor(descriptor, mnemonicRootKey.rootPrivateKey, net.toShortString().toLowerCase());
    List<SWalletKey> _keys = [];
    obj['keys'].forEach((key) {
      _keys.add(SWalletKey.parseRAW(key));
    });
    
    return SWalletDescriptor(
      net: net,
      recv: obj['recv_descriptor'],
      change: obj['change_descriptor'],
      policy: obj['policy'],
      type: obj['type'],
      keys: _keys
    );
  }

  @override
  SCryptoTransactionModel parseTransaction(QRCodeScannerResultParseTransaction transaction, List<SWalletModel> searchWallets, WalletNetwork net) {
    List<dynamic> walletsJson = [];
    searchWallets.forEach((wallet) {
      walletsJson.add({
        'recv_descriptor': wallet.descriptor.recv,
        'change_descriptor': wallet.descriptor.change
      });
    });
    var obj = SpecterRust.parse_transaction(transaction.raw, walletsJson, net.toShortString().toLowerCase());

    num fee = obj['fee'];
    List<dynamic> inputs = obj['inputs'];
    List<dynamic> outputs = obj['outputs'];

    List<SCryptoTransactionPoint> inputsData = _parseTransactionPoints(searchWallets, inputs );
    List<SCryptoTransactionPoint> outputsData = _parseTransactionPoints(searchWallets, outputs);

    SCryptoTransactionModel tx = SCryptoTransactionModel(
      fee: fee.toDouble(),
      inputs: inputsData,
      outputs: outputsData
    );

    print(obj.toString());
    print('transaction: ' + tx.toString());

    return tx;
  }

  List<SCryptoTransactionPoint> _parseTransactionPoints(List<SWalletModel> searchWallets, List<dynamic> points) {
    List<SCryptoTransactionPoint> pointsData = [];
    points.forEach((point) {
      pointsData.add(_parseTransactionPointItem(searchWallets, point));
    });
    return pointsData;
  }

  SCryptoTransactionPoint _parseTransactionPointItem(List<SWalletModel> searchWallets, var obj) {
    String address = obj['address'];
    double value = obj['value'];
    List<dynamic> wallets = obj['wallets'];

    num walletIndexNum = wallets.first;
    SWalletModel walletItem = searchWallets[walletIndexNum.toInt()];

    SCryptoTransactionPoint point = SCryptoTransactionPoint(
      address: address,
      value: value,
      walletKey: walletItem.key
    );
    return point;
  }
}