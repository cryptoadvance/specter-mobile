import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/addresses/contollers/wallet_info_addresses_controller.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/details/controllers/wallet_info_details_controller.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/transactions/controllers/wallet_info_transactions_controller.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/wallet_info_controller.dart';

class WalletInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoController>(() => WalletInfoController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());

    Get.create<WalletInfoDetailsController>(() => WalletInfoDetailsController());
    Get.create<WalletInfoAddressesController>(() => WalletInfoAddressesController());
    Get.create<WalletInfoTransactionsController>(() => WalletInfoTransactionsController());
  }
}
