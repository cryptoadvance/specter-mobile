import 'package:get/get.dart';

import '../controllers/wallet_info_transactions_controller.dart';

class WalletInfoTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoTransactionController>(
      () => WalletInfoTransactionController(),
    );
  }
}
