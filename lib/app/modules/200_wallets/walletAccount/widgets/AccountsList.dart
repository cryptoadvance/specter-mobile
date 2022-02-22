import 'package:flutter/material.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import 'AccountItem.dart';

class AccountsList extends StatelessWidget {
  final SWalletModel walletItem;

  AccountsList({
    required this.walletItem
  });

  @override
  Widget build(BuildContext context) {
    List<SWalletKey> keys = walletItem.descriptor.keys;
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int keyIndex) {
          SWalletKey walletKeyDetails = keys[keyIndex];
          return Container(
              margin: EdgeInsets.only(top: (keyIndex == 0)?15:0, left: 15, right: 15, bottom: 15),
              child: AccountItem(
                walletKey: walletItem.key,
                keyIndex: keyIndex,
                  walletKeyDetails: walletKeyDetails
              )
          );
        },
        childCount: keys.length
      )
    );
  }
}