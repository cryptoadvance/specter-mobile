import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

enum QRCodeScannerTypes {
  UNKNOWN,
  ADD_WALLET_SIMPLE,
  ADD_WALLET_JSON
}

class QRCodeScannerResult {
  QRCodeScannerTypes qrCodeType = QRCodeScannerTypes.UNKNOWN;
}

class QRCodeScannerResultAddWalletSimple extends QRCodeScannerResult {
  final String name;
  final String desc;

  QRCodeScannerResultAddWalletSimple({
    required this.name,
    required this.desc
  }) {
    qrCodeType = QRCodeScannerTypes.ADD_WALLET_SIMPLE;
  }
}

class QRCodeScannerStatus {
  bool isFind = false;

  QRCodeScannerResult? result;
}

class QRCodeScanner extends StatefulWidget {
  final Function(QRCodeScannerStatus) onChange;

  QRCodeScanner({required this.onChange});

  @override
  State<StatefulWidget> createState() {
    return QRCodeScannerState();
  }

}

class QRCodeScannerState extends State<QRCodeScanner> {
  String prevCode = '';

  final QRCodeScannerStatus _qrCodeScannerStatus = QRCodeScannerStatus();

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return getContent(context);
  }

  Widget getContent(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) {
      if (scanData.code == null || scanData.code == prevCode) {
        return;
      }

      try {
        _qrCodeScannerStatus.result = determineQRCodeType(scanData.code!);
      } catch(e) {
        _qrCodeScannerStatus.result = null;
      }

      prevCode = scanData.code!;
      _qrCodeScannerStatus.isFind = true;
      wasModified();
    });
  }

  QRCodeScannerResultAddWalletSimple? determineQRCodeType(String code) {
    if (code.indexOf('addwallet ') == 0) {
      code = code.substring(10);
      int x = code.indexOf('&');
      if (x == -1) {
        return null;
      }

      String name = code.substring(0, x);
      String desc = code.substring(x + 1);
      if (name.isEmpty || desc.isEmpty) {
        return null;
      }

      return QRCodeScannerResultAddWalletSimple(
        name: name,
        desc: desc
      );
    }

    return null;
  }

  void wasModified() {
    widget.onChange(_qrCodeScannerStatus);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}