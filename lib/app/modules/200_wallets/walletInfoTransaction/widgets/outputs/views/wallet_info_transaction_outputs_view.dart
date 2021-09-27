import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_info_transaction_outputs_controller.dart';

class WalletInfoTransactionOutputsView extends GetView<WalletInfoTransactionOutputsController> {
  final WalletInfoTransactionOutputsController controller = Get.put(WalletInfoTransactionOutputsController());

  @override
  Widget build(BuildContext context) {
    return Text('WalletInfoTransactionOutputsView');
  }
}