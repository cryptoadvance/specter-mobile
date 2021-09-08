import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/walletInfo/views/wallet_info_view.dart';

import '../../../../../utils.dart';

class AccountWalletItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapItem,
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 5),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: getTopPanel(),
                  ),
                  Container(
                    width: double.infinity,
                    child: getOperationsList(),
                  )
                ]
              ),
            ),
            Positioned(
              top: 3,
              right: 10,
              child: Icon(CupertinoIcons.right_chevron, color: Colors.grey[700], size: 20)
            )
          ]
        ),
      )
    );
  }

  Widget getTopPanel() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: SvgPicture.asset('assets/icons/bitcoin.svg', color: Utils.hexToColor('#F3B352')),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My wallet 1', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Single key', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      Text('80h/1/0', style: TextStyle(fontSize: 14, color: Colors.grey[700]))
                    ]
                  )
                )
              ]
            )
          )
        )
      ]
    );
  }

  Widget getOperationsList() {
    List<Widget> rows = [];
    for (int i = 0; i < 3; i++) {
      rows.add(Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: rows.isEmpty?5:1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dec, 12, 2020', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            Text('send 0.01, change 0.100', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ]
        )
      ));
    }
    return Column(
      children: rows
    );
  }

  void tapItem() {
    Get.to(WalletInfoView(), arguments: {
    });
  }
}