import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils.dart';

enum CryptoContainerType {
  NONE, PIN_CODE
}

class CCryptoService {
  SharedPreferences? prefs;
  final storage = new FlutterSecureStorage();

  CryptoContainerType currentCryptoContainerType = CryptoContainerType.NONE;

  init() async {
    prefs = await SharedPreferences.getInstance();
    await getCryptoContainerDetails();
    print('crypto container type: ' + currentCryptoContainerType.toString());
  }

  Future<void> getCryptoContainerDetails() async {
    String? type = await prefs!.getString('type');
    switch(type) {
      case 'CryptoContainerType.PIN_CODE': {
        currentCryptoContainerType = CryptoContainerType.PIN_CODE;
        break;
      }
      default: {
        currentCryptoContainerType = CryptoContainerType.NONE;
        break;
      }
    }
  }

  Future<bool> isAuthInit() async {
    return (currentCryptoContainerType != CryptoContainerType.NONE);
  }

  /*
   * 1. Create crypto container
   * 2. Encrypt crypto container data with pincode
   */
  void initCryptoContainer(CryptoContainerType cryptoContainerType, String pinCode) async {
    var containerData = {
      'version': 1,
      'type': cryptoContainerType.toString(),
      'wallets': []
    };

    //
    int timeStart = Utils.getTimeMs();
    String pinCodeSalted = saltPinCode(pinCode, 1000 * 10);
    int pinCodeGenTime = Utils.getTimeMs() - timeStart;
    print('pinCodeSalted: ' + pinCodeSalted.toString() + ', gen time: ' + pinCodeGenTime.toString() + ' ms');

    //
    final salt = Uint8List(16);
    final key = Key.fromUtf8(pinCode).stretch(32, salt: salt);

    //
    final iv = IV.fromLength(16);

    //encrypt
    final encrypt = Encrypter(AES(key));
    final encrypted = encrypt.encrypt(jsonEncode(containerData), iv: iv);

    //sign
    var digest = sha256.convert(encrypted.bytes);
    print('digest: ' + digest.toString());

    //
    await prefs!.setString('type', cryptoContainerType.toString());
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