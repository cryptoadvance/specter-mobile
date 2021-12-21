import 'dart:async';

import 'dart:convert';

import '../CGenerateSeedService.dart';

enum CryptoProviderEventType {
  GENERATE_SEED_EVENT
}

class SCryptoProviderEvent {
  final CryptoProviderEventType _eventType;
  final SCryptoProviderSubEvent _subEvent;

  SCryptoProviderEvent(
      CryptoProviderEventType eventType, SCryptoProviderSubEvent subEvent
  ): _eventType = eventType, _subEvent = subEvent;

  @override
  String toString() {
    return jsonEncode({
      'eventType': _eventType.toString()
    });
  }
}

abstract class SCryptoProviderSubEvent {

}

class SGenerateSeedEvent extends SCryptoProviderSubEvent {
  List<String> seedWords;
  double completePercent;

  SGenerateSeedEvent({required this.seedWords, this.completePercent = 0});

  @override
  String toString() {
    return jsonEncode({
      'seedWords': seedWords,
      'completePercent': completePercent.toString()
    });
  }
}

abstract class CCryptoProvider {
  late StreamController<SCryptoProviderEvent> streamController;
  late Stream<SCryptoProviderEvent> stream;

  CCryptoProvider() {
    streamController = StreamController<SCryptoProviderEvent>.broadcast();
    stream = streamController.stream;
  }

  void addEvent(CryptoProviderEventType eventType, SCryptoProviderSubEvent subEvent) {
    streamController.add(SCryptoProviderEvent(eventType, subEvent));
  }

  StreamSubscription<SCryptoProviderEvent> subscribeEvents(CryptoProviderEventType eventType, Function(SCryptoProviderSubEvent) cb) {
    return stream.listen((item) {
      if (item._eventType != eventType) {
        return;
      }
      cb(item._subEvent);
    });
  }

  void startGenerateSeed();
  void stopGenerateSeed();
  void setGenerateSeedOptions(GenerateSeedOptions generateSeedOptions);
}