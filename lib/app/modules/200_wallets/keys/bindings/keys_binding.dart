import 'package:get/get.dart';

import '../controllers/keys_controller.dart';

class KeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeysController>(
      () => KeysController(),
    );
  }
}
