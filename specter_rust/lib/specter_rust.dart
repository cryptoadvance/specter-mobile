import 'dart:async';

import 'package:flutter/services.dart';

class SpecterRust {
  static const MethodChannel _channel = const MethodChannel('specter_rust');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void sayHi() {
    print("Hello from specter_rust (Dart side)");
  }
}
