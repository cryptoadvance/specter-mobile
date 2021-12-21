import 'dart:async';

import 'CCryptoProvider.dart';

class CCryptoProviderDemo extends CCryptoProvider {
  Timer? timerGenerateSeed;
  int generateDemoIdx = 0;

  @override
  void startGenerateSeed() {
    if (timerGenerateSeed != null) {
      throw 'generate seed already started';
    }

    generateDemoIdx = 0;

    timerGenerateSeed = Timer.periodic(Duration(milliseconds: 300), (_) async {
      var seedWords = [
        'A' + generateDemoIdx.toString(), 'B', 'C', 'D',  'A', 'B', 'C', 'D'
      ];
      addEvent(CryptoProviderEventType.GENERATE_SEED_EVENT, SGenerateSeedEvent(seedWords: seedWords));
      generateDemoIdx++;
    });
  }

  @override
  void stopGenerateSeed() {
    timerGenerateSeed!.cancel();
    timerGenerateSeed = null;
  }
}