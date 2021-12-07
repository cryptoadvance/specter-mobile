import 'dart:convert';

import 'package:specter_mobile/services/CCryptoService.dart';

class CryptoContainerModel {
  final version = 1;
  final List<CryptoContainerType> _authTypes;
  String? _pinCodeSign;

  CryptoContainerModel({
    required authTypes
  }): _authTypes = authTypes;

  void loadStore(Map<String, dynamic> data) {
    _pinCodeSign = data['pinCodeSign'];
  }

  @override
  String toString() {
    return jsonEncode({
      'version': 1,
      'authTypes': getAuthTypes(),
      'pinCodeSign': _pinCodeSign,
      'wallets': []
    });
  }

  List<String> getAuthTypes() {
    List<String> authTypesList = [];
    _authTypes.forEach((authType) {
      authTypesList.add(authType.toShortString());
    });
    return authTypesList;
  }

  void addAuthType(CryptoContainerType authType) {
    if (_authTypes.contains(authType)) {
      return;
    }
    _authTypes.add(authType);
  }

  void setCryptoContainerPinCodeSign(String pinCodeSign) {
    _pinCodeSign = pinCodeSign;
  }

  bool verifyCryptoContainerPinCodeSign(String pinCodeSign) {
    if (_pinCodeSign != pinCodeSign) {
      print('wrong pin code: ' + _pinCodeSign.toString() + ' <> ' + pinCodeSign.toString());
      return false;
    }
    return true;
  }
}