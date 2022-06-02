import 'package:flutter/material.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/CServices.dart';

import 'WalletItem.dart';

class WalletsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SWalletModel> wallets = CServices.crypto.privateCryptoContainer.getWallets();

    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          SWalletModel walletModel = wallets[index];
          return Container(
              margin: EdgeInsets.only(top: (index == 0)?15:0, left: 15, right: 15, bottom: 15),
              child: WalletItem(
                  walletModel: walletModel
              )
          );
        },
        childCount: wallets.length
      )
    );
  }
}