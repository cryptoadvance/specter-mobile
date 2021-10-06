import 'package:get/get.dart';

enum SEED_COMPLEXITY {
  SIMPLE,
  WORDS_24
}

class GenerateSeedController extends GetxController {
  Rx<SEED_COMPLEXITY> seed_complexity = SEED_COMPLEXITY.SIMPLE.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void setComplexityState(SEED_COMPLEXITY seed_complexity_) {
    seed_complexity.value = seed_complexity_;
    update();
  }

  void openNextPage() {
    Get.toNamed('/onboarding');
  }
}
