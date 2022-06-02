import 'dart:convert';

import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeScanner.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import '../CServices.dart';

class SCryptoTransactionPoint {
  final String address;
  final double value;
  final String walletKey;

  SCryptoTransactionPoint({
    required this.address,
    required this.value,
    required this.walletKey
  });

  Map<String, dynamic> toJSON() {
    return {
      'address': address,
      'value': value,
      'wallet': walletKey
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }
}

class SCryptoTransactionModel {
  final double fee;
  final List<SCryptoTransactionPoint> inputs;
  final List<SCryptoTransactionPoint> outputs;
  
  SCryptoTransactionModel({
    required this.fee,
    required this.inputs,
    required this.outputs
  });

  Map<String, dynamic> toJSON() {
    List<dynamic> inputsJson = [];
    List<dynamic> outputsJson = [];

    inputs.forEach((el) {
      inputsJson.add(el);
    });
    outputsJson.forEach((el) {
      outputsJson.add(el);
    });

    return {
      'fee': fee,
      'inputs': inputsJson,
      'output': outputsJson
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }
}

class CControlTransactionsService {
  late final CCryptoProvider _cryptoProvider;

  CControlTransactionsService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider;

  bool parseTransaction(QRCodeScannerResultParseTransaction transaction) {
    List<SWalletModel> wallets = CServices.crypto.privateCryptoContainer.getWallets();
    CServices.crypto.cryptoProvider.parseTransaction(transaction, wallets, WalletNetwork.BITCOIN);
    return true;
  }
}