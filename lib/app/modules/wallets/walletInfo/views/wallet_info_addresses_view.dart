import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/walletInfo/controllers/wallet_info_addresses_controller.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

class WalletInfoAddressesView extends GetView<WalletInfoAddressesController> {
  final WalletInfoAddressesController controller = Get.put(WalletInfoAddressesController());

  @override
  Widget build(BuildContext context) {
    return getContent();
  }

  Widget getContent() {
    return Obx(() => Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LightTab(
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: getTabContent()
                )
              )
            ]
        )
    ));
  }

  Widget getTabContent() {
    switch(controller.currentTab.value) {
      case WALLET_INFO_ADDRESSES_TAB.RECEIVE: {
        return Text('RECEIVE');
      }
      case WALLET_INFO_ADDRESSES_TAB.CHANGE: {
        return Text('CHANGE');
      }
    }
  }
}