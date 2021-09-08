import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../../utils.dart';
import '../controllers/wallet_info_controller.dart';

class WalletInfoView extends GetView<WalletInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getTopTitle()
          ]
        )
      )
    );
  }

  Widget getTopTitle() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white)
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
}
