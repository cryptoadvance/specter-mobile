import 'package:flutter/material.dart';

import 'WalletInfoAddressDetailsItem.dart';

class WalletInfoAddressDetailsNode {
  String name;
  String value;
  WalletInfoAddressDetailsNode(this.name, this.value);
}

class WalletInfoAddressDetailsList extends StatelessWidget {
  final List<WalletInfoAddressDetailsNode> list;
  WalletInfoAddressDetailsList({required this.list});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    list.forEach((node) {
      rows.add(Container(
          margin: EdgeInsets.only(top: rows.isEmpty?0:5),
          child: WalletInfoAddressDetailsItem(node)
      ));
    });

    return Column(
        children: rows
    );
  }
}