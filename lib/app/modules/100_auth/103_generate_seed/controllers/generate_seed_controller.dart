import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/104_onboarding/controllers/onboarding_controller.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/cryptoService/CCryptoService.dart';
import 'package:specter_mobile/services/CEntropyGenerationService.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoService/CGenerateSeedService.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

class GenerateSeedController extends GetxController {
  Rx<SEED_COMPLEXITY> seed_complexity = SEED_COMPLEXITY.SIMPLE.obs;
  Rx<ENTROPY_SOURCE> entropy_source = ENTROPY_SOURCE.NONE.obs;

  CEntropyGenerationService entropyGenerationService = CEntropyGenerationService();

  late StreamSubscription<SGenerateSeedEvent> _streamSubscription;

  Rx<SGenerateSeedEvent>? lastGenerateSeedEvent = SGenerateSeedEvent(seedWords: [], seedKey: '').obs;

  @override
  void onInit() {
    super.onInit();

    _streamSubscription = CServices.gCryptoService.generateSeedService.startGenerateSeed(processGenerateSeedEvent);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    CServices.gCryptoService.generateSeedService.stopGenerateSeed();
    _streamSubscription.cancel();
    entropyGenerationService.close();
  }

  void processGenerateSeedEvent(SGenerateSeedEvent generateSeedEvent) {
    //print('generate seed event: ' + generateSeedEvent.toString());
    lastGenerateSeedEvent!.value = generateSeedEvent;
    update();
  }

  void setComplexityState(SEED_COMPLEXITY seed_complexity_) {
    seed_complexity.value = seed_complexity_;
    CServices.gCryptoService.generateSeedService.setGenerateSeedComplexity(seed_complexity_);
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

  void doneAction(BuildContext context) async {
    String seedKey = lastGenerateSeedEvent!.value.seedKey;
    if (!(await CServices.gCryptoContainer.addSeed(seedKey))) {
      await CServices.gNotificationService.addMessage(
        context, 'Oops!!', 'Please try again.',
        actionTitle: 'Try Again'
      );
      return;
    }

    await Get.offAllNamed(Routes.ONBOARDING, arguments: {
      'onboardingMessageType': ONBOARDING_MESSAGE_TYPE.RECOVERY_SET_UP_SUCCESS
    });
  }
}
