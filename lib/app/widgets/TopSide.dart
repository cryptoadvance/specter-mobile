import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils.dart';

enum TOP_SIDE_TITLE_TYPE {
  WALLET,
  ADDRESS,
  TRANSACTION
}

enum TOP_SIDE_MENU_TYPE {
  NONE,
  OPTIONS,
  EDIT
}

class TopSide extends StatelessWidget {
  final String title;

  final TOP_SIDE_TITLE_TYPE titleType;
  final TOP_SIDE_MENU_TYPE menuType;
  final Function openMenu;

  TopSide({
    required this.title,
    required this.titleType,
    required this.menuType,
    required this.openMenu
  });

  @override
  Widget build(BuildContext context) {
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
                            getShortIcon(),
                            Container(
                                child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                            )
                          ]
                      )
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

  Widget getShortIcon() {
    String icon;

    switch(titleType) {
      case TOP_SIDE_TITLE_TYPE.WALLET:
        icon = 'assets/icons/bitcoin.svg';
        break;
      case TOP_SIDE_TITLE_TYPE.ADDRESS:
        icon = 'assets/icons/account_tree.svg';
        break;
      case TOP_SIDE_TITLE_TYPE.TRANSACTION:
        icon = 'assets/icons/globe_1.svg';
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ClipOval(
          child: Container(
              width: 50,
              height: 50,
              color: Utils.hexToColor('#FF9900').withOpacity(0.2),
              child: Center(
                  child:  SvgPicture.asset(icon, color: Utils.hexToColor('#EEA02B'))
              )
          )
      )
    );
  }

  Widget getBackButton() {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Get.back();
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Utils.hexToColor('#202A40'),
                shape: BoxShape.circle
              ),
              child: Icon(CupertinoIcons.left_chevron, size: 24)
            )
        )
    );
  }

  Widget getMenuButton() {
    String icon;

    switch(menuType) {
      case TOP_SIDE_MENU_TYPE.OPTIONS:
        icon = 'assets/icons/top_right_icon.svg';
        break;
      case TOP_SIDE_MENU_TYPE.EDIT:
        icon = 'assets/icons/edit.svg';
        break;
      case TOP_SIDE_MENU_TYPE.NONE:
        return Container();
    }

    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          openMenu();
        },
        child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 10),
            child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Utils.hexToColor('#202A40'),
                    shape: BoxShape.circle
                ),
                child: SvgPicture.asset(icon, color: Colors.white)
            )
        )
    );
  }
}