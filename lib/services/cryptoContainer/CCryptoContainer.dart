import 'dart:collection';
import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import 'CCryptoLocalSign.dart';
import '../../utils.dart';

enum CryptoContainerType {
  PIN_CODE,
  BIOMETRIC
}

extension ParseToString on CryptoContainerType {
  String toShortString() {
    return toString().split('.').last;
  }
}

/*
 * Manages data storage in the secure storage
 */
class CCryptoContainer {
  SharedPreferences? prefs;

  CryptoContainerType? currentAuthType;
  CryptoContainerModel? cryptoContainerModel;
  Map<CryptoContainerType, BiometricStorageFile> stores = HashMap();

  final CCryptoLocalSign _cryptoLocalSign = CCryptoLocalSign();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await _openCryptoContainer();

    CCryptoLocalSignResult? signResult = await _cryptoLocalSign.getLocalCryptoSign(CCryptoLocalSignPurpose.PIN_CODE, 'test');
    print('local sign test: ' + signResult.toString());
  }

  Future<void> _openCryptoContainer() async {
    List<String>? types = prefs!.getStringList('types');

    List<CryptoContainerType> authTypes = [];
    types?.forEach((authType) {
      switch(authType) {
        case 'PIN_CODE': {
          authTypes.add(CryptoContainerType.PIN_CODE);
          break;
        }
        case 'BIOMETRIC': {
          authTypes.add(CryptoContainerType.BIOMETRIC);
          break;
        }
      }
    });

    print('load authTypes: ' + authTypes.toString());

    cryptoContainerModel = CryptoContainerModel(
        authTypes: authTypes
    );
  }

  bool isAuthInit() {
    List<String> authTypes = cryptoContainerModel!.getAuthTypes();
    return authTypes.isNotEmpty;
  }

  bool isAddedBiometricAuth() {
    List<String> authTypes = cryptoContainerModel!.getAuthTypes();
    return authTypes.contains(CryptoContainerType.BIOMETRIC.toShortString());
  }

  bool isAddedPinCodeAuth() {
    List<String> authTypes = cryptoContainerModel!.getAuthTypes();
    return authTypes.contains(CryptoContainerType.PIN_CODE.toShortString());
  }

  Future<bool> addCryptoContainerAuth(CryptoContainerType authType) async {
    if (authType == CryptoContainerType.BIOMETRIC) {
      final authenticate = await _checkBiometricAuthenticate();
      if (authenticate == CanAuthenticateResponse.unsupported) {
        print('Unable to use authenticate. Unable to get storage.');
        return false;
      }
    }

    //
    currentAuthType = authType;
    BiometricStorageFile store = await _getCryptoContainer(authType);

    //
    cryptoContainerModel!.addAuthType(authType);

    //
    if (!(await _saveCryptoContainer())) {
      return false;
    }

    //
    await prefs!.setStringList('types', cryptoContainerModel!.getAuthTypes());
    return true;
  }

  Future<bool> setCryptoContainerPinCode(String pinCode) async {
    if (currentAuthType != CryptoContainerType.PIN_CODE) {
      return false;
    }

    CCryptoLocalSignResult? signResult = await _cryptoLocalSign.getLocalCryptoSign(CCryptoLocalSignPurpose.PIN_CODE, pinCode);
    if (signResult == null) {
      return false;
    }

    print('pinCodeSign: ' + signResult.sign!);

    cryptoContainerModel!.setCryptoContainerPinCodeSign(signResult.sign!);

    if (!(await _saveCryptoContainer())) {
      return false;
    }

    return true;
  }

  Future<bool> verifyCryptoContainerPinCode(String pinCode) async {
    if (currentAuthType != CryptoContainerType.PIN_CODE) {
      return false;
    }

    CCryptoLocalSignResult? signResult = await _cryptoLocalSign.getLocalCryptoSign(CCryptoLocalSignPurpose.PIN_CODE, pinCode);
    if (signResult == null) {
      return false;
    }

    print('pinCodeSign: ' + signResult.sign!);

    return cryptoContainerModel!.verifyCryptoContainerPinCodeSign(signResult.sign!);
  }

  Future<BiometricStorageFile> _getCurrentCryptoContainer() {
    return _getCryptoContainer(currentAuthType!);
  }

  Future<BiometricStorageFile> _getCryptoContainer(CryptoContainerType authType) async {
    if (stores.containsKey(authType)) {
      return stores[authType]!;
    }

    BiometricStorageFile store;
    switch(authType) {
      case CryptoContainerType.BIOMETRIC: {
        store = await _initCryptoContainerBiometric();
        break;
      }
      case CryptoContainerType.PIN_CODE:
        store = await _initCryptoContainerPinCode();
        break;
    }

    if (!Utils.isIOS()) {
      try {
        String details = (await store.getDetails())!;
        print('details: ' + details);
      }
      catch(e) {
        print(e.toString());
      }
    }

    stores[authType] = store;
    return stores[authType]!;
  }

  Future<BiometricStorageFile> _initCryptoContainerPinCode() async {
    BiometricStorageFile store = await BiometricStorage().getStorage('storage_pincode',
        options: StorageFileInitOptions(
            androidBiometricOnly: false,
            authenticationRequired: false,
            authenticationValidityDurationSeconds: 10
        )
    );
    return store;
  }

  Future<BiometricStorageFile> _initCryptoContainerBiometric() async {
    BiometricStorageFile store = await BiometricStorage().getStorage('storage_biometric',
        options: StorageFileInitOptions(
            androidBiometricOnly: true,
            authenticationRequired: true,
            authenticationValidityDurationSeconds: 10
        ),
        promptInfo: const PromptInfo(
            iosPromptInfo: IosPromptInfo(
              saveTitle: 'Verify your identity',
              accessTitle: 'Verify your identity',
            ),
            androidPromptInfo: AndroidPromptInfo(
              title: 'Verify your identity',
              description: 'Touch the fingerprint sensor',
              negativeButton: 'Cancel',
            )
        )
    );
    return store;
  }

  Future<bool> _saveCryptoContainer() async {
    String containerData = cryptoContainerModel.toString();

    BiometricStorageFile store = await _getCurrentCryptoContainer();

    try {
      await store.write(containerData);

      //
      print('saveCryptoContainer: ' + containerData);
      return true;
    } on AuthException catch(e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> _readCryptoContainer() async {
    BiometricStorageFile store = await _getCurrentCryptoContainer();

    try {
      String? containerData = await store.read();
      if (containerData == null) {
        return false;
      }

      //
      Map<String, dynamic> data = jsonDecode(containerData);
      cryptoContainerModel!.loadStore(data);

      //
      print('readCryptoContainer: ' + containerData);
      print('loadedCryptoContainer: ' + cryptoContainerModel.toString());
      return true;
    } on AuthException catch(e) {
      print(e.toString());
    }
    return false;
  }

  Future<CanAuthenticateResponse> _checkBiometricAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    return response;
  }

  Future<bool> authCryptoContainer() async {
    if (isAddedPinCodeAuth()) {
      currentAuthType = CryptoContainerType.PIN_CODE;
    } else {
      currentAuthType = CryptoContainerType.BIOMETRIC;
    }

    //
    BiometricStorageFile store = await _getCurrentCryptoContainer();

    if (!(await _readCryptoContainer())) {
      print('authCryptoContainer - error');
      return false;
    }

    print('authCryptoContainer - success');
    return true;
  }

  Future<bool> addSeed(String seedKey) async {
    if (!(await cryptoContainerModel!.addSeed(seedKey))) {
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
    String key = walletDescriptor.getWalletKey();
    SWalletModel wallet = SWalletModel(key: key, name: walletName, descriptor: walletDescriptor);
    if (!(await cryptoContainerModel!.addNewWallet(wallet))) {
      return false;
    }

    if (!(await _saveCryptoContainer())) {
      return false;
    }

    return true;
  }

  bool isSeedsInit() {
    return cryptoContainerModel!.isSeedsInit();
  }

  bool isWalletsInit() {
    return cryptoContainerModel!.isWalletsInit();
  }

  String getMnemonicByIdx(int idx) {
    return cryptoContainerModel!.getMnemonicByIdx(idx);
  }

  List<SWalletModel> getWallets() {
    return cryptoContainerModel!.getWallets();
  }
}