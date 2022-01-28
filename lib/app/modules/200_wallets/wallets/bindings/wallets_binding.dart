import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';

import '../controllers/wallets_controller.dart';

class KeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletsController>(() => WalletsController());
    Get.create<SlidingUpPanelController>(() => SlidingUpPanelController());
  }
}
