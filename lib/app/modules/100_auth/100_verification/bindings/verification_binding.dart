import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/100_verification/controllers/pincode_input_controller.dart';

import '../controllers/verification_controller.dart';

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationController>(() => VerificationController());
    Get.lazyPut<PinCodeInputController>(() => PinCodeInputController());
  }
}
