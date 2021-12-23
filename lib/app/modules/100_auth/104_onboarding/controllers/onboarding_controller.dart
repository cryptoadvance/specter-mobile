import 'package:get/get.dart';
import 'package:specter_mobile/services/CServices.dart';

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
    CServices.gCryptoContainer.openAfterAuthPage();
  }
}
