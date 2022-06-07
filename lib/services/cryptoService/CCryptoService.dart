import 'dart:async';

import 'package:get/get.dart';
import 'package:specter_mobile/app/routes/app_pages.dart';
import 'package:specter_mobile/services/CServices.dart';
import 'package:specter_mobile/services/cryptoContainer/PrivateCryptoContainer.dart';
import 'package:specter_rust/specter_rust.dart';

import '../cryptoContainer/SharedCryptoContainer.dart';

import 'CControlTransactionsService.dart';
import 'CControlWalletsService.dart';
import 'CGenerateSeedService.dart';
import 'CRecoverySeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderRust.dart';

class CCryptoContainerAuth {
  int _currentMnemonicIdx = -1;
  SMnemonicRootKey? _currentMnemonicRootKey;

  bool selectCurrentMnemonicByIdx(int idx, String pass) {
    String mnemonic = CServices.crypto.privateCryptoContainer.getMnemonicByIdx(idx);
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
  late SharedCryptoContainer sharedCryptoContainer;
  late PrivateCryptoContainer privateCryptoContainer;

  late CGenerateSeedService generateSeedService;
  late CRecoverySeedService recoverySeedService;
  late CControlWalletsService controlWalletsService;
  late CControlTransactionsService controlTransactionsService;

  late CCryptoProvider cryptoProvider;
  late CCryptoContainerAuth cryptoContainerAuth;

  CCryptoService() {
    cryptoProvider = CCryptoProviderRust();
    sharedCryptoContainer = SharedCryptoContainer();
    privateCryptoContainer = PrivateCryptoContainer();
    cryptoContainerAuth = CCryptoContainerAuth();
    generateSeedService = CGenerateSeedService(cryptoProvider);
    recoverySeedService = CRecoverySeedService(cryptoProvider);
    controlWalletsService = CControlWalletsService(cryptoProvider);
    controlTransactionsService = CControlTransactionsService(cryptoProvider);
  }

  Future<void> init() async {
    String result = SpecterRust.greet('test');
    print('test library: ' + result);

    //
    await Future.wait([
      sharedCryptoContainer.init(),
      privateCryptoContainer.init()
    ]);
  }

  bool tryOpenPrivateCryptoContainer(String pass) {
    return privateCryptoContainer.tryOpenPrivateCryptoContainer(pass);
  }

  void openAfterAuthPage() {
    if (!sharedCryptoContainer.isAppInit()) {
      Get.offAllNamed(Routes.RECOVERY_SELECT);
      return;
    }
    if (!privateCryptoContainer.isSeedsInit()) {
      Get.offAllNamed(Routes.RECOVERY_SELECT);
      return;
    }
    if (!cryptoContainerAuth.selectCurrentMnemonicByIdx(0, '')) {
      throw 'can not select mnemonic';
    }

    //
    if (!privateCryptoContainer.isWalletsInit()) {
      Get.offAllNamed(Routes.ADD_WALLET_SELECT, arguments: {
        'displayExternalActions': false
      });
      return;
    }

    Get.offAllNamed(Routes.WALLETS);
  }
}