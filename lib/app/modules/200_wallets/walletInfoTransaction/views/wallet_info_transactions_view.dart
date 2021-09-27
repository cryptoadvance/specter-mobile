import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';
import '../controllers/wallet_info_transactions_controller.dart';

import '../widgets/info/views/wallet_info_transaction_info_view.dart';
import '../widgets/inputs/views/wallet_info_transaction_inputs_view.dart';
import '../widgets/outputs/views/wallet_info_transaction_outputs_view.dart';

class WalletInfoTransactionView extends GetView<WalletInfoTransactionController> {
  final WalletInfoTransactionController controller = Get.put(WalletInfoTransactionController());

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
                            child: SvgPicture.asset('assets/icons/globe-1.svg', color: Colors.white),
                          ),
                          Container(
                              child: Text('Transaction details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
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
            child: SvgPicture.asset('assets/icons/edit.svg', color: Colors.white, height: 30)
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
                      LightTabNode('Info', key: WALLET_INFO_TRANSACTIONS_TAB.INFO.toString()),
                      LightTabNode('Inputs', key: WALLET_INFO_TRANSACTIONS_TAB.INPUTS.toString()),
                      LightTabNode('Outputs', key: WALLET_INFO_TRANSACTIONS_TAB.OUTPUTS.toString())
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
      case WALLET_INFO_TRANSACTIONS_TAB.INFO:
        return WalletInfoTransactionInfoView();
      case WALLET_INFO_TRANSACTIONS_TAB.INPUTS:
        return WalletInfoTransactionInputsView();
      case WALLET_INFO_TRANSACTIONS_TAB.OUTPUTS:
        return WalletInfoTransactionOutputsView();
    }
  }
}
