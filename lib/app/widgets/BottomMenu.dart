import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        color: Colors.white
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
              child: SvgPicture.asset('assets/icons/account_balance_wallet.svg', color: Colors.blue[600]),
            ),
          ),
          Container(
            width: 110,
            height: 70,
            margin: EdgeInsets.only(left: 10),
            child: BottomMenuItem(
              label: 'QR Scan',
              isActive: (item == BOTTOM_MENU_ITEM.QR_SCAN),
              child: SvgPicture.asset('assets/icons/qr_code_scanner.svg', color: Colors.blue[600]),
            ),
          ),
          Container(
            width: 110,
            height: 70,
            margin: EdgeInsets.only(left: 10),
            child: BottomMenuItem(
              label: 'More',
              isActive: (item == BOTTOM_MENU_ITEM.MORE),
              child: SvgPicture.asset('assets/icons/coolicon.svg', color: Colors.blue[600]),
            ),
          )
        ]
      )
    );
  }
}

class BottomMenuItem extends StatelessWidget {
  final Widget child;
  final String label;
  final bool isActive;

  BottomMenuItem({required this.child, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: (isActive)?(Colors.blue[50]!.withOpacity(0.2)):Colors.transparent
        ),
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
                  Container(child: child)
                ]
              )
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.blue[600])),
            )
          ]
        )
      )
    );
  }
}