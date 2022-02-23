import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/CServices.dart';

enum WALLET_INFO_TAB {
  DETAILS,
  ADDRESSES,
  TRANSACTIONS
}

class WalletInfoController extends GetxController {
  final String walletKey = Get.arguments['walletKey'];
  final int keyIndex = Get.arguments['keyIndex'];
  SWalletModel? walletItem;

  var currentTab = WALLET_INFO_TAB.DETAILS.obs;

  @override
  void onInit() {
    super.onInit();

    walletItem = CServices.crypto.controlWalletsService.getWalletByKey(walletKey);
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
