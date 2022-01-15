import 'package:get/get.dart';

import '../controllers/add_wallet_controller.dart';

class AddWalletSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWalletSelectController>(
      () => AddWalletSelectController(),
    );
  }
}
