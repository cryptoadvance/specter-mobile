import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/walletInfo/controllers/wallet_info_details_controller.dart';

class WalletInfoDetailsView extends GetView<WalletInfoDetailsController> {
  final WalletInfoDetailsController controller = Get.put(WalletInfoDetailsController());

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    controller.list.forEach((node) {
      rows.add(Container(
        margin: EdgeInsets.only(top: rows.isEmpty?0:5),
        child: WalletInfoDetailsItem(node)
      ));
    });

    return Column(
      children: rows
    );
  }
}

class WalletInfoDetailsItem extends StatelessWidget {
  final WalletInfoDetailsNode node;
  WalletInfoDetailsItem(this.node);

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