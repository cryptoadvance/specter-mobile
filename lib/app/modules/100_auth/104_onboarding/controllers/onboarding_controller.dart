import 'package:get/get.dart';

class OnboardingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void openNextPage() {
    Get.offAllNamed('/keys');
  }
}
