import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../utils.dart';

class WalletInfoTransactionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: openItem,
          splashColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: Utils.hexToColor('#202A40'),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: getContent()
          )
      ),
    );
  }

  Widget getContent() {
    return Row(
        children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: getTopPanel()
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        child: getBottomPanel()
                    )
                  ]
              )
          ),
          Container(
              child: getRightArrow()
          )
        ]
    );
  }

  Widget getTopPanel() {
    TextStyle style = TextStyle(color: Colors.white);
    return Row(
        children: [
          Container(
              child: Text('#0', style: style)
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text('title', style: style)
            ),
          ),
          Container(
              child: Text('0 BTC', style: style)
          )
        ]
    );
  }

  Widget getBottomPanel() {
    TextStyle style = TextStyle(color: Colors.white.withOpacity(0.5));
    return Container(
        child: Text('TXID: ...', style: style)
    );
  }

  Widget getRightArrow() {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: SvgPicture.asset('assets/icons/content_copy.svg', color: Colors.white)
    );
  }

  void openItem() {
  }
}