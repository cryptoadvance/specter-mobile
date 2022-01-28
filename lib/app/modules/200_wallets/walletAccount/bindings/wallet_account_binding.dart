import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/wallet_account_controller.dart';

class WalletAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletAccountController>(() => WalletAccountController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());
  }
}
