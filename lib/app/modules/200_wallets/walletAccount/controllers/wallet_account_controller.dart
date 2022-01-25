import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WalletAccountController extends GetxController {
  PanelController slidingUpPanelController = PanelController();

  Rx<bool> slidingUpPanelIsOpen = false.obs;

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
}
