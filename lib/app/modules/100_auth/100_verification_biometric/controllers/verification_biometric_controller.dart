import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:specter_mobile/globals.dart' as g;
import 'package:specter_mobile/services/CCryptoService.dart';

class VerificationBiometricController extends GetxController {
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
    if (isNeedInitAuth) {
      if (await g.gCryptoService.addCryptoContainerAuth(CryptoContainerType.BIOMETRIC)) {
        openNextPage();
      }
      return;
    }

    //
    if (!(await g.gCryptoService.authCryptoContainer())) {
      g.gNotificationService.addMessage(
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
}
