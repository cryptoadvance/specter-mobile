import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeScanner.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeView.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelController.dart';
import 'package:specter_mobile/app/widgets/slidingUpPanel/SlidingUpPanelView.dart';
import 'package:specter_mobile/services/CServices.dart';

import '../../../../../utils.dart';
import '../controllers/scan_qr_code_controller.dart';

class ScanQRCodeView extends GetView<ScanQRCodeController> {
  final SlidingUpPanelController _slidingUpPanelController = Get.find<SlidingUpPanelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanelView(
          controller: _slidingUpPanelController,
          body: getBody(context)
      )
    );
  }

  Widget getBody(BuildContext context) {
    return Stack(
        children: [
          QRCodeScanner(
            onChange: controller.qrCodeScannerChanged
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                        )
                    ),
                  )
                ),
                SafeArea(
                    top: false,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Obx(() => getStatusBar())
                    )
                )
              ]
            )
          )
        ]
    );
  }

  Widget getStatusBar() {
    int updateCount = controller.updateCount.value;
    String state = 'Scanning...';
    QRCodeScannerStatus qrCodeScannerStatus = controller.qrCodeScannerStatus;
    if (qrCodeScannerStatus.isFind) {
      if (qrCodeScannerStatus.result == null) {
        state = 'Unknown QR Code';
      } else {
        state = 'QR Code found';
      }
    }
    return Text(state, style: TextStyle(color: Colors.white.withOpacity(0.85)));
  }
}
