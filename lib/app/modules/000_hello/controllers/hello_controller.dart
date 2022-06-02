import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CServices.dart';

class HelloController extends GetxController {
  var labelOpacity = 0.1.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 10), () {
      labelOpacity.value = 1.0;
    });

    Future.delayed(Duration(milliseconds: 1000), () async {
      await CServices.init();
      bool isNeedInitAuth = !CServices.crypto.sharedCryptoContainer.isAuthInit();
      bool isAddedBiometricAuth = CServices.crypto.sharedCryptoContainer.isAddedBiometricAuth();

      print('isNeedInitAuth: ' + isNeedInitAuth.toString());
      print('isAddedBiometricAuth: ' + isAddedBiometricAuth.toString());

      String openPage = (isAddedBiometricAuth || isNeedInitAuth)?Routes.VERIFICATION_BIOMETRIC:Routes.VERIFICATION_PINCODE;

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
