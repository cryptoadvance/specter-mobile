import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import './bindings.dart';

const DYNAMIC_LIBRARY_FILE_NAME = "libspecter_rust.so";

class SpecterRustException implements Exception {
  String _message = 'Rust bindings error';
  SpecterRustException([String message = 'Rust bindings error']){
    _message = message;
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
    return Platform.isIOS
        ? DynamicLibrary.process()
        : DynamicLibrary.open(DYNAMIC_LIBRARY_FILE_NAME);
  }

  // decodes json from rust side and returns a dict {"data": <data>}
  // if error occured - throws SpecterRustException
  static Map<String, dynamic> _decode_result(String result){
    var data = jsonDecode(result);
    if(data['status'] == 'error'){
      throw SpecterRustException(data['message']);
    }
    return data;
  }

  /// Converts hex-encoded entropy to mnemonic.
  /// Entropy length must be 16 or 32 bytes, so [hex_entropy] should be 32 or 64 chars long.
  /// 
  /// ```dart
  /// String mn = SpecterRust.mnemonic_from_entropy('31313131313131313131313131313131');
  /// mn == 'couple maze era give basic obtain shadow change couple maze era glide';
  /// ```
  static String mnemonic_from_entropy(String hex_entropy){
    final ptrEntropy = hex_entropy.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.mnemonic_from_entropy(ptrEntropy.cast<Int8>());

    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);
    malloc.free(ptrEntropy);
    return _decode_result(result)['data'];
  }

  /// Converts 12 or 24-word [mnemonic] and [password] to Bitcoin root key.
  /// 
  /// [password] can be an arbitrary string, empty string should be used by default.
  /// [network] can be 'bitcoin', 'testnet', 'signet' or 'regtest'.
  /// Throws a [SpecterRustException] if [mnemonic] is invalid or network is unknown.
  /// 
  /// Returns an object {'fingerprint': '4-bytes-in-hex', 'xprv': 'root private key'}
  /// 
  /// ```dart
  /// var root = SpecterRust.mnemonic_to_root_key('couple maze era give basic obtain shadow change couple maze era glide', '', 'bitcoin');
  /// root['xprv'] == 'xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm'
  /// root['fingerprint'] == '312e05df'
  /// ```
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
    return _decode_result(result)['data'];
  }

  /// Derives an extended public key from the [xprv] key using [path].
  /// Returns an extended public key in Bitcoin Core descriptor format: `[fingerprint/derivation]xpub`.
  /// 
  /// Throws a [SpecterRustException] if [xprv] key is invalid or [path] is formatted incorrectly.
  /// 
  /// Examples for [path] argument: `'m/49h/1h/0h/2h'`, `"m/84'/0'/2'"`, `'m/123/456/45h'` etc.
  /// Avoid mixing `h` and `'` in a derivation path.
  /// 
  /// 
  /// ```dart
  /// String xpub = SpecterRust.derive_xpub('xprv9s21ZrQH143K48dWHMyaUE3yzA6KV4MkKytF2unviMieqjN8MtfXSu6WbM29w8UngGtaAWEe65u1SVcPBxoMZLasQXw6MMuZSYWb1QDAbZm', 'm/84h/0h/0h');
  /// xpub == '[312e05df/84h/0h/0h]xpub6CXXH6KkmqEavpf5svtvJe1aXWHeBCRVgnQ1qf4ZekwjYGmXAAsxhmJ3rYnq8qfqnWFVcti42yqi6SqNahsTmpizzvxefP7N5GXyhwPZc3H'
  /// ```
  static String derive_xpub(String xprv, String path){
    final ptrRoot = xprv.toNativeUtf8(allocator: malloc);
    final ptrPath = path.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.derive_xpub(ptrRoot.cast<Int8>(), ptrPath.cast<Int8>());
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrRoot);
    malloc.free(ptrPath);
    return _decode_result(result)['data'];
  }

  /// Gets default segwit single-key descriptors from [xprv] for a given [network]
  /// [network] can be 'bitcoin', 'testnet', 'signet' or 'regtest'.
  /// 
  /// Throws a [SpecterRustException] if [xprv] is invalid or network is unknown.
  /// 
  /// Returns an object with wallet descriptors:
  /// ```
  /// {
  ///   'recv_descriptor': 'wpkh([fgp/der]xpub/0/*)#checksum',
  ///   'change_descriptor': 'wpkh([fgp/der]xpub/1/*)#checksum'
  /// }
  /// ```
  static Map<String, dynamic> get_default_descriptors(String xprv, String network){
    final ptrXprv = xprv.toNativeUtf8(allocator: malloc);
    final ptrNetwork = network.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.default_descriptors(ptrXprv.cast<Int8>(), ptrNetwork.cast<Int8>());
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrXprv);
    malloc.free(ptrNetwork);
    return _decode_result(result)['data'];
  }

  /// Derives addresses from [descriptor] for a given [network] with indexes from [start] to [end].
  /// [network] can be 'bitcoin', 'testnet', 'signet' or 'regtest'.
  /// 
  /// Throws a [SpecterRustException] if [descriptor] is invalid, network is unknown or indexes are out of range.
  /// Both [start] and [end] must be positive and less than 0x80000000.
  /// 
  /// Returns an list with addresses.
  static List<dynamic> derive_addresses(String descriptor, String network, int start, int end){
    final ptrDescriptor = descriptor.toNativeUtf8(allocator: malloc);
    final ptrNetwork = network.toNativeUtf8(allocator: malloc);

    final ptrResult = _bindings.derive_addresses(ptrDescriptor.cast<Int8>(), ptrNetwork.cast<Int8>(), start, end);
    final result = ptrResult.cast<Utf8>().toDartString();
    _bindings.rust_cstr_free(ptrResult);

    malloc.free(ptrDescriptor);
    malloc.free(ptrNetwork);
    return _decode_result(result)['data'];
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
    print('Hello from specter_rust (Dart side)');
  }
}
