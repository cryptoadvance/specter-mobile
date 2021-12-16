import 'package:get/get.dart';
import 'package:specter_mobile/services/CEntropyGenerationService.dart';

import 'package:specter_mobile/globals.dart' as g;

enum SEED_COMPLEXITY {
  SIMPLE,
  WORDS_24
}

enum ENTROPY_SOURCE {
  NONE,
  CAMERA
}

class GenerateSeedController extends GetxController {
  Rx<SEED_COMPLEXITY> seed_complexity = SEED_COMPLEXITY.SIMPLE.obs;
  Rx<ENTROPY_SOURCE> entropy_source = ENTROPY_SOURCE.NONE.obs;

  CEntropyGenerationService entropyGenerationService = CEntropyGenerationService();

  @override
  void onInit() {
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

  void setEntropySource(context, ENTROPY_SOURCE entropy_source_) async {
    if (entropy_source_ == ENTROPY_SOURCE.CAMERA) {
      Future.delayed(Duration(milliseconds: 150), () async {
        if (!(await entropyGenerationService.init())) {
          entropy_source.value = ENTROPY_SOURCE.NONE;
          update();

          //
          g.gNotificationService.addNotify(context, 'Can not connect to the camera');
        }
      });
    }
    if (entropy_source_ == ENTROPY_SOURCE.NONE) {
      await entropyGenerationService.close();
    }
    entropy_source.value = entropy_source_;
    update();
  }

  void openNextPage() {
    Get.offAllNamed('/onboarding');
  }
}
