import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import './bindings.dart';

const DYNAMIC_LIBRARY_FILE_NAME = "libspecter_rust.so";

class SpecterRustException implements Exception {
  String _message = "Rust bindings error";
  SpecterRustException([String message = "Rust bindings error"]){
    this._message = message;
  }
  @override
  String toString(){
    return _message;
  }
}

class SpecterRust {
  static final SpecterRustBindings _bindings =
      SpecterRustBindings(SpecterRust._loadLibrary());

  static DynamicLibrary _loadLibrary() {
    if(Platform.isLinux){ // FIXME: dirty patch for development
      return DynamicLibrary.open("../libspecter_rust.so");
    }
    return Platform.isAndroid
        ? DynamicLibrary.open(DYNAMIC_LIBRARY_FILE_NAME)
        : DynamicLibrary.process();
  }

  // decodes json from rust side and returns a dict {"data": <data>}
  // if error occured - throws SpecterRustException
  static Map<String, dynamic> _decode_result(String result){
    var data = jsonDecode(result);
    if(data["status"] == "error"){
      throw SpecterRustException(data["message"]);
    }
    return data;
  }

  static String mnemonic_from_entropy(String hex_entropy){
    final ptrEntropy = hex_entropy.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.mnemonic_from_entropy(ptrEntropy.cast<Int8>());

    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);
    malloc.free(ptrEntropy);
    return _decode_result(result)["data"];
  }

  static dynamic mnemonic_to_root_key(String mnemonic, String password, String network){
    final ptrMnemonic = mnemonic.toNativeUtf8(allocator: malloc);
    final ptrPassword = password.toNativeUtf8(allocator: malloc);
    final ptrNetwork = network.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.mnemonic_to_root_key(ptrMnemonic.cast<Int8>(), ptrPassword.cast<Int8>(), ptrNetwork.cast<Int8>());
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrMnemonic);
    malloc.free(ptrPassword);
    malloc.free(ptrNetwork);
    return _decode_result(result)["data"];
  }
  static String derive_xpub(String root, String path){
    final ptrRoot = root.toNativeUtf8(allocator: malloc);
    final ptrPath = path.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.derive_xpub(ptrRoot.cast<Int8>(), ptrPath.cast<Int8>());
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrRoot);
    malloc.free(ptrPath);
    return _decode_result(result)["data"];
  }
  static Map<String, dynamic> default_descriptors(String root, String network){
    final ptrRoot = root.toNativeUtf8(allocator: malloc);
    final ptrNetwork = network.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.default_descriptors(ptrRoot.cast<Int8>(), ptrNetwork.cast<Int8>());
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrRoot);
    malloc.free(ptrNetwork);
    return _decode_result(result)["data"];
  }
  static List<dynamic> derive_addresses(String descriptor, String network, int start, int end){
    final ptrDescriptor = descriptor.toNativeUtf8(allocator: malloc);
    final ptrNetwork = network.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.derive_addresses(ptrDescriptor.cast<Int8>(), ptrNetwork.cast<Int8>(), start, end);
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrDescriptor);
    malloc.free(ptrNetwork);
    return _decode_result(result)["data"];
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

  /// Computes a greeting for the given name using the native function
  static String runBitcoinDemo() {
    // Native call
    final ptrResult = _bindings.run_bitcoin_demo();

    // Cast the result pointer to a Dart string
    final result = ptrResult.cast<Utf8>().toDartString();

    // Free returned string
    _bindings.rust_cstr_free(ptrResult);

    return result;
  }

  static void sayHi() {
    print("Hello from specter_rust (Dart side)");
  }
}
