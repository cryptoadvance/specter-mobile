import 'dart:async';

import 'CGenerateSeedService.dart';
import 'providers/CCryptoProvider.dart';
import 'providers/CCryptoProviderDemo.dart';

class CCryptoService {
  late CGenerateSeedService generateSeedService;
  late CCryptoProvider cryptoProvider;

  CCryptoService() {
    cryptoProvider = CCryptoProviderDemo();
    generateSeedService = CGenerateSeedService(cryptoProvider);
  }

  StreamSubscription<SGenerateSeedEvent> startGenerateSeed(Function(SGenerateSeedEvent) cb) {
    return generateSeedService.startGenerateSeed(cb);
  }

  void stopGenerateSeed() {
    return generateSeedService.stopGenerateSeed();
  }
}