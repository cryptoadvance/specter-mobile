import 'dart:async';

import 'dart:convert';

import '../../CEntropyExternalGenerationService.dart';
import '../CGenerateSeedService.dart';
import '../CRecoverySeedService.dart';

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
  String mnemonicKey;
  double completePercent;

  SGenerateSeedEvent({this.completePercent = 0, required this.mnemonicKey});

  @override
  String toString() {
    return jsonEncode({
      'seedKey': mnemonicKey,
      'completePercent': completePercent.toString()
    });
  }
}

class SMnemonicRootKey {
  String rootPrivateKey;
  String sign;

  SMnemonicRootKey({required this.rootPrivateKey, required this.sign});

  @override
  String toString() {
    return jsonEncode({
      'rootPrivateKey': rootPrivateKey,
      'sign': sign
    });
  }
}

class SWalletDescriptor {
  String recv;
  String change;

  SWalletDescriptor({required this.recv, required this.change});

  static SWalletDescriptor fromJSON(obj) {
    return SWalletDescriptor(
      recv: obj['recv'],
      change: obj['change']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'recv': recv,
      'change': change
    };
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
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

  //Generate seed API
  void startGenerateSeed();
  void stopGenerateSeed();
  void setGenerateSeedOptions(GenerateSeedOptions generateSeedOptions);
  void cleanGeneratedSeed();
  void addExternalEntropy(SGenerateEntropyExternalEvent entropyExternalEvent);

  //Recovery seed API
  Future<RecoverySeedResult?> verifyRecoveryPhrase(List<String> recoveryPhrases);

  //Wallets API
  SMnemonicRootKey mnemonicToRootKey(String mnemonic, String pass);
  SWalletDescriptor getDefaultDescriptor(SMnemonicRootKey mnemonicRootKey);
  SWalletDescriptor getParsedDescriptor(SMnemonicRootKey mnemonicRootKey, String descriptor);
}