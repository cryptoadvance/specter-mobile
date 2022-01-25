import 'dart:async';

import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_rust/specter_rust.dart';

import '../cryptoContainer/CCryptoContainer.dart';

import 'CControlWalletsService.dart';
import 'CGenerateSeedService.dart';
import 'CRecoverySeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderRust.dart';

class CCryptoContainerAuth {
  int _currentMnemonicIdx = -1;
  SMnemonicRootKey? _currentMnemonicRootKey;

  bool selectCurrentMnemonicByIdx(int idx, String pass) {
    String mnemonic = CServices.crypto.cryptoContainer.getMnemonicByIdx(idx);
    SMnemonicRootKey mnemonicRootKey = CServices.crypto.cryptoProvider.mnemonicToRootKey(mnemonic, pass);

    _currentMnemonicIdx = idx;
    _currentMnemonicRootKey = mnemonicRootKey;
    return true;
  }

  SMnemonicRootKey getCurrentMnemonicRootKey() {
    return _currentMnemonicRootKey!;
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
    cryptoProvider = CCryptoProviderRust();
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
    if (!cryptoContainer.isSeedsInit()) {
      Get.offAllNamed(Routes.RECOVERY_SELECT);
      return;
    }
    if (!cryptoContainerAuth.selectCurrentMnemonicByIdx(0, '')) {
      throw 'can not select mnemonic';
    }

    //
    if (!cryptoContainer.isWalletsInit()) {
      Get.offAllNamed(Routes.ADD_WALLET);
      return;
    }

    Get.offAllNamed(Routes.WALLETS);
  }
}