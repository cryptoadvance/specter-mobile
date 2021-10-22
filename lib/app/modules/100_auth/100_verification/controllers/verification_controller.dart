import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:specter_mobile/globals.dart' as g;

import 'pincode_input_controller.dart';


class VerificationController extends GetxController {
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

  void verifyAction(BuildContext context) {
    PinCodeInputController pinCodeInputController = Get.find<PinCodeInputController>();
    String pinCode = pinCodeInputController.getValue();
    if (pinCode == '0000') {
      g.gNotificationService.addMessage(
          context, 'Oops!!', 'The PIN-code is not correct.\n Please try again.',
          actionTitle: 'Try Again'
      );
      return;
    }

    //
    Get.toNamed('/recovery-select');
  }
}
