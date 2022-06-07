import 'dart:typed_data';

import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import 'private/DiskBlobsContainer.dart';
import 'private/DiskContainer.dart';
import 'private/storages/DiskStorageJSON.dart';

class PrivateCryptoContainer {
  PrivateCryptoContainerModel? _privateCryptoContainerModel;
  
  final DiskContainer _diskContainer = DiskContainer();
  DiskBlobsContainer? _diskBlobsContainer;

  static String emptyPass = 'default';
  bool isVolumeOpen = false;

  static const int _mainContainerResourceID = 30;

  Future<void> init() async {
    await _diskContainer.init();

    _diskBlobsContainer = DiskBlobsContainer(diskContainer: _diskContainer);

    //test();
  }

  void test() {
    //createDefaultVolume();

    if (!tryOpenPrivateCryptoContainer('')) {
      throw 'can not open';
    }

    {
      String resA = 'resA:';
      for (int i = 0; i < 3000; i++) {
        resA += i.toString() + ';';
      }
      Uint8List data = Uint8List.fromList(resA.codeUnits);
      _diskBlobsContainer!.writeData(1, data);

      Uint8List readData = _diskBlobsContainer!.readData(1);
      String resAAnswer = String.fromCharCodes(readData);
      print('answer: ' +  resAAnswer);
    }

    {
      String resA = 'resB:';
      for (int i = 0; i < 1200; i++) {
        resA += i.toString() + ';';
      }
      Uint8List data = Uint8List.fromList(resA.codeUnits);
      _diskBlobsContainer!.writeData(10, data);

      Uint8List readData = _diskBlobsContainer!.readData(10);
      String resAAnswer = String.fromCharCodes(readData);
      print('answer: ' +  resAAnswer);
    }

    {
      String resA = 'resA:';
      for (int i = 0; i < 4000; i++) {
        resA += i.toString() + ';';
      }
      Uint8List data = Uint8List.fromList(resA.codeUnits);
      _diskBlobsContainer!.writeData(1, data);

      Uint8List readData = _diskBlobsContainer!.readData(1);
      String resAAnswer = String.fromCharCodes(readData);
      print('answer: ' +  resAAnswer);
    }

    {
      DiskStorageJSON storageJSON = DiskStorageJSON(diskBlobsContainer: _diskBlobsContainer!, resourceID: 15);
      /*storageJSON.saveData({
        'test': 100
      });*/
      var obj = storageJSON.readData();
      print(obj.toString());
    }
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

    _loadCryptoContainer();
    return true;
  }

  void _loadCryptoContainer() {
    DiskStorageJSON storageJSON = DiskStorageJSON(diskBlobsContainer: _diskBlobsContainer!, resourceID: _mainContainerResourceID);
    var obj = storageJSON.readData();

    _privateCryptoContainerModel = PrivateCryptoContainerModel();
    if (obj != null) {
      _privateCryptoContainerModel!.loadStore(obj);
    }

    print('read container: ' + _privateCryptoContainerModel.toString());
  }

  void _saveCryptoContainer() {
    DiskStorageJSON storageJSON = DiskStorageJSON(diskBlobsContainer: _diskBlobsContainer!, resourceID: _mainContainerResourceID);
    var data = _privateCryptoContainerModel!.getData();
    storageJSON.saveData(data);

    print('write container: ' + data.toString());
  }

  Future<bool> addSeed(String seedKey) async {
    if (!isVolumeOpen) {
      throw 'Volume not open';
    }

    if (!(await _privateCryptoContainerModel!.addSeed(seedKey))) {
      return false;
    }

    _saveCryptoContainer();

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

    _saveCryptoContainer();

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