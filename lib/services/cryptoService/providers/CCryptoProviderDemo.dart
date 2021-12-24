import 'dart:async';
import 'dart:math';

import '../CGenerateSeedService.dart';
import '../CRecoverySeedService.dart';
import 'CCryptoProvider.dart';

class CCryptoProviderDemo extends CCryptoProvider {
  Timer? timerGenerateSeed;
  int generateDemoIdx = 0;
  int maxGenerateIterations = 50;
  double completePercent = 0;
  GenerateSeedOptions? currentGenerateSeedOptions;

  @override
  void startGenerateSeed() {
    if (timerGenerateSeed != null) {
      throw 'generate seed already started';
    }
    if (currentGenerateSeedOptions == null) {
      throw 'generateSeedOptions is not set';
    }

    generateDemoIdx = 0;

    List<String> demoWords = ['A', 'B', 'C', 'D',  'A', 'B', 'C', 'D'];

    timerGenerateSeed = Timer.periodic(Duration(milliseconds: 200), (_) async {
      if (completePercent == 100) {
        return;
      }

      //
      List<String> seedWords = [];
      String seedKey = '';
      int wordsCount = (currentGenerateSeedOptions!.seedComplexity == SEED_COMPLEXITY.SIMPLE)?8:24;
      for (int i = 0; i < wordsCount; i++) {
        String word = demoWords[Random().nextInt(demoWords.length - 1)];
        seedKey += word;
        seedWords.add(word);
      }

      //
      completePercent = (generateDemoIdx / maxGenerateIterations.toDouble()) * 100;
      if (completePercent > 100) {
        completePercent = 100;
      }

      //
      addEvent(CryptoProviderEventType.GENERATE_SEED_EVENT, SGenerateSeedEvent(
          seedWords: seedWords,
          seedKey: seedKey,
          completePercent: completePercent
      ));
      generateDemoIdx++;
    });
  }

  @override
  void stopGenerateSeed() {
    timerGenerateSeed!.cancel();
    timerGenerateSeed = null;
  }

  @override
  void setGenerateSeedOptions(GenerateSeedOptions generateSeedOptions) {
    currentGenerateSeedOptions = generateSeedOptions;
    _cleanDemoCounter();
  }

  void _cleanDemoCounter() {
    generateDemoIdx = 0;
    completePercent = 0;
  }

  @override
  Future<RecoverySeedResult?> verifyRecoveryPhrase(List<String> recoveryPhrases) async {
    String seedKey = '';
    int phrasesCount = 0;
    recoveryPhrases.forEach((recoveryPhrase) {
      if (recoveryPhrase.isNotEmpty) {
        phrasesCount++;
      }
      seedKey += recoveryPhrase;
    });

    if (phrasesCount < 3) {
      return null;
    }

    return RecoverySeedResult(
      seedKey: seedKey
    );
  }
}