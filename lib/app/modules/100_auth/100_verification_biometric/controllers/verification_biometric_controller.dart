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
    viewPinCodeButton = CServices.crypto.cryptoContainer.isAddedPinCodeAuth() || !CServices.crypto.cryptoContainer.isAuthInit();
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
      if (await CServices.crypto.cryptoContainer.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        openNextPage();
      }
      return;
    }

    //
    if (!(await CServices.crypto.cryptoContainer.authCryptoContainer())) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please try again.',
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

  void openPinCodePage() {
    Get.toNamed(Routes.VERIFICATION_PINCODE, arguments: {
      'isNeedInitAuth': isNeedInitAuth
    });
  }
}
