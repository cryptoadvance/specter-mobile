import 'dart:async';

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeScanner.dart';

import '../../CEntropyExternalGenerationService.dart';
import '../CControlTransactionsService.dart';
import '../CGenerateSeedService.dart';
import '../CRecoverySeedService.dart';

enum CryptoProviderEventType {
  GENERATE_SEED_EVENT
}

class SCryptoProviderEvent {
  final CryptoProviderEventType _eventType;
  final SCryptoProviderSubEvent _subEvent;

  SCryptoProviderEvent(
      CryptoProviderEventType eventType, SCryptoProviderSubEvent subEvent
  ): _eventType = eventType, _subEvent = subEvent;

  @override
  String toString() {
    return jsonEncode({
      'eventType': _eventType.toString()
    });
  }
}

abstract class SCryptoProviderSubEvent {

}

class SGenerateSeedEvent extends SCryptoProviderSubEvent {
  String mnemonicKey;
  double completePercent;

  SGenerateSeedEvent({this.completePercent = 0, required this.mnemonicKey});

  @override
  String toString() {
    return jsonEncode({
      'seedKey': mnemonicKey,
      'completePercent': completePercent.toString()
    });
  }
}

class SMnemonicRootKey {
  String rootPrivateKey;
  String sign;

  SMnemonicRootKey({required this.rootPrivateKey, required this.sign});

  @override
  String toString() {
    return jsonEncode({
      'rootPrivateKey': rootPrivateKey,
      'sign': sign
    });
  }
}

class SWalletKey {
  final String raw;
  SWalletKey({
    required this.raw
  });

  static SWalletKey parseRAW(raw) {
    return SWalletKey(raw: raw);
  }

  static SWalletKey fromJSON(obj) {
    return SWalletKey(
      raw: obj['raw']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'raw': raw
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  String? fingerprint, derivationPath;

  void  _processRaw() {
    try {
      if (raw[0] != '[') {
        return;
      }

      int x = raw.indexOf(']');
      String subRaw = raw.substring(1, x);
      x = subRaw.indexOf('/');
      fingerprint = subRaw.substring(0, x);
      derivationPath = subRaw.substring(x + 1);
      print(subRaw);
    } catch(e) {
      print(e);
    }
  }

  String getDerivationPath() {
    if (derivationPath == null) {
      _processRaw();
    }
    return derivationPath!;
  }

  String getFingerprint() {
    if (fingerprint == null) {
      _processRaw();
    }
    return fingerprint!;
  }
}

enum WalletNetwork {
  BITCOIN,
  TESTNET,
  SIGNET,
  REGTEST
}

extension ParseToString on WalletNetwork {
  String toShortString() {
    return toString().split('.').last;
  }
}

class SWalletDescriptor {
  WalletNetwork net;
  String recv;
  String change;
  String policy;
  String type;

  List<SWalletKey> keys;

  SWalletDescriptor({
    required this.net,
    required this.recv,
    required this.change,
    required this.policy,
    required this.type,
    required this.keys
  });

  static SWalletDescriptor fromJSON(obj) {
    List<SWalletKey> _keys = [];
    if (obj['keys'] != null) {
      obj['keys'].forEach((key) {
        _keys.add(SWalletKey.fromJSON(key));
      });
    }

    return SWalletDescriptor(
      net: getWalletNetwork(obj['net']),
      recv: obj['recv'],
      change: obj['change'],
      policy: obj['policy'],
      type: obj['type'],
      keys: _keys
    );
  }

  Map<String, dynamic> toJSON() {
    List<dynamic> _keys = [];
    keys.forEach((key) {
      _keys.add(key.toJSON());
    });

    return {
      'net': net.toShortString(),
      'recv': recv,
      'change': change,
      'policy': policy,
      'type': type,
      'keys': _keys
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  static WalletNetwork getWalletNetwork(String str) {
    if (str == 'BITCOIN') {
      return WalletNetwork.BITCOIN;
    }
    if (str == 'TESTNET') {
      return WalletNetwork.TESTNET;
    }
    if (str == 'SIGNET') {
      return WalletNetwork.SIGNET;
    }
    if (str == 'REGTEST') {
      return WalletNetwork.REGTEST;
    }
    return WalletNetwork.BITCOIN;
  }

  String getWalletKey() {
    var bytes = utf8.encode(recv);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}

abstract class CCryptoProvider {
  late StreamController<SCryptoProviderEvent> streamController;
  late Stream<SCryptoProviderEvent> stream;

  CCryptoProvider() {
    streamController = StreamController<SCryptoProviderEvent>.broadcast();
    stream = streamController.stream;
  }

  void addEvent(CryptoProviderEventType eventType, SCryptoProviderSubEvent subEvent) {
    streamController.add(SCryptoProviderEvent(eventType, subEvent));
  }

  StreamSubscription<SCryptoProviderEvent> subscribeEvents(CryptoProviderEventType eventType, Function(SCryptoProviderSubEvent) cb) {
    return stream.listen((item) {
      if (item._eventType != eventType) {
        return;
      }
      cb(item._subEvent);
    });
  }

  //Generate seed API
  void startGenerateSeed();
  void stopGenerateSeed();
  void setGenerateSeedOptions(GenerateSeedOptions generateSeedOptions);
  void cleanGeneratedSeed();
  void addExternalEntropy(SGenerateEntropyExternalEvent entropyExternalEvent);

  //Recovery seed API
  Future<RecoverySeedResult?> verifyRecoveryPhrase(List<String> recoveryPhrases);

  //Wallets API
  SMnemonicRootKey mnemonicToRootKey(String mnemonic, String pass);
  SWalletDescriptor getDefaultDescriptor(SMnemonicRootKey mnemonicRootKey, WalletNetwork net);
  SWalletDescriptor getParsedDescriptor(SMnemonicRootKey mnemonicRootKey, String descriptor, WalletNetwork net);

  //Transactions API
  SCryptoTransactionModel parseTransaction(QRCodeScannerResultParseTransaction transaction, List<SWalletModel> searchWallets, WalletNetwork net);
}