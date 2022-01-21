import 'dart:async';

import '../CEntropyExternalGenerationService.dart';
import 'providers/CCryptoProvider.dart';

enum SEED_COMPLEXITY {
  SIMPLE,
  WORDS_24
}

enum ENTROPY_SOURCE {
  NONE,
  CAMERA
}

class GenerateSeedOptions {
  SEED_COMPLEXITY seedComplexity = SEED_COMPLEXITY.SIMPLE;
  ENTROPY_SOURCE entropySource = ENTROPY_SOURCE.NONE;
}

class CGenerateSeedService {
  late final CCryptoProvider _cryptoProvider;

  late StreamController<SGenerateSeedEvent> streamController;
  late Stream<SGenerateSeedEvent> stream;
  GenerateSeedOptions currentGenerateSeedOptions = GenerateSeedOptions();

  CGenerateSeedService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider {
    streamController = StreamController<SGenerateSeedEvent>.broadcast();
    stream = streamController.stream;
  }

  StreamSubscription<SGenerateSeedEvent> startGenerateSeed(Function(SGenerateSeedEvent) cb) {
    currentGenerateSeedOptions = GenerateSeedOptions();
    updateGenerateSeedOptions();

    //
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

  void setGenerateSeedComplexity(SEED_COMPLEXITY seedComplexity) {
    currentGenerateSeedOptions.seedComplexity = seedComplexity;
    updateGenerateSeedOptions();
  }

  void setEntropySource(ENTROPY_SOURCE entropySource) {
    currentGenerateSeedOptions.entropySource = entropySource;
    updateGenerateSeedOptions();
  }

  void cleanGeneratedSeed() {
    _cryptoProvider.cleanGeneratedSeed();
  }

  void updateGenerateSeedOptions() {
    _cryptoProvider.setGenerateSeedOptions(currentGenerateSeedOptions);
  }

  void addExternalEntropy(SGenerateEntropyExternalEvent entropyExternalEvent) {
    _cryptoProvider.addExternalEntropy(entropyExternalEvent);
  }
}