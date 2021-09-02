import 'package:get/get.dart';

import '../controllers/recovery_select_controller.dart';

class RecoverySelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoverySelectController>(
      () => RecoverySelectController(),
    );
  }
}
