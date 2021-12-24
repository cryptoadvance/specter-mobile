import 'dart:convert';

import 'providers/CCryptoProvider.dart';

class RecoverySeedResult {
  final String seedKey;

  RecoverySeedResult({required this.seedKey});

  @override
  String toString() {
    return jsonEncode({
      'seedKey': seedKey
    });
  }
}

class CRecoverySeedService {
  late final CCryptoProvider _cryptoProvider;

  CRecoverySeedService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider;

  Future<RecoverySeedResult?> verifyRecoveryPhrase(List<String> recoveryPhrases) async {
    return _cryptoProvider.verifyRecoveryPhrase(recoveryPhrases);
  }
}