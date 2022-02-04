import 'package:flutter/material.dart';

import 'AccountItem.dart';

class AccountsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.only(top: (index == 0)?15:0, left: 15, right: 15, bottom: 15),
              child: AccountItem()
          );
        },
        childCount: 2
      )
    );
  }
}