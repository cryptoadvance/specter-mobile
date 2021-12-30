import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hex/hex.dart';

import '../../../utils/bip39/bip39.dart' as bip39;

import '../CGenerateSeedService.dart';
import '../CRecoverySeedService.dart';
import 'CCryptoProvider.dart';

class CCryptoProviderDemo extends CCryptoProvider {
  Timer? timerGenerateSeed;
  int generateDemoIdx = 0;
  int maxGenerateIterations = 10;
  double completePercent = 0;
  GenerateSeedOptions? currentGenerateSeedOptions;

  var rnd = Random.secure();

  @override
  void startGenerateSeed() {
    if (timerGenerateSeed != null) {
      throw 'generate seed already started';
    }
    if (currentGenerateSeedOptions == null) {
      throw 'generateSeedOptions is not set';
    }

    generateDemoIdx = 0;
    timerGenerateSeed = Timer.periodic(Duration(milliseconds: 200), demoTick);
  }

  void demoTick(_) async {
    if (completePercent == 100) {
      return;
    }

    //
    int seedBitSize = (currentGenerateSeedOptions!.seedComplexity == SEED_COMPLEXITY.SIMPLE)?128:256;

    //
    int bytes = (seedBitSize / 8).round();
    Uint8List seedList = getRandomSeed(bytes);

    //
    List<String> seedWords = bip39.entropyHexToMnemonic(seedList);
    String seedKey = seedWords.join(' ');

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
  }

  Uint8List getRandomSeed(int bytes) {
    Uint8List seedList = Uint8List(bytes);

    //
    for (int i = 0; i < bytes; i++) {
      seedList[i] = rnd.nextInt(256) ^ rnd.nextInt(256) ^ rnd.nextInt(256);
    }
    return seedList;
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