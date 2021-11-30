import 'package:get/get.dart';

import 'package:specter_mobile/globals.dart' as g;

class HelloController extends GetxController {
  var labelOpacity = 0.1.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 10), () {
      labelOpacity.value = 1.0;
    });

    Future.delayed(Duration(milliseconds: 1000), () async {
      await g.gCryptoService.init();
      bool isNeedInitAuth = !g.gCryptoService.isAuthInit();
      bool isAddedBiometricAuth = g.gCryptoService.isAddedBiometricAuth();

      print('isNeedInitAuth: ' + isNeedInitAuth.toString());
      print('isAddedBiometricAuth: ' + isAddedBiometricAuth.toString());

      String openPage = (isAddedBiometricAuth || isNeedInitAuth)?'/verification-biometric':'/verification-pincode';

      //
      await Get.offAllNamed(openPage,
        arguments: {
          'isNeedInitAuth': isNeedInitAuth
        }
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
