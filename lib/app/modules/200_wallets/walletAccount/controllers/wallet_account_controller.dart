import 'package:get/get.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/services/CServices.dart';

class WalletAccountController extends GetxController {
  final String walletKey = Get.arguments['walletKey'];
  SWalletModel? walletItem;

  @override
  void onInit() {
    super.onInit();

    walletItem = CServices.crypto.controlWalletsService.getWalletByKey(walletKey);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
