import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
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
            getTopTitle(),
            Expanded(
              child: getContent()
            )
          ]
        )
      )
    );
  }

  Widget getTopTitle() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white.withOpacity(0.5))
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: getBackButton()
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset('assets/icons/bitcoin.svg', color: Colors.white),
                  ),
                  Container(
                    child: Text('My wallet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                  )
                ]
              ),
            )
          ),
          Container(
            padding: EdgeInsets.only(right: 5),
            child: getMenuButton()
          )
        ]
      )
    );
  }

  Widget getBackButton() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        //color: Colors.grey,
        width: 50,
        height: 45,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 5),
        child: Icon(CupertinoIcons.left_chevron, size: 26)
      )
    );
  }

  Widget getMenuButton() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        //color: Colors.grey,
        width: 50,
        height: 45,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 5),
        child: SvgPicture.asset('assets/icons/top_right_icon.svg', color: Colors.white, height: 35)
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
                LightTabNode('Info', key: WALLET_INFO_TAB.DETAILS.toString()),
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
