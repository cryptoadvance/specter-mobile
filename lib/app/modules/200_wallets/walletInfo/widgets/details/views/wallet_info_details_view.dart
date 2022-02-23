import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_info_details_controller.dart';

class WalletInfoDetailsView extends GetView<WalletInfoDetailsController> {
  final WalletInfoDetailsController _controller;

  WalletInfoDetailsView({required WalletInfoDetailsController controller}): _controller = controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    _controller.list.forEach((node) {
      rows.add(Container(
        margin: EdgeInsets.only(top: rows.isEmpty?0:5),
        child: WalletInfoDetailsItem(node)
      ));
    });

    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        children: rows
      ),
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