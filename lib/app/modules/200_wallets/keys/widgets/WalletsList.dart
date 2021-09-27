import 'package:flutter/material.dart';

import 'AccountItem.dart';

class WalletsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return ListTile(
          title: AccountItem()
        );
      }
    );
  }
}