import 'package:get/get.dart';

import '../controllers/pincode_input_controller.dart';
import '../controllers/verification_pincode_controller.dart';

class VerificationPinCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationPinCodeController>(() => VerificationPinCodeController());
    Get.lazyPut<PinCodeInputController>(() => PinCodeInputController());
  }
}
