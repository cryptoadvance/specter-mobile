import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/auth/recovery_select/views/recovery_select_view.dart';
import 'package:specter_mobile/app/modules/auth/verification/controllers/pincode_input_controller.dart';
import 'package:specter_mobile/app/modules/auth/verification/views/pincode_input_view.dart';
import 'package:specter_mobile/app/modules/auth/verification/widgets/PinCodeKeyboard.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../../../../../utils.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  final PinCodeInputController pinCodeInputController = Get.put(PinCodeInputController());

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
                fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor
              ))
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: PinCodeInputView(),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                'verification_labels_remember_these_words'.tr,
                style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor)
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 16),
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
        Text('NEXT', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: SvgPicture.asset('assets/icons/chevron_right.svg', color: Colors.white)
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
      decoration: BoxDecoration(
        color: Utils.hexToColor('#202B40'),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: SafeArea(
        top: false,
        child: PinCodeKeyboard()
      )
    );
  }
}
