import 'dart:convert';

import 'package:specter_mobile/services/CCryptoService.dart';

class CryptoContainerModel {
  final version = 1;
  final List<CryptoContainerType> authTypes;

  CryptoContainerModel({required this.authTypes});

  @override
  String toString() {
    return jsonEncode({
      'version': 1,
      'authTypes': getAuthTypes(),
      'wallets': []
    });
  }

  List<String> getAuthTypes() {
    List<String> authTypesList = [];
    authTypes.forEach((authType) {
      authTypesList.add(authType.toShortString());
    });
    return authTypesList;
  }
}