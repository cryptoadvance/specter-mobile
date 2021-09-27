import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/100_auth/100_verification/views/verification_view.dart';

class HelloController extends GetxController {
  var labelOpacity = 0.1.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 10), () {
      labelOpacity.value = 1.0;
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      Get.offAllNamed('/verification');
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
