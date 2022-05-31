import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'bindings.dart';
import 'specter_rust.dart';

class DiskStorage {
  static SpecterRustBindings? _bindings;

  static void loadBindings() {
    _bindings = SpecterRust.getBindings();
  }

  static bool openStorage(String path) {
    if (_bindings == null) {
      loadBindings();
    }

    final ptrName = path.toNativeUtf8(allocator: malloc);

    bool result = _bindings!.ds_open_storage(ptrName.cast<Int8>()) == 1;

    malloc.free(ptrName);
    return result;
  }

  static bool createVolume(int volumeIdx, String pass) {
    if (_bindings == null) {
      return false;
    }

    final ptrName = pass.toNativeUtf8(allocator: malloc);
    bool result = _bindings!.ds_create_volume(volumeIdx, ptrName.cast<Int8>()) == 1;

    malloc.free(ptrName);
    return result;
  }

  static bool openVolume(int volumeIdx, String pass) {
    if (_bindings == null) {
      return false;
    }

    final ptrName = pass.toNativeUtf8(allocator: malloc);
    bool result = _bindings!.ds_open_volume(volumeIdx, ptrName.cast<Int8>()) == 1;

    malloc.free(ptrName);
    return result;
  }

  static bool readStorage(int volumeIdx, int clusterIdx) {
    if (_bindings == null) {
      return false;
    }

    final ptrName = malloc.allocate(1024);
    bool result = _bindings!.ds_read_storage(volumeIdx, clusterIdx, ptrName.cast<Int8>()) == 1;

    var x = ptrName.cast<Utf8>();
    final fooDart = x.toDartString();

    malloc.free(ptrName);
    return result;
  }

  static bool writeStorage(int volumeIdx, int clusterIdx, String data, int dataSize) {
    if (_bindings == null) {
      return false;
    }

    final ptrName = data.toNativeUtf8(allocator: malloc);
    bool result = _bindings!.ds_write_storage(volumeIdx, clusterIdx, ptrName.cast<Int8>(), dataSize) == 1;

    malloc.free(ptrName);
    return result;
  }
}