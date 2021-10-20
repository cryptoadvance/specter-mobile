import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_info_transaction_inputs_controller.dart';

import '../widgets/wallet_info_transaction_item.dart';

class WalletInfoTransactionInputsView extends GetView<WalletInfoTransactionInputsController> {
  final WalletInfoTransactionInputsController controller = Get.put(WalletInfoTransactionInputsController());

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