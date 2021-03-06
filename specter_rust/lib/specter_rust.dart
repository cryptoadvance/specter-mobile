import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import './bindings.dart';

const DYNAMIC_LIBRARY_FILE_NAME = "libspecter_rust.so";

class SpecterRust {
  static final SpecterRustBindings _bindings =
      SpecterRustBindings(SpecterRust._loadLibrary());

  static DynamicLibrary _loadLibrary() {
    return Platform.isAndroid
        ? DynamicLibrary.open(DYNAMIC_LIBRARY_FILE_NAME)
        : DynamicLibrary.process();
  }

  /// Computes a greeting for the given name using the native function
  static String greet(String name) {
    // Allocate a native string holding argument in UTF-8
    final ptrName = name.toNativeUtf8(allocator: malloc);

    // Native call
    final ptrResult = _bindings.rust_greeting(ptrName.cast<Int8>());

    // Cast the result pointer to a Dart string
    final result = ptrResult.cast<Utf8>().toDartString();

    // Free returned string
    _bindings.rust_cstr_free(ptrResult);

    // Free argument string
    malloc.free(ptrName);

    return result;
  }

  static void sayHi() {
    print("Hello from specter_rust (Dart side)");
  }
}
