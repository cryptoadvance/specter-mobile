import 'package:get/get.dart';
import 'package:specter_mobile/app/widgets/qrCode/QRCodeScanner.dart';

class ScanQRCodeController extends GetxController {
  final Rx<int> updateCount = 0.obs;
  QRCodeScannerStatus qrCodeScannerStatus = QRCodeScannerStatus();

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

  void qrCodeScannerChanged(QRCodeScannerStatus _qrCodeScannerStatus) {
    qrCodeScannerStatus = _qrCodeScannerStatus;
    updateCount.value++;
  }
}
