import 'package:get/get.dart';

import '../controllers/wallet_info_controller.dart';

class WalletInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoController>(
      () => WalletInfoController(),
    );
  }
}
