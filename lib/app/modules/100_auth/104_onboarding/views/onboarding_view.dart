import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
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
              child: Text('onboarding_labels_top_label'.tr, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16))
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
      child: Container(
        width: double.infinity,
        child: Text('onboarding_buttons_next_page'.tr, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ),
      onTap: controller.openNextPage
    );
  }
}
