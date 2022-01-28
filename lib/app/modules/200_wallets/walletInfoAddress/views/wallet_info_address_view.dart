import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/BottomSlideMenu.dart';

import 'package:specter_mobile/app/widgets/LightTab.dart';
import 'package:specter_mobile/app/widgets/TopSide.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelView.dart';

import '../widgets/descriptor/views/wallet_info_address_descriptor_view.dart';
import '../widgets/details/views/wallet_info_address_details_view.dart';
import '../widgets/qrcode/views/wallet_info_address_qrcode_view.dart';

import '../controllers/wallet_info_address_controller.dart';

class WalletInfoAddressView extends GetView<WalletInfoAddressController> {
  final SlidingUpPanelController _slidingUpPanelController = Get.find<SlidingUpPanelController>();

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
          )
        ]
    );
  }

  Widget getBody() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopSide(
              title: 'My address #1',
              titleType: TOP_SIDE_TITLE_TYPE.ADDRESS,
              menuType: TOP_SIDE_MENU_TYPE.EDIT,
              openMenu: () {
                _slidingUpPanelController.open(getSlideMenu());
              }
            ),
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
                LightTabNode('Information', key: WALLET_INFO_ADDRESS_TAB.DETAILS.toString()),
                LightTabNode('QR Code', key: WALLET_INFO_ADDRESS_TAB.QR_CODE.toString()),
                LightTabNode('Descriptor', key: WALLET_INFO_ADDRESS_TAB.DESCRIPTOR.toString())
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
      case WALLET_INFO_ADDRESS_TAB.DETAILS:
        return WalletInfoAddressDetailsView();
      case WALLET_INFO_ADDRESS_TAB.QR_CODE:
        return WalletInfoAddressQRCodeView();
      case WALLET_INFO_ADDRESS_TAB.DESCRIPTOR:
        return WalletInfoAddressDescriptorView();
    }
  }
}
