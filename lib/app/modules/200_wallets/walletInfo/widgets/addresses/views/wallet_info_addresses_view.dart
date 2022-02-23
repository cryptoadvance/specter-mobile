import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

import '../contollers/wallet_info_addresses_controller.dart';
import '../widgets/wallet_info_addresses_item.dart';

class WalletInfoAddressesView extends GetView<WalletInfoAddressesController> {
  final WalletInfoAddressesController _controller;

  WalletInfoAddressesView({required WalletInfoAddressesController controller}): _controller = controller;

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
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: LightTab(
              view: LightTabView.TOGGLE,
              tabs: [
                LightTabNode('RECEIVE', key: WALLET_INFO_ADDRESSES_TAB.RECEIVE.toString()),
                LightTabNode('CHANGE', key: WALLET_INFO_ADDRESSES_TAB.CHANGE.toString())
              ],
              tabKey: _controller.currentTab.toString(),
              onSelect: (String key) {
                _controller.setCurrentTab(key);
              }
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: getTabContent()
            )
          )
        ]
      )
    ));
  }

  Widget getTabContent() {
    return ListView.builder(
      itemCount: _controller.items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: (index == 0)?10:10, left: 15, right: 15),
          child: WalletInfoAddressesItem()
        );
      }
    );
  }
}