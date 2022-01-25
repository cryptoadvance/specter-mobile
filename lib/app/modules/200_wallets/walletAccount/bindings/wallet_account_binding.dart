import 'package:get/get.dart';

import '../controllers/wallet_account_controller.dart';

class WalletAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletAccountController>(
      () => WalletAccountController(),
    );
  }
}
