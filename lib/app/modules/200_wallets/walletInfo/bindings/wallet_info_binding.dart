import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/wallet_info_controller.dart';

class WalletInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInfoController>(() => WalletInfoController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());
  }
}
