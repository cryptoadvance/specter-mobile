import 'package:get/get.dart';

import '../controllers/hello_controller.dart';

class HelloBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelloController>(
      () => HelloController(),
    );
  }
}
