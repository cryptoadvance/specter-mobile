import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import '../../../../../utils.dart';

class AccountItem extends StatelessWidget {
  final String walletKey;
  final int keyIndex;
  final SWalletKey walletKeyDetails;

  AccountItem({
    required this.walletKey,
    required this.keyIndex,
    required this.walletKeyDetails
  });

  @override
  Widget build(BuildContext context) {
    var leftColumn = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text('Account #' + keyIndex.toString(), style: TextStyle(fontSize: 15, color: Theme.of(context).accentColor)),
          ),
          Container(
            child: Text('Exchange', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: getLeftIcon()
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: getRightDetails(context)
                  )
                ]
            )
          )
        ]
    );

    return InkWell(
      onTap: tapItem,
      child: Container(
          decoration: BoxDecoration(
              color: Utils.hexToColor('#202A40'),
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: leftColumn
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Icon(CupertinoIcons.right_chevron, size: 20, color: Theme.of(context).accentColor)
              )
            ]
          )
      )
    );
  }

  Widget getRightDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            child: Text('0.135 BTC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor))
        ),
        Container(
            child: Text('\$1000', style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor))
        )
      ]
    );
  }

  Widget getLeftIcon() {
    String icon = 'assets/icons/bitcoin.svg';
    return Container(
        child: ClipOval(
            child: Container(
                width: 40,
                height: 40,
                color: Utils.hexToColor('#FF9900').withOpacity(0.2),
                child: Center(
                    child:  SvgPicture.asset(icon, color: Utils.hexToColor('#EEA02B'))
                )
            )
        )
    );
  }

  void tapItem() {
    Get.toNamed(Routes.WALLET_INFO, arguments: {
      'walletKey': walletKey,
      'keyIndex': keyIndex
    });
  }
}