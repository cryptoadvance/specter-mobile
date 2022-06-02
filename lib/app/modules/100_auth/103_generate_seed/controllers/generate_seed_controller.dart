import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/104_onboarding/controllers/onboarding_controller.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/cryptoService/CCryptoService.dart';
import 'package:specter_mobile/services/CEntropyExternalGenerationService.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoService/CGenerateSeedService.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

class GenerateSeedController extends GetxController {
  Rx<SEED_COMPLEXITY> seed_complexity = SEED_COMPLEXITY.SIMPLE.obs;
  Rx<ENTROPY_SOURCE> entropy_source = ENTROPY_SOURCE.NONE.obs;

  CEntropyExternalGenerationService entropyExternalGenerationService = CEntropyExternalGenerationService();

  late StreamSubscription<SGenerateSeedEvent> _streamSubscription;
  late StreamSubscription<SGenerateEntropyExternalEvent> _streamSubscription2;

  Rx<SGenerateSeedEvent>? lastGenerateSeedEvent = SGenerateSeedEvent(mnemonicKey: '').obs;
  Rx<bool> needTakePhoto = false.obs;
  Rx<bool> capturingVideo = false.obs;
  Rx<SGenerateEntropyExternalEvent> lastGenerateEntropyExternalEvent = SGenerateEntropyExternalEvent().obs;

  @override
  void onInit() {
    super.onInit();

    _streamSubscription = CServices.crypto.generateSeedService.startGenerateSeed(processGenerateSeedEvent);
    _streamSubscription2 = entropyExternalGenerationService.init(processEntropyEvent);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    CServices.crypto.generateSeedService.stopGenerateSeed();
    _streamSubscription.cancel();
    _streamSubscription2.cancel();
    entropyExternalGenerationService.close();
  }

  void processGenerateSeedEvent(SGenerateSeedEvent generateSeedEvent) {
    //print('generate seed event: ' + generateSeedEvent.toString());
    lastGenerateSeedEvent!.value = generateSeedEvent;
    update();
  }

  void setComplexityState(SEED_COMPLEXITY seed_complexity_) {
    seed_complexity.value = seed_complexity_;
    CServices.crypto.generateSeedService.setGenerateSeedComplexity(seed_complexity_);
    update();
  }

  void setEntropySource(context, ENTROPY_SOURCE entropySource) async {
    /*
    if (entropy_source_ == ENTROPY_SOURCE.NONE) {
      await entropyGenerationService.close();
    }*/


    switch(entropySource) {
      case ENTROPY_SOURCE.NONE:
        needTakePhoto.value = false;
        break;
      case ENTROPY_SOURCE.CAMERA:
        needTakePhoto.value = true;
        capturingVideo.value = false;
        break;
    }

    CServices.crypto.generateSeedService.setEntropySource(entropySource);

    entropy_source.value = entropySource;
    update();
  }

  void takePhotoAction(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 150), () async {
      if (!(await entropyExternalGenerationService.start())) {
        entropy_source.value = ENTROPY_SOURCE.NONE;
        update();

        //
        CServices.notify.addNotify(context, 'Can not connect to the camera');
        return;
      }

      capturingVideo.value = true;
    });
  }

  CameraController? getCameraController() {
    return entropyExternalGenerationService.getCameraController();
  }

  void stopTakePhotoAction(BuildContext context) {
    entropyExternalGenerationService.close();
    if (!lastGenerateEntropyExternalEvent.value.isGenerated()) {
      entropy_source.value = ENTROPY_SOURCE.NONE;
      update();

      //
      CServices.notify.addNotify(context, 'Can not use entropy from the camera');
      return;
    }

    //
    Future.delayed(Duration(milliseconds: 150), () {
      needTakePhoto.value = false;
      CServices.crypto.generateSeedService.addExternalEntropy(lastGenerateEntropyExternalEvent.value);
    });
  }

  void processEntropyEvent(SGenerateEntropyExternalEvent seedEvent) {
    //print('entropy (external) event: ' + seedEvent.toString());
    lastGenerateEntropyExternalEvent.value = seedEvent;
  }

  void doneAction(BuildContext context) async {
    String seedKey = lastGenerateSeedEvent!.value.mnemonicKey;
    if (!(await CServices.crypto.privateCryptoContainer.addSeed(seedKey))) {
      await CServices.notify.addMessage(
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
