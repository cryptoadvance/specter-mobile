import 'package:get/get.dart';

enum WALLET_INFO_TAB {
  INFO,
  ADDRESSES,
  TRANSACTIONS
}

class WalletInfoController extends GetxController {
  var currentTab = WALLET_INFO_TAB.INFO.obs;

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
      case 'WALLET_INFO_TAB.INFO': return WALLET_INFO_TAB.INFO;
      case 'WALLET_INFO_TAB.ADDRESSES': return WALLET_INFO_TAB.ADDRESSES;
      case 'WALLET_INFO_TAB.TRANSACTIONS': return WALLET_INFO_TAB.TRANSACTIONS;
    }
  }
}