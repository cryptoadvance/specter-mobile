import 'dart:convert';

import 'package:flutter/services.dart';

enum CCryptoLocalSignAlgorithm {
  HMAC_SHA256
}

enum CCryptoLocalSignPurpose {
  PIN_CODE
}

extension ParseToString on CCryptoLocalSignPurpose {
  String toShortString() {
    return toString().split('.').last;
  }
}


class CCryptoLocalSignResult {
  final CCryptoLocalSignAlgorithm? _type;

  String? _sign;

  CCryptoLocalSignResult({
    required CCryptoLocalSignAlgorithm type
  }): _type = type;

  set sign(String? sign) {
    _sign = sign;
  }

  String? get sign => _sign;

  CCryptoLocalSignAlgorithm? get type => _type;

  @override
  String toString() {
    return jsonEncode({
      'sign': _sign
    });
  }
}

/*
 * Controls the execution of cryptographic operations in the KeyStore (Android), Secure Enclave (iOS)
 */
class CCryptoLocalSign {
  static const platform = MethodChannel('specter.mobile/service');

  Future<CCryptoLocalSignResult?> getLocalCryptoSign(CCryptoLocalSignPurpose purpose, String toSign) async {
    CCryptoLocalSignResult? signResult = await _HmacSHA256Sign(purpose toSign);
    return signResult;
  }

  Future<CCryptoLocalSignResult?> _HmacSHA256Sign(CCryptoLocalSignPurpose purpose, String toSign) async {
    CCryptoLocalSignResult signResult = CCryptoLocalSignResult(
        type: CCryptoLocalSignAlgorithm.HMAC_SHA256
    );

    try {
      final String result = await platform.invokeMethod('HmacSHA256Sign', {
        'keyName': purpose.toShortString(),
        'toSign': toSign
      });
      Map<String, dynamic> data = jsonDecode(result);
      if (!data.containsKey('sign')) {
        return null;
      }
      print(data);

      signResult.sign = data['sign'];

      return signResult;
    } on PlatformException catch (e) {
      return null;
    }
  }
}