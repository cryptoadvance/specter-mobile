import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfoAddress/widgets/details/widgets/WalletInfoAddressDetailsList.dart';

class WalletInfoTransactionInfoController extends GetxController {
  final List<WalletInfoAddressDetailsNode> list = [
    WalletInfoAddressDetailsNode('Net', 'Mainnet'),
    WalletInfoAddressDetailsNode('From wallet', 'My wallet'),
    WalletInfoAddressDetailsNode('Size', '113 bytes'),
    WalletInfoAddressDetailsNode('Mined at block', '200507'),
    WalletInfoAddressDetailsNode('Block date', 'Jun 21, 2021'),
    WalletInfoAddressDetailsNode('Block time', '17:31:14'),
    WalletInfoAddressDetailsNode('Inputs', '1'),
    WalletInfoAddressDetailsNode('Outputs', '2'),
    WalletInfoAddressDetailsNode('Received', '0.01818284 BTC')
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
  void onClose() {}
}