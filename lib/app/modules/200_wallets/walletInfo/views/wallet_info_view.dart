import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/controllers/wallet_info_controller.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/addresses/contollers/wallet_info_addresses_controller.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/details/controllers/wallet_info_details_controller.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/widgets/transactions/controllers/wallet_info_transactions_controller.dart';
import 'package:specter_mobile/app/widgets/BottomSlideMenu.dart';
import 'package:specter_mobile/app/widgets/TopSide.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelView.dart';
import '../widgets/addresses/views/wallet_info_addresses_view.dart';
import '../widgets/details/views/wallet_info_details_view.dart';
import '../widgets/transactions/views/wallet_info_transactions_view.dart';
import 'package:specter_mobile/app/widgets/LightTab.dart';

class WalletInfoView extends GetView<WalletInfoController> {
  final SlidingUpPanelController _slidingUpPanelController = Get.find<SlidingUpPanelController>();

  final WalletInfoDetailsController _walletInfoDetailsController = Get.find<WalletInfoDetailsController>();
  final WalletInfoAddressesController _walletInfoAddressesController = Get.find<WalletInfoAddressesController>();
  final WalletInfoTransactionsController _walletInfoTransactionsController = Get.find<WalletInfoTransactionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanelView(
            controller: _slidingUpPanelController,
            body: getBody()
        )
    );
  }

  Widget getSlideMenu() {
    return BottomSlideMenu(
        menuItems: [
          BottomSlideMenuItem(
              icon: './assets/icons/menu_pencil.svg',
              title: 'Rename'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_qr_code.svg',
              title: 'Show QR code'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_public_key.svg',
              title: 'Public key'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_json.svg',
              title: 'Export to JSON'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_pdf.svg',
              title: 'Export to PDF'
          ),
          BottomSlideMenuItem(
              icon: './assets/icons/menu_delete.svg',
              title: 'Delete wallet'
          )
        ]
    );
  }

  Widget getBody() {
    return SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSide(
                  title: 'Account #' + controller.keyIndex.toString(),
                  titleType: TOP_SIDE_TITLE_TYPE.WALLET,
                  menuType: TOP_SIDE_MENU_TYPE.OPTIONS,
                  openMenu: () {
                    _slidingUpPanelController.open(getSlideMenu());
                  }
              ),
              Expanded(
                  child: getContent()
              )
            ]
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
        return WalletInfoDetailsView(
          controller: _walletInfoDetailsController
        );
      }
      case WALLET_INFO_TAB.ADDRESSES: {
        return WalletInfoAddressesView(
          controller: _walletInfoAddressesController
        );
      }
      case WALLET_INFO_TAB.TRANSACTIONS: {
        return WalletInfoTransactionsView(
          controller: _walletInfoTransactionsController
        );
      }
    }
  }
}
