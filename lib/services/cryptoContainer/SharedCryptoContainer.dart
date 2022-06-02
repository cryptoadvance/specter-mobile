import 'dart:collection';
import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'shared/CCryptoLocalSign.dart';
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
class SharedCryptoContainer {
  SharedPreferences? prefs;

  CryptoContainerType? currentAuthType;
  SharedCryptoContainerModel? sharedCryptoContainerModel;
  Map<CryptoContainerType, BiometricStorageFile> stores = HashMap();

  final CCryptoLocalSign _cryptoLocalSign = CCryptoLocalSign();

  String currentVolumePass = '';

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

    sharedCryptoContainerModel = SharedCryptoContainerModel(
      authTypes: authTypes
    );
  }

  bool isAuthInit() {
    List<String> authTypes = sharedCryptoContainerModel!.getAuthTypes();
    return authTypes.isNotEmpty;
  }

  bool isAddedBiometricAuth() {
    List<String> authTypes = sharedCryptoContainerModel!.getAuthTypes();
    return authTypes.contains(CryptoContainerType.BIOMETRIC.toShortString());
  }

  bool isAddedPinCodeAuth() {
    List<String> authTypes = sharedCryptoContainerModel!.getAuthTypes();
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
    sharedCryptoContainerModel!.addAuthType(authType);

    if (!sharedCryptoContainerModel!.isAppInit()) {
      if (!CServices.crypto.privateCryptoContainer.createDefaultVolume()) {
        print('Can not create default volume');
        return false;
      }

      print('Default volume created');
      sharedCryptoContainerModel!.setAppInit();
    }

    //
    if (!(await _saveCryptoContainer())) {
      return false;
    }

    //
    await prefs!.setStringList('types', sharedCryptoContainerModel!.getAuthTypes());
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

    sharedCryptoContainerModel!.setCryptoContainerPinCodeSign(signResult.sign!);

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

    return sharedCryptoContainerModel!.verifyCryptoContainerPinCodeSign(signResult.sign!);
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
    String containerData = sharedCryptoContainerModel.toString();

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
      if (!sharedCryptoContainerModel!.loadStore(data)) {
        return false;
      }

      //
      print('readCryptoContainer: ' + containerData);
      print('loadedCryptoContainer: ' + sharedCryptoContainerModel.toString());
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

  Future<bool> tryOpenSharedCryptoContainer() async {
    if (isAddedPinCodeAuth()) {
      currentAuthType = CryptoContainerType.PIN_CODE;
    } else {
      currentAuthType = CryptoContainerType.BIOMETRIC;
    }

    //
    if (!(await _readCryptoContainer())) {
      print('authCryptoContainer - error');
      return false;
    }

    print('authCryptoContainer - success');
    return true;
  }
  
  bool isAppInit() {
    return sharedCryptoContainerModel!.isAppInit();
  }
}