import 'cryptoService/CCryptoService.dart';
import 'CNotificationService.dart';

class CServices {
  static final CNotificationService notify = CNotificationService();
  static final CCryptoService crypto = CCryptoService();

  static Future<void> init() async {
    await crypto.init();
  }
}