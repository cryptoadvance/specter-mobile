import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import 'package:specter_mobile/services/CServices.dart';

import '../widgets/WalletInfoAddressDetailsList.dart';
import '../controllers/wallet_info_address_details_controller.dart';

class WalletInfoAddressDetailsView extends GetView<WalletInfoAddressDetailsController> {
  final WalletInfoAddressDetailsController controller = Get.put(WalletInfoAddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5),
            child: Text('wallet_info_address_labels_details_title'.tr, textAlign: TextAlign.center)
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(controller.transactionAddress)
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: getCopyAddress(context)
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: getDetailsPanel()
          )
        ]
      )
    );
  }

  Widget getCopyAddress(BuildContext context) {
    return LightButton(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: SvgPicture.asset('assets/icons/content_copy.svg', color: Colors.white),
        ),
        Text('wallet_info_address_buttons_details_copy'.tr, style: TextStyle(color: Colors.white))
      ],
    ), onTap: () {
      copyAddress(context);
    });
  }

  Widget getDetailsPanel() {
    return WalletInfoAddressDetailsList(
      list: controller.list
    );
  }

  void copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: controller.transactionAddress));
    CServices.notify.addNotify(context, 'Address copied');
  }
}