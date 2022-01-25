import 'dart:async';

import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_rust/specter_rust.dart';

import '../cryptoContainer/CCryptoContainer.dart';

import 'CControlWalletsService.dart';
import 'CGenerateSeedService.dart';
import 'CRecoverySeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderDemo.dart';

class CCryptoContainerAuth {
  int _currentSeedIdx = -1;

  void selectCurrentSeedByIdx(int idx) {
    _currentSeedIdx = idx;
  }
}

class CCryptoService {
  late CCryptoContainer cryptoContainer;
  late CGenerateSeedService generateSeedService;
  late CRecoverySeedService recoverySeedService;
  late CControlWalletsService controlWalletsService;

  late CCryptoProvider cryptoProvider;
  late CCryptoContainerAuth cryptoContainerAuth;

  CCryptoService() {
    cryptoProvider = CCryptoProviderDemo();
    cryptoContainer = CCryptoContainer();
    cryptoContainerAuth = CCryptoContainerAuth();
    generateSeedService = CGenerateSeedService(cryptoProvider);
    recoverySeedService = CRecoverySeedService(cryptoProvider);
    controlWalletsService = CControlWalletsService(cryptoProvider);
  }

  Future<void> init() async {
    String result = SpecterRust.greet('test');
    print('test library: ' + result);

    //
    await Future.wait([
      cryptoContainer.init()
    ]);
  }

  void openAfterAuthPage() {
    if (!cryptoContainer!.isSeedsInit()) {
      Get.offAllNamed(Routes.RECOVERY_SELECT);
      return;
    }
    cryptoContainerAuth.selectCurrentSeedByIdx(0);

    //
    if (!cryptoContainer!.isWalletsInit()) {
      Get.offAllNamed(Routes.ADD_WALLET);
      return;
    }

    Get.offAllNamed(Routes.WALLETS);
  }
}