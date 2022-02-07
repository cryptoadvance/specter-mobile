import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';

class ImportExistingWalletController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void viewTap(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void scanQRCodeAction() {
    Get.toNamed(Routes.SCAN_QR_CODE, arguments: {
    });
  }

  void importFilesAction() {

  }
}
