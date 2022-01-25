import 'dart:async';

import 'package:specter_rust/specter_rust.dart';

import '../cryptoContainer/CCryptoContainer.dart';

import 'CControlWalletsService.dart';
import 'CGenerateSeedService.dart';
import 'CRecoverySeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderDemo.dart';

class CCryptoService {
  late CCryptoContainer cryptoContainer;
  late CGenerateSeedService generateSeedService;
  late CRecoverySeedService recoverySeedService;
  late CControlWalletsService controlWalletsService;

  late CCryptoProvider cryptoProvider;

  CCryptoService() {
    cryptoProvider = CCryptoProviderDemo();
    cryptoContainer = CCryptoContainer();
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
}