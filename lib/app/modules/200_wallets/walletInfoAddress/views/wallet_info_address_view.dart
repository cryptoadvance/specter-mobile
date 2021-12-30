import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:specter_mobile/app/widgets/BottomSlideMenu.dart';

import 'package:specter_mobile/app/widgets/LightTab.dart';
import 'package:specter_mobile/app/widgets/TopSide.dart';

import '../widgets/descriptor/views/wallet_info_address_descriptor_view.dart';
import '../widgets/details/views/wallet_info_address_details_view.dart';
import '../widgets/qrcode/views/wallet_info_address_qrcode_view.dart';

import '../controllers/wallet_info_address_controller.dart';

class WalletInfoAddressView extends GetView<WalletInfoAddressController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            onPanelSlide: (pos) {
              if (pos > 0) {
                controller.slidingUpPanelIsOpen.value = true;
              }
            },
            onPanelOpened: () {
              controller.slidingUpPanelIsOpen.value = true;
            },
            onPanelClosed: () {
              controller.slidingUpPanelIsOpen.value = false;
            },
            panel: getSlideMenu(),
            minHeight: 0,
            backdropEnabled: true,
            color: Colors.transparent,
            controller: controller.slidingUpPanelController,
            body: Stack(
                children: [
                  getBody(),
                  Obx(() => Container(
                      child: controller.slidingUpPanelIsOpen.value?BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                          )
                      ):null
                  ))
                ]
            )
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
                controller.slidingUpPanelController.open();
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
