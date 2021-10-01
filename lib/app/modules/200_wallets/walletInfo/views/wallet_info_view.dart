import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/TopSide.dart';
import '../widgets/addresses/views/wallet_info_addresses_view.dart';
import '../widgets/details/views/wallet_info_details_view.dart';
import '../widgets/transactions/views/wallet_info_transactions_view.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

import '../../../../../utils.dart';
import '../controllers/wallet_info_controller.dart';

class WalletInfoView extends GetView<WalletInfoController> {
  final WalletInfoController controller = Get.find<WalletInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopSide(title: 'My wallet', titleType: TOP_SIDE_TITLE_TYPE.WALLET, menuType: TOP_SIDE_MENU_TYPE.EDIT),
            Expanded(
              child: getContent()
            )
          ]
        )
      )
    );
  }

  Widget getContent() {
    return Obx(() => Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: LightTab(
              tabs: [
                LightTabNode('Information', key: WALLET_INFO_TAB.DETAILS.toString()),
                LightTabNode('Addresses', key: WALLET_INFO_TAB.ADDRESSES.toString()),
                LightTabNode('Transactions', key: WALLET_INFO_TAB.TRANSACTIONS.toString())
              ],
              tabKey: controller.currentTab.toString(),
              onSelect: (String key) {
                controller.setCurrentTab(key);
              }
            ),
          ),
          Expanded(
            child: getTabContent()
          )
        ]
      )
    ));
  }

  Widget getTabContent() {
    switch(controller.currentTab.value) {
      case WALLET_INFO_TAB.DETAILS: {
        return WalletInfoDetailsView();
      }
      case WALLET_INFO_TAB.ADDRESSES: {
        return WalletInfoAddressesView();
      }
      case WALLET_INFO_TAB.TRANSACTIONS: {
        return WalletInfoTransactionsView();
      }
    }
  }
}
