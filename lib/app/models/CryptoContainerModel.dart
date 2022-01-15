import 'dart:convert';

import 'package:specter_mobile/services/cryptoContainer/CCryptoContainer.dart';

class CryptoContainerModel {
  final version = 1;
  final List<CryptoContainerType> _authTypes;
  String? _pinCodeSign;
  String? _seedKey;

  List<dynamic> _wallets = [];


  CryptoContainerModel({
    required authTypes
  }): _authTypes = authTypes;

  void loadStore(Map<String, dynamic> data) {
    _pinCodeSign = data['pinCodeSign'];
    _seedKey = data['seedKey'];
    _wallets = data['wallets'];
  }

  @override
  String toString() {
    return jsonEncode({
      'version': 1,
      'authTypes': getAuthTypes(),
      'pinCodeSign': _pinCodeSign,
      'seedKey': _seedKey,
      'wallets': _wallets
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

  Future<bool> addSeed(String seedKey) async {
    _seedKey = seedKey;
    return true;
  }

  Future<bool> addNewWallet({required String walletName}) async {
    _wallets.add({
      'name': walletName
    });
    return true;
  }

  bool isSeedInit() {
    return _seedKey != null;
  }

  bool isWalletsInit() {
    return _wallets.isNotEmpty;
  }
}