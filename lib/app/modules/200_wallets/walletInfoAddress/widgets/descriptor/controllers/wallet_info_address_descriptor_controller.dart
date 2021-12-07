import 'package:get/get.dart';

class WalletInfoAddressDescriptorController extends GetxController {
  final Rx<bool> _useForVerification = false.obs;

  bool get useForVerification => _useForVerification.value;

  set useForVerification(bool useForVerification) {
    _useForVerification.value = useForVerification;
  }

  String descriptor = "wpkh([f85ab0a4/84'/1'/0']tpubDCbEcqH6AdUMrVANGN2Zh7u81VqfEtY1TG1iskDHcS2JwDaLJ48Kx31nvEdn3VmyAkvqfeEjHEvQH6zxBDRL9QDs8BbgcvB5ukvTKpKa2Fh/0/0)#4lk8av20";

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
