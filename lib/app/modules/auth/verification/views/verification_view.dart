import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/recovery_select/views/recovery_select_view.dart';
import 'package:specter_mobile/app/modules/auth/verification/widgets/PinCodeInput.dart';
import 'package:specter_mobile/app/modules/auth/verification/widgets/PinCodeKeyboard.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../../../../../utils.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: getTopPanel(context)
          ),
          Container(
            child: getBottomPanel()
          )
        ],
      )
    );
  }

  Widget getTopPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Text('verification_labels_top_title'.tr, style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor
              ))
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text('verification_labels_chose_your_pin_code'.tr, style: TextStyle(
                fontSize: 16, color: Theme.of(context).accentColor
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: PinCodeInput(),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                'verification_labels_remember_these_words'.tr,
                style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 4),
              child: Text(
                'common black orchard kick raw',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.topRight,
              child: getNextButton()
            )
          ],
        )
      ),
    );
  }

  Widget getNextButton() {
    return LightButton(child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('NEXT', style: TextStyle(fontSize: 15, color: Utils.hexToColor('#1264D1'))),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Icon(CupertinoIcons.chevron_forward, size: 20, color: Utils.hexToColor('#1264D1'))
        )
      ],
    ),
    onTap: () {
      Get.to(RecoverySelectView(), arguments: {
      });
    });
  }

  Widget getBottomPanel() {
    return Container(
      width: double.infinity,
      color: Utils.hexToColor('#D1D5DB').withOpacity(0.9),
      child: SafeArea(
        top: false,
        child: PinCodeKeyboard()
      )
    );
  }
}
