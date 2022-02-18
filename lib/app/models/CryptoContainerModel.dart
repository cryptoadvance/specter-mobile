import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:specter_mobile/services/cryptoContainer/CCryptoContainer.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

class SWalletModel {
  String key;
  String name;
  SWalletDescriptor descriptor;

  SWalletModel({required this.key, required this.name, required this.descriptor});

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  static SWalletModel fromJSON(obj) {
    return SWalletModel(
      key: obj['key'],
      name: obj['name'],
      descriptor: SWalletDescriptor.fromJSON(obj['descriptor'])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'key': key,
      'name': name,
      'descriptor': descriptor.toJSON()
    };
  }
}

class CryptoContainerModel {
  final version = 1;
  final List<CryptoContainerType> _authTypes;
  String? _pinCodeSign;

  List<dynamic> _seedKeys = [];
  List<SWalletModel> _wallets = [];

  CryptoContainerModel({
    required authTypes
  }): _authTypes = authTypes;

  void loadStore(Map<String, dynamic> data) {
    _pinCodeSign = data['pinCodeSign'];
    _seedKeys = data['seedKeys'] ?? [];

    _wallets = [];
    try {
      List<dynamic> _walletsList = data['wallets'] ?? [];
      _walletsList.forEach((wallet) {
        _wallets.add(SWalletModel.fromJSON(wallet));
      });
    } catch(e) {
      if (!kDebugMode) {
        rethrow;
      }
      print(e);
    }
  }

  @override
  String toString() {
    List<dynamic> _walletsList = [];
    _wallets.forEach((wallet) {
      _walletsList.add(wallet.toJSON());
    });
    return jsonEncode({
      'version': 1,
      'authTypes': getAuthTypes(),
      'pinCodeSign': _pinCodeSign,
      'seedKeys': _seedKeys,
      'wallets': _walletsList
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
      _seedKeys.add({
        'mnemonic': seedKey
      });
      return true;
  }

  Future<bool> addNewWallet(SWalletModel wallet) async {
    _wallets.add(wallet);
    return true;
  }

  bool isSeedsInit() {
    return _seedKeys.isNotEmpty;
  }

  bool isWalletsInit() {
    return _wallets.isNotEmpty;
  }

  String getMnemonicByIdx(int idx) {
    return _seedKeys[idx]['mnemonic'];
  }

  List<SWalletModel> getWallets() {
    return _wallets;
  }
}