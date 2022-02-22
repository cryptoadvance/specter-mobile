import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import '../../../../../utils.dart';
import 'AccountItem.dart';

class WalletItem extends StatelessWidget {
  final SWalletModel walletModel;

  WalletItem({
    required this.walletModel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Utils.hexToColor('#202A40'),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: tapItem,
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 10),
                child: getTopPanel(context)
              ),
            ),
            Container(
              width: double.infinity,
              child: getBottomPanel()
            )
          ],
        )
    );
  }

  Widget getTopPanel(BuildContext context) {
    var leftColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(walletModel.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)),
        ),
        Container(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(walletModel.descriptor.policy, style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('80h/1/0 (?)', style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor))
                )
              ]
          )
        )
      ]
    );

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: leftColumn
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Icon(CupertinoIcons.right_chevron, size: 20, color: Theme.of(context).accentColor)
          )
        ]
    );
  }

  Widget getBottomPanel() {
    List<Widget> rows = [];
    int keyIndex = 0;
    walletModel.descriptor.keys.forEach((SWalletKey walletKeyDetails) {
      rows.add(Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey[400]!)
              )
          ),
          margin: EdgeInsets.only(top: 15),
          child: AccountItem(
            walletKey: walletModel.key,
            walletKeyDetails: walletKeyDetails,
            keyIndex: keyIndex
          )
      ));
      keyIndex++;
    });

    return Column(
        children: rows
    );
  }

  void tapItem() {
    Get.toNamed(Routes.WALLET_ACCOUNT, arguments: {
      'walletKey': walletModel.key
    });
  }
}

