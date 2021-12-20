import 'dart:async';

import 'providers/CCryptoProvider.dart';

class CGenerateSeedService {
  late final CCryptoProvider _cryptoProvider;

  late StreamController<SGenerateSeedEvent> streamController;
  late Stream<SGenerateSeedEvent> stream;

  CGenerateSeedService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider {
    streamController = StreamController<SGenerateSeedEvent>.broadcast();
    stream = streamController.stream;
  }

  StreamSubscription<SGenerateSeedEvent> startGenerateSeed(Function(SGenerateSeedEvent) cb) {
    _cryptoProvider.startGenerateSeed();
    _cryptoProvider.subscribeEvents(CryptoProviderEventType.GENERATE_SEED_EVENT, (SCryptoProviderSubEvent subEvent) {
      SGenerateSeedEvent generateSeedEvent = subEvent as SGenerateSeedEvent;
      streamController.add(generateSeedEvent);
    });

    return stream.listen((item) {
      cb(item);
    });
  }

  void stopGenerateSeed() {
    _cryptoProvider.stopGenerateSeed();
  }
}