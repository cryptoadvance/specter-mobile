import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/wallet_info_address_controller.dart';

class WalletInfoAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoAddressController>(() => WalletInfoAddressController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());
  }
}
