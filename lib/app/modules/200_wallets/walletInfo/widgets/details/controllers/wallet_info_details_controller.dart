import 'package:get/get.dart';

class WalletInfoDetailsNode {
  String name;
  String value;
  WalletInfoDetailsNode(this.name, this.value);
}

class WalletInfoDetailsController extends GetxController {
  final List<WalletInfoDetailsNode> list = [
    WalletInfoDetailsNode('Net', 'Mainnet'),
    WalletInfoDetailsNode('Type', 'Single key'),
    WalletInfoDetailsNode('Format', 'Native Segwit'),
    WalletInfoDetailsNode('Derivation', "84h’/1’/0"),
    WalletInfoDetailsNode('Fingerprint', "1234abcd"),
    WalletInfoDetailsNode('Balance', "0.123 BTC"),
    WalletInfoDetailsNode('Balance, fiat', "4’182 USD")
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}