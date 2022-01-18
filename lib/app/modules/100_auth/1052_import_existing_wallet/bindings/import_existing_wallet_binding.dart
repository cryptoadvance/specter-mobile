import 'package:get/get.dart';

import '../controllers/import_existing_wallet_controller.dart';

class ImportExistingWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportExistingWalletController>(
      () => ImportExistingWalletController(),
    );
  }
}
