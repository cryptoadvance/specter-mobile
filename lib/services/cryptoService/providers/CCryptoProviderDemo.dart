import 'dart:async';

import 'CCryptoProvider.dart';

class CCryptoProviderDemo extends CCryptoProvider {
  Timer? timerGenerateSeed;

  @override
  void startGenerateSeed() {
    if (timerGenerateSeed != null) {
      throw 'generate seed already started';
    }

    timerGenerateSeed = Timer.periodic(Duration(milliseconds: 300), (_) async {
      addEvent(CryptoProviderEventType.GENERATE_SEED_EVENT, SGenerateSeedEvent());
    });
  }

  @override
  void stopGenerateSeed() {
    timerGenerateSeed!.cancel();
    timerGenerateSeed = null;
  }
}