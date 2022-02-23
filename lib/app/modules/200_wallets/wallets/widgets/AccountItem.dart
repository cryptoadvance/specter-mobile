import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/views/wallet_info_view.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import '../../../../../utils.dart';

class AccountItem extends StatelessWidget {
  final String walletKey;
  final SWalletKey walletKeyDetails;
  final int keyIndex;

  AccountItem({
    required this.walletKey,
    required this.walletKeyDetails,
    required this.keyIndex
  });

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
                    child: getTopPanel(context),
                  ),
                  Container(
                    width: double.infinity,
                    child: getOperationsList(context),
                  )
                ]
              ),
            ),
            Positioned(
              top: 3,
              right: 10,
              child: Icon(CupertinoIcons.right_chevron, size: 20, color: Theme.of(context).accentColor)
            )
          ]
        ),
      )
    );
  }

  Widget getTopPanel(BuildContext context) {
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
                Text('Account #' + keyIndex.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exchange', style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor))
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

  Widget getOperationsList(BuildContext context) {
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
            Text('Dec, 12, 2020', style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)),
            Text('send 0.01, change 0.100', style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)),
          ]
        )
      ));
    }
    return Column(
      children: rows
    );
  }

  void tapItem() {
    Get.toNamed(Routes.WALLET_INFO, arguments: {
      'walletKey': walletKey,
      'keyIndex': keyIndex
    });
  }
}