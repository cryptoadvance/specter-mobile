import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/104_onboarding/controllers/onboarding_controller.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoService/CRecoverySeedService.dart';

import 'enter_recovery_phrase_list_controller.dart';

class EnterRecoveryPhraseController extends GetxController {
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

  void doneAction(BuildContext context) async {
    FocusScope.of(context).unfocus();

    //
    final EnterRecoveryPhraseListController enterSeedListController = Get.find<EnterRecoveryPhraseListController>();
    List<String> recoveryPhrases = enterSeedListController.getSeedList();
    if (recoveryPhrases.isEmpty) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please enter recovery phrase.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    RecoverySeedResult? recoverySeedResult = await CServices.crypto.recoverySeedService.verifyRecoveryPhrase(recoveryPhrases);
    if (recoverySeedResult == null) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please enter correct recovery phrase.',
          actionTitle: 'Try Again'
      );
      return;
    }

    String seedKey = recoverySeedResult.seedKey;
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
