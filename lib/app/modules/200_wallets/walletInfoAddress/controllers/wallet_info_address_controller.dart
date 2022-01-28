import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum WALLET_INFO_ADDRESS_TAB {
  DETAILS,
  QR_CODE,
  DESCRIPTOR
}

class WalletInfoAddressController extends GetxController {
  var currentTab = WALLET_INFO_ADDRESS_TAB.DETAILS.obs;

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

  WALLET_INFO_ADDRESS_TAB? getTabKey(String key) {
    switch(key) {
      case 'WALLET_INFO_ADDRESS_TAB.DETAILS': return WALLET_INFO_ADDRESS_TAB.DETAILS;
      case 'WALLET_INFO_ADDRESS_TAB.QR_CODE': return WALLET_INFO_ADDRESS_TAB.QR_CODE;
      case 'WALLET_INFO_ADDRESS_TAB.DESCRIPTOR': return WALLET_INFO_ADDRESS_TAB.DESCRIPTOR;
    }
  }
}
