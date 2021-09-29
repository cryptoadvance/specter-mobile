import 'package:get/get.dart';

import '../controllers/generate_seed_controller.dart';

class GenerateSeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateSeedController>(
      () => GenerateSeedController(),
    );
  }
}
