import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import 'private/DiskContainer.dart';

class PrivateCryptoContainer {
  PrivateCryptoContainerModel? _privateCryptoContainerModel;
  
  final DiskContainer _diskContainer = DiskContainer();

  static String emptyPass = 'default';
  bool isVolumeOpen = false;

  Future<void> init() async {
    await _diskContainer.init();
  }

  bool createDefaultVolume() {
    if (_diskContainer.findVolumeAndOpen(emptyPass)) {
      return false;
    }
    return _diskContainer.createVolume(0, emptyPass);
  }

  bool tryOpenPrivateCryptoContainer(String pass) {
    if (!_diskContainer.findVolumeAndOpen(pass.isEmpty?emptyPass:pass)) {
      return false;
    }

    isVolumeOpen = true;
    return true;
  }

  Future<bool> _saveCryptoContainer() async {
    return false;
  }

  Future<bool> addSeed(String seedKey) async {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    if (!(await _privateCryptoContainerModel!.addSeed(seedKey))) {
      return false;
    }

    if (!(await _saveCryptoContainer())) {
      return false;
    }

    return true;
  }

  Future<bool> addNewWallet({
    required String walletName,
    required SWalletDescriptor walletDescriptor
  }) async {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    String key = walletDescriptor.getWalletKey();
    SWalletModel wallet = SWalletModel(key: key, name: walletName, descriptor: walletDescriptor);
    if (!(await _privateCryptoContainerModel!.addNewWallet(wallet))) {
      return false;
    }

    if (!(await _saveCryptoContainer())) {
      return false;
    }

    return true;
  }

  SWalletModel getWalletByKey(String key) {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    return _privateCryptoContainerModel!.getWalletByKey(key);
  }

  bool isSeedsInit() {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    return _privateCryptoContainerModel!.isSeedsInit();
  }

  bool isWalletsInit() {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    return _privateCryptoContainerModel!.isWalletsInit();
  }

  String getMnemonicByIdx(int idx) {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    return _privateCryptoContainerModel!.getMnemonicByIdx(idx);
  }

  List<SWalletModel> getWallets() {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    return _privateCryptoContainerModel!.getWallets();
  }
}