import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import 'package:specter_mobile/app/widgets/keyboard/KeyboardController.dart';
import 'package:specter_mobile/app/widgets/keyboard/KeyboardView.dart';

import '../controllers/enter_recovery_phrase_screen_controller.dart';
import 'enter_recovery_phrase_list_view.dart';

class EnterRecoveryPhraseView extends GetView<EnterRecoveryPhraseController> {
  final KeyboardController _keyboardController = Get.find<KeyboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text('Recovery phrase', textAlign: TextAlign.center, style: TextStyle(fontSize: 24))
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                    child: EnterRecoveryPhraseListView(keyboardController: _keyboardController)
                )
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: getBottomButtonsPanel(context)
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: KeyboardView(controller: _keyboardController)
            )
          ]
        )
      )
    );
  }

  Widget getBottomButtonsPanel(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: LightButton(
                  style: LightButtonStyle.SECONDARY,
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                      children: [
                        Icon(CupertinoIcons.back),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text('generate_seed_buttons_prev_page'.tr)
                        )
                      ]
                  )
              )
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              child: LightButton(
                  style: LightButtonStyle.PRIMARY,
                  onTap: () {
                    controller.doneAction(context);
                  },
                  child: Row(
                      children: [
                        Icon(CupertinoIcons.check_mark, color: Theme.of(context).accentColor),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                                'generate_seed_buttons_next_page'.tr,
                                style: TextStyle(color: Theme.of(context).accentColor)
                            )
                        )
                      ]
                  )
              )
          )
        ]
    );
  }
}
