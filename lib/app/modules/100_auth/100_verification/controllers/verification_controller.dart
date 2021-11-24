import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:specter_mobile/globals.dart' as g;
import 'package:specter_mobile/services/CCryptoService.dart';

import 'pincode_input_controller.dart';


class VerificationController extends GetxController {
  bool isNeedInitAuth = Get.arguments['isNeedInitAuth'];

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

  void verifyAction(BuildContext context) async {
    PinCodeInputController pinCodeInputController = Get.find<PinCodeInputController>();
    if (!pinCodeInputController.isFilled()) {
      g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is not entered.',
          actionTitle: 'Try Again'
      );
      return;
    }

    String pinCode = pinCodeInputController.getValue();
    if (pinCode == '0000') {
      g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is wrong.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    if (isNeedInitAuth) {
      if (await g.gCryptoService.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        openNextPage();
      }
      return;
    }

    //
    if (!(await g.gCryptoService.authCryptoContainer())) {
      g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is not correct. \nPlease try again.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    openNextPage();
  }

  void openNextPage() {
    Get.offAllNamed('/recovery-select');
  }
}
