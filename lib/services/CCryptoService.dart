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
    return this.toString().split('.').last;
  }
}

class CCryptoService {
  SharedPreferences? prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    await _openCryptoContainer();
  }

  Future<void> _openCryptoContainer() async {
    List<String>? types = await prefs!.getStringList('types');

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

  Future<bool> isAuthInit() async {
    return cryptoContainerModel!.getAuthTypes().isNotEmpty;
  }

  BiometricStorageFile? store;
  CryptoContainerModel? cryptoContainerModel;

  Future<bool> addCryptoContainerAuth(CryptoContainerType authType) async {
    final authenticate = await _checkAuthenticate();
    if (authenticate == CanAuthenticateResponse.unsupported) {
      print('Unable to use authenticate. Unable to get storage.');
      return false;
    }

    //
    if (store == null) {
      await _initCryptoContainerAuth();
    }

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

  _initCryptoContainerAuth() async {
    if (store != null) {
      throw "already init";
    }

    store = await BiometricStorage().getStorage('storage',
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
  }

  Future<bool> _saveCryptoContainer() async {
    String containerData = cryptoContainerModel.toString();

    try {
      await store!.write(containerData);

      //
      print('saveCryptoContainer: ' + containerData);
      return true;
    } on AuthException catch(e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> _readCryptoContainer() async {
    try {
      String? containerData = await store!.read();
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
    if (store == null) {
      await _initCryptoContainerAuth();
    }

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