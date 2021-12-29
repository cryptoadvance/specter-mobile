import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum WALLET_INFO_TAB {
  DETAILS,
  ADDRESSES,
  TRANSACTIONS
}

class WalletInfoController extends GetxController {
  var currentTab = WALLET_INFO_TAB.DETAILS.obs;

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

  void setCurrentTab(String key) {
    var val = getTabKey(key);
    currentTab.value = val!;
  }

  WALLET_INFO_TAB? getTabKey(String key) {
    switch(key) {
      case 'WALLET_INFO_TAB.DETAILS': return WALLET_INFO_TAB.DETAILS;
      case 'WALLET_INFO_TAB.ADDRESSES': return WALLET_INFO_TAB.ADDRESSES;
      case 'WALLET_INFO_TAB.TRANSACTIONS': return WALLET_INFO_TAB.TRANSACTIONS;
    }
  }
}
