import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../../../utils.dart';
import '../controllers/import_existing_wallet_controller.dart';

class ImportExistingWalletView extends GetView<ImportExistingWalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
              onTap: () {
                controller.viewTap(context);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: getTopSide()
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            child: getActionsArea()
                          )
                        )
                      ]
                  )
              ),
            )
        )
    );
  }

  Widget getTopSide() {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: getBackButton()
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Text('Import wallet', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                            )
                          ]
                      )
                  )
              )
            ]
        )
    );
  }

  Widget getBackButton() {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Get.back();
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 10),
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Utils.hexToColor('#202A40'),
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.left_chevron, size: 24)
            )
        )
    );
  }

  Widget getActionsArea() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 5),
            width: double.infinity,
            child: getScanQRCodeArea()
          )
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            width: double.infinity,
            child: getImportFilesArea()
          )
        )
      ]
    );
  }

  Widget getScanQRCodeArea() {
    return getActionWell(
      onTap: controller.scanQRCodeAction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: SvgPicture.asset('assets/icons/qr_code_scanner_2.svg', height: 50)
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('Scan a QR code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          )
        ]
      )
    );
  }

  Widget getImportFilesArea() {
    return getActionWell(
      onTap: controller.importFilesAction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              child: SvgPicture.asset('assets/icons/folder_open.svg', height: 50)
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('Import files', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          )
        ]
      )
    );
  }

  Widget getActionWell({required GestureTapCallback onTap, required Widget child}) {
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));

    return Material(
      color: Color(0xff0F1D2D),
      borderRadius: borderRadius,
      child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
              width: double.infinity,
              child: Center(
                  child: child
              )
          )
      ),
    );
  }
}
