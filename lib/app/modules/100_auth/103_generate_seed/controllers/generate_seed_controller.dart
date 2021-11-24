import 'package:get/get.dart';
import 'package:specter_mobile/services/CEntropyGenerationService.dart';

enum SEED_COMPLEXITY {
  SIMPLE,
  WORDS_24
}

class GenerateSeedController extends GetxController {
  Rx<SEED_COMPLEXITY> seed_complexity = SEED_COMPLEXITY.SIMPLE.obs;

  CEntropyGenerationService entropyGenerationService = CEntropyGenerationService();

  @override
  void onInit() {
    entropyGenerationService.init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    entropyGenerationService.close();
  }

  void setComplexityState(SEED_COMPLEXITY seed_complexity_) {
    seed_complexity.value = seed_complexity_;
    update();
  }

  void openNextPage() {
    Get.offAllNamed('/onboarding');
  }
}
