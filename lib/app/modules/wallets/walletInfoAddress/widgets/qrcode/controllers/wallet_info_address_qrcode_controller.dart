import 'package:get/get.dart';

class WalletInfoAddressQRCodeController extends GetxController {
  Rx<bool> _useForVerification = false.obs;

  bool get useForVerification => _useForVerification.value;

  set useForVerification(bool useForVerification) {
    _useForVerification.value = useForVerification;
  }

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
}
