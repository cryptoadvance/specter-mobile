import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';

import 'package:specter_mobile/services/cryptoContainer/CCryptoContainer.dart';
import 'package:specter_mobile/services/CServices.dart';

class VerificationBiometricController extends GetxController {
  bool isNeedInitAuth = Get.arguments['isNeedInitAuth'];

  bool viewPinCodeButton = true;

  @override
  void onInit() {
    viewPinCodeButton = CServices.gCryptoContainer.isAddedPinCodeAuth() || !CServices.gCryptoContainer.isAuthInit();
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
      if (await CServices.gCryptoContainer.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        openNextPage();
      }
      return;
    }

    //
    if (!(await CServices.gCryptoContainer.authCryptoContainer())) {
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
    CServices.gCryptoContainer.openAfterAuthPage();
  }

  void openPinCodePage() {
    Get.toNamed(Routes.VERIFICATION_PINCODE, arguments: {
      'isNeedInitAuth': isNeedInitAuth
    });
  }
}
