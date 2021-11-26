import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/verification_biometric_controller.dart';

class VerificationBiometricView extends GetView<VerificationBiometricController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'VerificationBiometricView is working',
          style: TextStyle(fontSize: 20),
        )
      )
    );
  }
}
