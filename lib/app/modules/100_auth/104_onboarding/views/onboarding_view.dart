import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    String messageLabel;
    switch(controller.onboardingMessageType) {
      case ONBOARDING_MESSAGE_TYPE.RECOVERY_SET_UP_SUCCESS:
        messageLabel = 'onboarding_labels_recovery_set_up_success'.tr;
        break;
      case ONBOARDING_MESSAGE_TYPE.WALLET_READY:
        messageLabel = 'onboarding_labels_wallet_ready'.tr;
        break;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 200
              ),
              child: Image.asset('assets/stickers/ghost_sad-x512.png')
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text('onboarding_labels_top_title'.tr, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24, fontWeight: FontWeight.bold))
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(messageLabel, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16))
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              width: 200,
              child: getNextButton()
            )
          ]
        )
      )
    );
  }

  Widget getNextButton() {
    return LightButton(
      onTap: controller.openNextPage,
      child: Container(
        width: double.infinity,
        child: Text('onboarding_buttons_next_page'.tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      )
    );
  }
}
