import 'package:get/get.dart';

import '../controllers/create_new_wallet_controller.dart';

class CreateNewWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateNewWalletController>(
      () => CreateNewWalletController(),
    );
  }
}
