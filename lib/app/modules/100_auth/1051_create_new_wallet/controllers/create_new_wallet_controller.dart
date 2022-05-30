import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/104_onboarding/controllers/onboarding_controller.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CCryptoExceptions.dart';
import 'package:specter_mobile/services/CServices.dart';

class CreateNewWalletController extends GetxController {
  TextEditingController nameInputController = TextEditingController();

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

  void viewTap(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void createWallet(BuildContext context) async {
    FocusScope.of(context).unfocus();

    String walletName = nameInputController.text.trim();
    if (walletName.isEmpty) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please enter wallet name.',
          actionTitle: 'Try Again'
      );
      return;
    }

    if (walletName.length > 200) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Wallet name is too long.',
          actionTitle: 'Try Again'
      );
      return;
    }

    try {
      if (!(await CServices.crypto.controlWalletsService.addNewWallet(walletName: walletName))) {
        await CServices.notify.addMessage(
            context, 'Oops!!', 'Please try again.',
            actionTitle: 'Try Again'
        );
        return;
      }
    } on CCryptoExceptionsWalletExists catch (e) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Wallet exists.',
          actionTitle: 'Try Again'
      );
      return;
    }

    await Get.offAllNamed(Routes.ONBOARDING, arguments: {
      'onboardingMessageType': ONBOARDING_MESSAGE_TYPE.WALLET_READY
    });
  }
}
