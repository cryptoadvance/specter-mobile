import 'package:get/get.dart';

enum WALLET_INFO_TRANSACTIONS_TAB {
  INFO,
  INPUTS,
  OUTPUTS
}

class WalletInfoTransactionController extends GetxController {
  var currentTab = WALLET_INFO_TRANSACTIONS_TAB.INFO.obs;

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

  WALLET_INFO_TRANSACTIONS_TAB? getTabKey(String key) {
    switch(key) {
      case 'WALLET_INFO_TRANSACTIONS_TAB.INFO': return WALLET_INFO_TRANSACTIONS_TAB.INFO;
      case 'WALLET_INFO_TRANSACTIONS_TAB.INPUTS': return WALLET_INFO_TRANSACTIONS_TAB.INPUTS;
      case 'WALLET_INFO_TRANSACTIONS_TAB.OUTPUTS': return WALLET_INFO_TRANSACTIONS_TAB.OUTPUTS;
    }
  }
}
