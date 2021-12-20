import 'cryptoService/CCryptoService.dart';
import 'cryptoContainer/CCryptoContainer.dart';
import 'CNotificationService.dart';

class CServices {
  static final CNotificationService gNotificationService = CNotificationService();
  static final CCryptoContainer gCryptoContainer = CCryptoContainer();
  static final CCryptoService gCryptoService = CCryptoService();

  static Future<void> init() async {
    await Future.wait([
      gCryptoContainer.init()
    ]);
  }
}