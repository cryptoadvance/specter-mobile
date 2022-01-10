import 'package:specter_rust/specter_rust.dart';

import 'cryptoService/CCryptoService.dart';
import 'cryptoContainer/CCryptoContainer.dart';
import 'CNotificationService.dart';

class CServices {
  static final CNotificationService gNotificationService = CNotificationService();
  static final CCryptoContainer gCryptoContainer = CCryptoContainer();
  static final CCryptoService gCryptoService = CCryptoService();

  static Future<void> init() async {
    String result = SpecterRust.greet('test');
    print('test library: ' + result);

    //
    await Future.wait([
      gCryptoContainer.init()
    ]);
  }
}