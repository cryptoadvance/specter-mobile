import 'dart:async';

import 'CGenerateSeedService.dart';
import 'CRecoverySeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderDemo.dart';

class CCryptoService {
  late CGenerateSeedService generateSeedService;
  late CRecoverySeedService recoverySeedService;

  late CCryptoProvider cryptoProvider;

  CCryptoService() {
    cryptoProvider = CCryptoProviderDemo();
    generateSeedService = CGenerateSeedService(cryptoProvider);
    recoverySeedService = CRecoverySeedService(cryptoProvider);
  }
}