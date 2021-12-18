import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:specter_mobile/services/CCryptoService.dart';
import 'package:specter_mobile/services/CServices.dart';

class VerificationBiometricController extends GetxController {
  bool isNeedInitAuth = Get.arguments['isNeedInitAuth'];

  bool viewPinCodeButton = true;

  @override
  void onInit() {
    viewPinCodeButton = CServices.gCryptoService.isAddedPinCodeAuth() || !CServices.gCryptoService.isAuthInit();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void verifyAction(BuildContext context) async {
    if (isNeedInitAuth) {
      if (await CServices.gCryptoService.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        openNextPage();
      }
      return;
    }

    //
    if (!(await CServices.gCryptoService.authCryptoContainer())) {
      await CServices.gNotificationService.addMessage(
          context, 'Oops!!', 'Please try again.',
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

  void openPinCodePage() {
    Get.toNamed('/verification-pincode', arguments: {
      'isNeedInitAuth': isNeedInitAuth
    });
  }
}
