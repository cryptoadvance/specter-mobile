import 'package:get/get.dart';

import '../controllers/wallet_info_address_controller.dart';

class WalletInfoAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoAddressController>(
      () => WalletInfoAddressController(),
    );
  }
}
