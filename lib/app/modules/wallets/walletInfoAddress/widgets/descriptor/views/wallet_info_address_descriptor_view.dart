import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/wallet_info_address_descriptor_controller.dart';

class WalletInfoAddressDescriptorView extends GetView<WalletInfoAddressDescriptorController> {
  final WalletInfoAddressDescriptorController controller = Get.put(WalletInfoAddressDescriptorController());

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
                  child: Text('wallet_info_address_labels_descriptor_title'.tr, textAlign: TextAlign.center)
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
            child: QrImage(
                data: "wpkh([f85ab0a4/84'/1'/0']tpubDCbEcqH6AdUMrVANGN2Zh7u81VqfEtY1TG1iskDHcS2JwDaLJ48Kx31nvEdn3VmyAkvqfeEjHEvQH6zxBDRL9QDs8BbgcvB5ukvTKpKa2Fh/0/0)#4lk8av2t",
                foregroundColor: Colors.white,
                version: QrVersions.auto,
                size: 250
            )
        )
    );
  }

  Widget getAddressPanel() {
    return Text("wpkh([f85ab0a4/84'/1'/0']tpubDCbEcqH6AdUMrVANGN2Zh7u81VqfEtY1TG1iskDHcS2JwDaLJ48Kx31nvEdn3VmyAkvqfeEjHEvQH6zxBDRL9QDs8BbgcvB5ukvTKpKa2Fh/0/0)#4lk8av2t");
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
                          Text('Raw public keys', style: TextStyle(fontSize: 16)),
                          Text('Display raw public keys associated with this address.', style: TextStyle(color: Colors.grey[300]))
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