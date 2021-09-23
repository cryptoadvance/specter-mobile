import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_info_transaction_inputs_controller.dart';

class WalletInfoTransactionInputsView extends GetView<WalletInfoTransactionInputsController> {
  final WalletInfoTransactionInputsController controller = Get.put(WalletInfoTransactionInputsController());

  @override
  Widget build(BuildContext context) {
    return Text('WalletInfoTransactionInputsView');
  }
}