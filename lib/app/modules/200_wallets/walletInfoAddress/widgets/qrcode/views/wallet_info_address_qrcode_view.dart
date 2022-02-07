import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeGenerator.dart';
import '../controllers/wallet_info_address_qrcode_controller.dart';

class WalletInfoAddressQRCodeView extends GetView<WalletInfoAddressQRCodeController> {
  final WalletInfoAddressQRCodeController controller = Get.put(WalletInfoAddressQRCodeController());

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
                  child: Text('wallet_info_address_labels_qrcode_title'.tr, textAlign: TextAlign.center)
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: getQRCodePanel()
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: getAddressPanel()
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: getControlPanel()
              )
            ]
        )
    );
  }

  Widget getQRCodePanel() {
    return Container(
        width: double.infinity,
        child: Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: 200
              ),
              child: QRCodeGenerator(
                  data: '1234567890'
              )
            )
        )
    );
  }

  Widget getAddressPanel() {
    return Text('bitcoin:1234abcd');
  }

  Widget getControlPanel() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('For verification', style: TextStyle(fontSize: 16)),
                          Text('Use to verify the address on an external device.', style: TextStyle(color: Colors.grey[300]))
                      ]
                  )
              )
          ),
          Expanded(
              flex: 0,
              child: Container(
                  child: Obx(() => Switch(
                      value: controller.useForVerification,
                      onChanged: (bool val) {
                        controller.useForVerification = val;
                      },
                      activeTrackColor: Colors.blueGrey,
                      activeColor: Colors.white
                  ))
              )
          )
        ]
    );
  }
}