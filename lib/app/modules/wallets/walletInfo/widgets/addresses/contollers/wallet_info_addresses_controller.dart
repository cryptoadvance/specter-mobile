import 'package:get/get.dart';

enum WALLET_INFO_ADDRESSES_TAB {
  RECEIVE,
  CHANGE
}

class WalletInfoAddressesController extends GetxController {
  var currentTab = WALLET_INFO_ADDRESSES_TAB.RECEIVE.obs;

  var items = [1, 2, 3, 4];

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

  WALLET_INFO_ADDRESSES_TAB? getTabKey(String key) {
    switch(key) {
      case 'WALLET_INFO_ADDRESSES_TAB.RECEIVE': return WALLET_INFO_ADDRESSES_TAB.RECEIVE;
      case 'WALLET_INFO_ADDRESSES_TAB.CHANGE': return WALLET_INFO_ADDRESSES_TAB.CHANGE;
    }
  }
}