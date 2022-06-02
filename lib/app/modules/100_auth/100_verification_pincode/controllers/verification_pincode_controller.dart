import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:specter_mobile/services/cryptoContainer/SharedCryptoContainer.dart';
import 'package:specter_mobile/services/CServices.dart';

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
      await CServices.notify.addMessage(
          context, 'Oops!!', 'The PIN-code is not entered.',
          actionTitle: 'Try Again'
      );
      return;
    }

    String pinCode = pinCodeInputController.getValue();
    if (pinCode == '0000') {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'The PIN-code is wrong.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    if (isNeedInitAuth) {
      if (!await CServices.crypto.sharedCryptoContainer.addCryptoContainerAuth(CryptoContainerType.PIN_CODE)) {
        return;
      }

      if (!await CServices.crypto.sharedCryptoContainer.setCryptoContainerPinCode(pinCode)) {
        return;
      }

      if (!CServices.crypto.tryOpenPrivateCryptoContainer('')) {
        await CServices.notify.addMessage(
            context, 'Oops!!', 'Can not open volume',
            actionTitle: 'Try Again'
        );
        return;
      }

      openNextPage();
      return;
    }

    //
    if (!(await CServices.crypto.sharedCryptoContainer.tryOpenSharedCryptoContainer())) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Can not load crypto container.',
          actionTitle: 'Try Again'
      );
      return;
    }

    if (!await CServices.crypto.sharedCryptoContainer.verifyCryptoContainerPinCode(pinCode)) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'The PIN-code is not correct. \nPlease try again.',
          actionTitle: 'Try Again'
      );
      pinCodeInputController.clean();
      return;
    }

    if (!CServices.crypto.tryOpenPrivateCryptoContainer('')) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Can not open volume',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    openNextPage();
  }

  void openNextPage() {
    CServices.crypto.openAfterAuthPage();
  }

  void openPrevPage() {
    Get.back();
  }
}
