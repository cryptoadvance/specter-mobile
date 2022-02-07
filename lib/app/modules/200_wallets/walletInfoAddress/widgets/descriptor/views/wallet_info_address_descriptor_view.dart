import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:specter_mobile/app/widgets/LightButton.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeGenerator.dart';
import 'package:specter_mobile/services/CServices.dart';
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
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: getCopyAddress(context)
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
                    data: controller.descriptor
                )
            )
        )
    );
  }

  Widget getAddressPanel() {
    return Text(controller.descriptor);
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

  Widget getCopyAddress(BuildContext context) {
    return LightButton(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: SvgPicture.asset('assets/icons/content_copy.svg', color: Colors.white),
        ),
        Text('COPY', style: TextStyle(color: Colors.white))
      ],
    ), onTap: () {
      copyAddress(context);
    });
  }

  void copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: controller.descriptor));
    CServices.notify.addNotify(context, 'Descriptor copied');
  }
}