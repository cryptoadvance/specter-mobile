import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';

import '../utils.dart';

enum CryptoContainerType {
  PIN_CODE,
  BIOMETRIC
}

extension ParseToString on CryptoContainerType {
  String toShortString() {
    return toString().split('.').last;
  }
}

class CCryptoService {
  SharedPreferences? prefs;

  CryptoContainerType? currentAuthType;
  CryptoContainerModel? cryptoContainerModel;
  Map<CryptoContainerType, BiometricStorageFile> stores = HashMap();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await _openCryptoContainer();
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
    final authenticate = await _checkAuthenticate();
    if (authenticate == CanAuthenticateResponse.unsupported) {
      print('Unable to use authenticate. Unable to get storage.');
      return false;
    }

    //
    currentAuthType = authType;
    BiometricStorageFile store = await _getCryptoContainer(authType);

    //
    cryptoContainerModel!.authTypes.add(authType);

    //
    if (!await _saveCryptoContainer()) {
      return false;
    }

    //
    await prefs!.setStringList('types', cryptoContainerModel!.getAuthTypes());
    return true;
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

    try {
      String details = (await store.getDetails())!;
      print('details: ' + details);
    }
    catch(e) {
      print(e.toString());
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
              saveTitle: 'Custom save title',
              accessTitle: 'Custom access title.',
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
      print('readCryptoContainer: ' + containerData);
      return true;
    } on AuthException catch(e) {
      print(e.toString());
    }
    return false;
  }

  Future<CanAuthenticateResponse> _checkAuthenticate() async {
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

  String saltPinCode(String pinCode, int rounds) {
    var sign;
    var bytes = utf8.encode(pinCode);
    for (int i = 0; i < rounds; i++) {
      sign = sha256.convert(bytes);
      bytes = sign.bytes;
    }
    return sign.toString();
  }
}