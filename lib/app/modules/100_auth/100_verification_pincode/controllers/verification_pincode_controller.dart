import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:specter_mobile/globals.dart' as g;
import 'package:specter_mobile/services/CCryptoService.dart';

import 'pincode_input_controller.dart';

class VerificationPinCodeController extends GetxController {
  bool isNeedInitAuth = Get.arguments['isNeedInitAuth'];
  bool viewBiometricAuthButton = false;

  @override
  void onInit() {
    if (isNeedInitAuth) {
      viewBiometricAuthButton = true;
    } else {
      viewBiometricAuthButton = false;
    }
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
      await g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is not entered.',
          actionTitle: 'Try Again'
      );
      return;
    }

    String pinCode = pinCodeInputController.getValue();
    if (pinCode == '0000') {
      await g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is wrong.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    if (isNeedInitAuth) {
      if (!await g.gCryptoService.addCryptoContainerAuth(CryptoContainerType.PIN_CODE)) {
        return;
      }

      if (!await g.gCryptoService.setCryptoContainerPinCode(pinCode)) {
        return;
      }

      openNextPage();
      return;
    }

    //
    if (!(await g.gCryptoService.authCryptoContainer())) {
      await g.gNotificationService.addMessage(
          context, 'Oops!!', 'Can not load crypto container.',
          actionTitle: 'Try Again'
      );
      return;
    }

    if (!await g.gCryptoService.verifyCryptoContainerPinCode(pinCode)) {
      await g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is not correct. \nPlease try again.',
          actionTitle: 'Try Again'
      );
      pinCodeInputController.clean();
      return;
    }

    //
    openNextPage();
  }

  void openNextPage() {
    Get.offAllNamed('/recovery-select');
  }

  void openPrevPage() {
    Get.back();
  }
}
