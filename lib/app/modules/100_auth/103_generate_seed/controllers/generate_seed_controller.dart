import 'dart:async';

import 'package:get/get.dart';
import 'package:specter_mobile/services/cryptoService/CCryptoService.dart';
import 'package:specter_mobile/services/CEntropyGenerationService.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoService/CGenerateSeedService.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

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

  late StreamSubscription<SGenerateSeedEvent> _streamSubscription;

  RxList<String> seedWords = RxList.empty();

  @override
  void onInit() {
    super.onInit();

    _streamSubscription = CServices.gCryptoService.startGenerateSeed(processGenerateSeedEvent);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    CServices.gCryptoService.stopGenerateSeed();
    _streamSubscription.cancel();
    entropyGenerationService.close();
  }

  void processGenerateSeedEvent(SGenerateSeedEvent generateSeedEvent) {
    print('generate seed event: ' + generateSeedEvent.toString());
    seedWords.value = generateSeedEvent.seedWords;
    update();
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
          CServices.gNotificationService.addNotify(context, 'Can not connect to the camera');
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
