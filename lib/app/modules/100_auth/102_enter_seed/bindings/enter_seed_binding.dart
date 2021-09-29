import 'package:get/get.dart';

import '../controllers/enter_seed_controller.dart';

class EnterSeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnterSeedController>(
      () => EnterSeedController(),
    );
  }
}
