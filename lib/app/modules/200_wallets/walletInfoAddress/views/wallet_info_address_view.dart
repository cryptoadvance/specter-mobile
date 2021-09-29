import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:specter_mobile/app/widgets/LightTab.dart';

import '../widgets/descriptor/views/wallet_info_address_descriptor_view.dart';
import '../widgets/details/views/wallet_info_address_details_view.dart';
import '../widgets/qrcode/views/wallet_info_address_qrcode_view.dart';

import '../controllers/wallet_info_address_controller.dart';

class WalletInfoAddressView extends GetView<WalletInfoAddressController> {
  final WalletInfoAddressController controller = Get.put(WalletInfoAddressController());

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
                    child: Text('My address #1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                  )
                ]
              ),
            )
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
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
                LightTabNode('Info', key: WALLET_INFO_ADDRESS_TAB.DETAILS.toString()),
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
