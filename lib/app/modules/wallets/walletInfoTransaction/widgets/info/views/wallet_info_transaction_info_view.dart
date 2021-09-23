import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/modules/wallets/walletInfoAddress/widgets/details/widgets/WalletInfoAddressDetailsList.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import '../controllers/wallet_info_transaction_info_controller.dart';

class WalletInfoTransactionInfoView extends GetView<WalletInfoTransactionInfoController> {
  final WalletInfoTransactionInfoController controller = Get.put(WalletInfoTransactionInfoController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: getTopTitle()
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: getAddressPanel()
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: getDetailsPanel()
        )
      ]
    );
  }

  Widget getTopTitle() {
    return Row(
      children: [
        Expanded(
          child: Text('Unnamed transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ),
        getEditButton()
      ]
    );
  }

  Widget getEditButton() {
    return InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
            width: 50,
            height: 45,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 5),
            child: SvgPicture.asset('assets/icons/edit.svg', color: Colors.white, height: 30)
        )
    );
  }

  Widget getAddressPanel() {
    return Column(
      children: [
        Text('4eacb1d3380c97a2f69c1204a9df86633b1d78adb180b258a84fff4b0df65bfb'),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: getCopyAddress()
        )
      ]
    );
  }

  Widget getCopyAddress() {
    return LightButton(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: SvgPicture.asset('assets/icons/content_copy.svg', color: Colors.blue),
        ),
        Text('COPY')
      ],
    ), onTap: copyAddress);
  }

  Widget getDetailsPanel() {
    return WalletInfoAddressDetailsList(
        list: controller.list
    );
  }

  void copyAddress() {
  }
}