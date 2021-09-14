import 'package:get/get.dart';

enum WALLET_INFO_TRANSACTIONS_TAB {
  HISTORY,
  UTXO
}

class WalletInfoTransactionsController extends GetxController {
  var currentTab = WALLET_INFO_TRANSACTIONS_TAB.HISTORY.obs;

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
      case 'WALLET_INFO_TRANSACTIONS_TAB.HISTORY': return WALLET_INFO_TRANSACTIONS_TAB.HISTORY;
      case 'WALLET_INFO_TRANSACTIONS_TAB.UTXO': return WALLET_INFO_TRANSACTIONS_TAB.UTXO;
    }
  }
}