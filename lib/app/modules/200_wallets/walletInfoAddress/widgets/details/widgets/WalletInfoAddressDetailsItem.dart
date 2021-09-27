import 'package:flutter/material.dart';

import 'WalletInfoAddressDetailsList.dart';

class WalletInfoAddressDetailsItem extends StatelessWidget {
  final WalletInfoAddressDetailsNode node;
  WalletInfoAddressDetailsItem(this.node);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(node.name),
          ),
          Container(
              child: Text(node.value)
          )
        ]
    );
  }
}