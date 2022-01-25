import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:specter_mobile/services/CServices.dart';

import '../../utils.dart';

import 'QRCodeScanner.dart';

enum BOTTOM_MENU_ITEM {
  WALLETS,
  QR_SCAN,
  MORE
}

class BottomMenu extends StatelessWidget {
  final BOTTOM_MENU_ITEM item;
  BottomMenu({this.item = BOTTOM_MENU_ITEM.WALLETS});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Utils.hexToColor('#233752'),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 70,
            child: BottomMenuItem(
              label: 'Wallets',
              isActive: (item == BOTTOM_MENU_ITEM.WALLETS),
              icon: 'assets/icons/account_balance_wallet.svg',
              onSelect: () {

              }
            )
          ),
          Container(
            width: 110,
            height: 70,
            margin: EdgeInsets.only(left: 10),
            child: BottomMenuItem(
              label: 'QR Scan',
              isActive: (item == BOTTOM_MENU_ITEM.QR_SCAN),
              icon: 'assets/icons/qr_code_scanner.svg',
              onSelect: () {
                CServices.notify.addDialog(context, child: QRCodeScanner());
              }
            )
          ),
          Container(
            width: 110,
            height: 70,
            margin: EdgeInsets.only(left: 10),
            child: BottomMenuItem(
              label: 'More',
              isActive: (item == BOTTOM_MENU_ITEM.MORE),
              icon: 'assets/icons/coolicon.svg',
              onSelect: () {

              }
            )
          )
        ]
      )
    );
  }
}

class BottomMenuItem extends StatelessWidget {
  final Widget? child;
  final String label;
  final String? icon;
  final bool isActive;
  final Function onSelect;

  BottomMenuItem({
    this.child,
    required this.label,
    this.icon,
    required this.isActive,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = (isActive)?Utils.hexToColor('#62AAFF'):Utils.hexToColor('#C0CAD7');

    return InkWell(
      onTap: () {
        onSelect();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(icon!, color: iconColor)
                    )
                  ]
                )
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: iconColor)
                )
              )
            ]
          )
        )
      ),
    );
  }
}