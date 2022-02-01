import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/keyboard/KeyboardController.dart';

import '../controllers/enter_recovery_phrase_screen_controller.dart';
import '../controllers/enter_recovery_phrase_list_controller.dart';

class EnterRecoveryPhraseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnterRecoveryPhraseController>(() => EnterRecoveryPhraseController(),);
    Get.lazyPut<EnterRecoveryPhraseListController>(() => EnterRecoveryPhraseListController());
    Get.create<KeyboardController>(() => KeyboardController());
  }
}
