import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

import '../contollers/wallet_info_addresses_controller.dart';
import '../wallet_info_addresses_item.dart';

class WalletInfoAddressesView extends GetView<WalletInfoAddressesController> {
  final WalletInfoAddressesController controller = Get.put(WalletInfoAddressesController());

  @override
  Widget build(BuildContext context) {
    return Container(child: getContent());
  }

  Widget getContent() {
    return Obx(() => Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: LightTab(
              view: LightTabView.TOGGLE,
              tabs: [
                LightTabNode('RECEIVE', key: WALLET_INFO_ADDRESSES_TAB.RECEIVE.toString()),
                LightTabNode('CHANGE', key: WALLET_INFO_ADDRESSES_TAB.CHANGE.toString())
              ],
              tabKey: controller.currentTab.toString(),
              onSelect: (String key) {
                controller.setCurrentTab(key);
              }
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0),
              child: getTabContent()
            )
          )
        ]
      )
    ));
  }

  Widget getTabContent() {
    /*switch(controller.currentTab.value) {
      case WALLET_INFO_ADDRESSES_TAB.RECEIVE: {
        return Text('RECEIVE');
      }
      case WALLET_INFO_ADDRESSES_TAB.CHANGE: {
        return Text('CHANGE');
      }
    }*/
    return ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: (index == 0)?0:10, left: 15, right: 15),
          child: WalletInfoAddressesItem()
        );
      }
    );
  }
}