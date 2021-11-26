import 'package:get/get.dart';

import '../controllers/verification_biometric_controller.dart';

class VerificationBiometricBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationBiometricController>(
      () => VerificationBiometricController(),
    );
  }
}
