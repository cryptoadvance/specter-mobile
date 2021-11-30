import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';

import '../controllers/verification_biometric_controller.dart';

class VerificationBiometricView extends GetView<VerificationBiometricController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.isNeedInitAuth?'Enable Biometric to log in':'Use Biometric auth', style: TextStyle(fontSize: 24)),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: SvgPicture.asset('assets/icons/face_id.svg', height: 100, color: Colors.white)
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 250
                ),
                margin: EdgeInsets.only(top: 20),
                child: Text(controller.isNeedInitAuth?'Allow login to the application using biometric':'Use biometric to log in', style: TextStyle(color: Theme.of(context).hintColor))
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                alignment: Alignment.center,
                child: getNextButton(context)
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: getPinCodeButton(context)
              )
            ]
          ),
        )
      )
    );
  }

  Widget getNextButton(BuildContext context) {
    return LightButton(child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('CONTINUE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))
      ]
    ),
    onTap: () {
      controller.verifyAction(context);
    });
  }

  Widget getPinCodeButton(BuildContext context) {
    if (!controller.viewPinCodeButton) {
      return Container();
    }

    return LightButton(
    style: LightButtonStyle.WHITE_OUTLINE,
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Use PIN code', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700]))
        ]
    ),
    onTap: () {
      controller.openPinCodePage();
    });
  }
}
