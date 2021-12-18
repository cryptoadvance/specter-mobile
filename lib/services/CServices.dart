import 'cryptoContainer/CCryptoContainer.dart';
import 'CNotificationService.dart';

class CServices {
  static final CNotificationService gNotificationService = CNotificationService ();
  static final CCryptoContainer gCryptoContainer = CCryptoContainer();

  static Future<void> init() async {
    await Future.wait([
      gCryptoContainer.init()
    ]);
  }
}