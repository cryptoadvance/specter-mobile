import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:specter_mobile/app/modules/100_auth/104_onboarding/controllers/onboarding_controller.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CCryptoExceptions.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

import 'QRCodeView.dart';

enum QRCodeScannerTypes {
  UNKNOWN,
  ADD_WALLET_SIMPLE,
  ADD_WALLET_JSON,
  PARSE_TRANSACTION
}

extension ParseToString on QRCodeScannerTypes {
  String toShortString() {
    return toString().split('.').last;
  }
}

class QRCodeScannerResult {
  QRCodeScannerTypes qrCodeType = QRCodeScannerTypes.UNKNOWN;
}

class QRCodeScannerResultAddWalletSimple extends QRCodeScannerResult {
  final String name;
  final String descriptor;

  QRCodeScannerResultAddWalletSimple({
    required this.name,
    required this.descriptor
  }) {
    qrCodeType = QRCodeScannerTypes.ADD_WALLET_SIMPLE;
  }
}

class QRCodeScannerResultAddWalletJSON extends QRCodeScannerResult {
  final String label;
  final int blockheight;
  final String descriptor;

  QRCodeScannerResultAddWalletJSON({
    required this.label,
    required this.blockheight,
    required this.descriptor
  }) {
    qrCodeType = QRCodeScannerTypes.ADD_WALLET_JSON;
  }
}

class QRCodeScannerResultParseTransaction extends QRCodeScannerResult {
  final String raw;

  QRCodeScannerResultParseTransaction({
    required this.raw
  }) {
    qrCodeType = QRCodeScannerTypes.PARSE_TRANSACTION;
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
      onQRViewCreated: (QRViewController controller) {
        _onQRViewCreated(context, controller);
      },
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

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) async {
      if (!mounted) {
        return;
      }
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

      //
      if (_qrCodeScannerStatus.result != null) {
        await controller.pauseCamera();
        await onFound(context);
        if (!mounted) {
          return;
        }
        await controller.resumeCamera();

        //
        cleanStatus();
      }
    });
  }

  void cleanStatus() {
    prevCode = '';
    _qrCodeScannerStatus.isFind = false;
    _qrCodeScannerStatus.result = null;
    wasModified();
  }

  QRCodeScannerResult? determineQRCodeType(String code) {
    if (kDebugMode) {
      print('code: ' + code);
    }

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
        descriptor: desc
      );
    }

    if (code[0] == '{') {
      Map<String, dynamic>? obj;
      try {
        obj = jsonDecode(code);
      } catch(e) {
        print(e);
      }

      if (obj != null) {
        if (obj.containsKey('label') && obj.containsKey('blockheight') && obj.containsKey('descriptor')) {
          String label = obj['label'];
          int blockheight = obj['blockheight'] ?? 0;
          String descriptor = obj['descriptor'];
          if (label.isEmpty || blockheight < 1 || descriptor.isEmpty) {
            return null;
          }

          return QRCodeScannerResultAddWalletJSON(
            label: label,
            blockheight: blockheight,
            descriptor: descriptor
          );
        }
      }
    }

    {
      try {
        final bytes = base64.decode(code);

        String p = String.fromCharCode(bytes[0]);
        String s = String.fromCharCode(bytes[1]);
        String b = String.fromCharCode(bytes[2]);
        String t = String.fromCharCode(bytes[3]);
        if (p == 'p' && s == 's' && b == 'b' && t == 't') {
          return QRCodeScannerResultParseTransaction(
            raw: code
          );
        }
      } catch(_) {}
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

  Future<void> onFound(BuildContext context) async {
    QRCodeScannerResult qrCodeScannerResult = _qrCodeScannerStatus.result!;
    await CServices.notify.addDialog(context, child: QRCodeView(
        qrCodeScannerResult: qrCodeScannerResult,
        onProcess: () {
          switch(qrCodeScannerResult.qrCodeType) {
            case QRCodeScannerTypes.UNKNOWN:
              break;
            case QRCodeScannerTypes.ADD_WALLET_SIMPLE:
              QRCodeScannerResultAddWalletSimple qrCode = qrCodeScannerResult as QRCodeScannerResultAddWalletSimple;
              processAddWalletSimple(context, qrCode);
              break;
            case QRCodeScannerTypes.ADD_WALLET_JSON:
              QRCodeScannerResultAddWalletJSON qrCode = qrCodeScannerResult as QRCodeScannerResultAddWalletJSON;
              processAddWalletJSON(context, qrCode);
              break;
            case QRCodeScannerTypes.PARSE_TRANSACTION:
              QRCodeScannerResultParseTransaction qrCode = qrCodeScannerResult as QRCodeScannerResultParseTransaction;
              processParseTransaction(context, qrCode);
              break;
          }
        }
    ));
  }

  void processAddWalletSimple(BuildContext context, QRCodeScannerResultAddWalletSimple qrCode) async {
    addWallet(walletName: qrCode.name, descriptor: qrCode.descriptor);
  }

  void processAddWalletJSON(BuildContext context, QRCodeScannerResultAddWalletJSON qrCode) async {
    addWallet(walletName: qrCode.label, descriptor: qrCode.descriptor);
  }

  void addWallet({
    required String walletName,
    required String descriptor
  }) async {
    try {
      if (!(await CServices.crypto.controlWalletsService.addExistWallet(
          walletName: walletName,
          descriptor: descriptor
      ))) {
        await CServices.notify.addMessage(
            context, 'Oops!!', 'Please try again.',
            actionTitle: 'Try Again'
        );
        return;
      }
    } on CCryptoExceptionsWalletExists catch (e) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Wallet exists.',
          actionTitle: 'Try Again'
      );
      return;
    }

    CServices.notify.closeDialog();
    await Get.offAllNamed(Routes.ONBOARDING, arguments: {
      'onboardingMessageType': ONBOARDING_MESSAGE_TYPE.WALLET_READY
    });
  }

  void processParseTransaction(BuildContext context, QRCodeScannerResultParseTransaction qrCode) async {
    if (!(CServices.crypto.controlTransactionsService.parseTransaction(qrCode))) {
      await CServices.notify.addMessage(
          context, 'Oops!!', 'Please try again.',
          actionTitle: 'Try Again'
      );
      return;
    }
  }
}