import 'package:get/get.dart';
import 'package:specter_mobile/services/CServices.dart';

enum ONBOARDING_MESSAGE_TYPE {
  RECOVERY_SET_UP_SUCCESS,
  WALLET_READY
}

class OnboardingController extends GetxController {
  ONBOARDING_MESSAGE_TYPE onboardingMessageType = Get.arguments['onboardingMessageType'] ?? ONBOARDING_MESSAGE_TYPE.RECOVERY_SET_UP_SUCCESS;

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
    CServices.crypto.openAfterAuthPage();
  }
}
