import 'package:flutter/material.dart';

import 'AccountWalletItem.dart';

class AccountItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: getTopPanel(),
            ),
            Container(
              width: double.infinity,
              child: getBottomPanel()
            )
          ],
        )
    );
  }

  Widget getTopPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('ACCOUNT #1', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700])),
        ),
        Container(
          child: Text('Primary', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700])),
        )
      ]
    );
  }

  Widget getBottomPanel() {
    List<Widget> rows = [];
    for (int i = 0; i < 2; i++) {
      rows.add(Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey[400]!)
              )
          ),
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
          child: AccountWalletItem()
      ));
    }
    return Column(
        children: rows
    );
  }
}

