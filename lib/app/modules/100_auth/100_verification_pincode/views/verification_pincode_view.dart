import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../views/pincode_input_view.dart';
import '../widgets/PinCodeKeyboard.dart';

import '../../../../../utils.dart';
import '../controllers/verification_pincode_controller.dart';

class VerificationPinCodeView extends GetView<VerificationPinCodeController> {
  @override
  final VerificationPinCodeController controller = Get.find<VerificationPinCodeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: getTopPanel(context)
          ),
          Container(
            child: getBottomPanel(context)
          )
        ]
      )
    );
  }

  Widget getTopPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(controller.isNeedInitAuth?'verification_labels_top_title'.tr:'verification_labels_top_title_ready'.tr, style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor
              ))
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: PinCodeInputView(),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
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
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.topRight,
              child: getNextButton(context)
            )
          ]
        )
      ),
    );
  }

  Widget getBackButton(BuildContext context) {
    return LightButton(
        style: LightButtonStyle.WHITE_OUTLINE,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Use Biometric', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700]))
            ]
        ),
        onTap: () {
          controller.openPrevPage();
        });
  }

  Widget getNextButton(BuildContext context) {
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
      controller.verifyAction(context);
    });
  }

  Widget getBottomPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Utils.hexToColor('#202B40'),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: SafeArea(
        top: false,
        child: PinCodeKeyboard(
          viewBiometricAuthButton: controller.viewBiometricAuthButton,
          onComplete: () {
            if (controller.isNeedInitAuth) {
              return;
            }
            controller.verifyAction(context);
          },
          openBiometricAuth: () {
            controller.openPrevPage();
          }
        )
      )
    );
  }
}
