import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';

import 'package:specter_mobile/services/cryptoContainer/SharedCryptoContainer.dart';
import 'package:specter_mobile/services/CServices.dart';

class VerificationBiometricController extends GetxController {
  bool isNeedInitAuth = Get.arguments['isNeedInitAuth'];

  bool viewPinCodeButton = true;

  @override
  void onInit() {
    viewPinCodeButton = CServices.crypto.sharedCryptoContainer.isAddedPinCodeAuth() || !CServices.crypto.sharedCryptoContainer.isAuthInit();
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
      if (await CServices.crypto.sharedCryptoContainer.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        if (!CServices.crypto.tryOpenPrivateCryptoContainer('')) {
          await CServices.notify.addMessage(
              context, 'Oops!!', 'Can not open volume',
              actionTitle: 'Try Again'
          );
          return;
        }

        openNextPage();
      }
      return;
    }

    //
    if (!(await CServices.crypto.sharedCryptoContainer.tryOpenSharedCryptoContainer())) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please try again.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
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

  void openPinCodePage() {
    Get.toNamed(Routes.VERIFICATION_PINCODE, arguments: {
      'isNeedInitAuth': isNeedInitAuth
    });
  }
}
