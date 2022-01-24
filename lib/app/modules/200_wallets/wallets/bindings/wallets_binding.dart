import 'package:get/get.dart';

import '../controllers/wallets_controller.dart';

class KeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletsController>(
      () => WalletsController(),
    );
  }
}
