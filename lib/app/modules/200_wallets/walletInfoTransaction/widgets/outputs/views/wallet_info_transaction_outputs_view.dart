import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_info_transaction_outputs_controller.dart';

import '../../inputs/widgets/wallet_info_transaction_item.dart';

class WalletInfoTransactionOutputsView extends GetView<WalletInfoTransactionOutputsController> {
  final WalletInfoTransactionOutputsController controller = Get.put(WalletInfoTransactionOutputsController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.only(top: (index == 0)?10:10, left: 15, right: 15),
              child: WalletInfoTransactionItem()
          );
        }
    );
  }
}