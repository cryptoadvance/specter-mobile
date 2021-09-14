import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/walletInfo/widgets/transactions/controllers/wallet_info_transactions_controller.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

import '../wallet_info_transactions_item.dart';



class WalletInfoTransactionsView extends GetView<WalletInfoTransactionsController> {
  final WalletInfoTransactionsController controller = Get.put(WalletInfoTransactionsController());

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
                LightTabNode('HISTORY', key: WALLET_INFO_TRANSACTIONS_TAB.HISTORY.toString()),
                LightTabNode('UTXO', key: WALLET_INFO_TRANSACTIONS_TAB.UTXO.toString())
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
      case WALLET_INFO_TRANSACTIONS_TAB.HISTORY: {
        return Text('HISTORY');
      }
      case WALLET_INFO_TRANSACTIONS_TAB.UTXO: {
        return Text('UTXO');
      }
    }*/

    return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.only(top: (index == 0)?0:10, left: 15, right: 15),
              child: WalletInfoTransactionsItem()
          );
        }
    );
  }
}