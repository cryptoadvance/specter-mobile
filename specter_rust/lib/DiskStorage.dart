import 'dart:ffi';
import 'dart:typed_data';

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

  static int findVolumeAndOpen(String pass) {
    if (_bindings == null) {
      return -1;
    }

    final ptrName = pass.toNativeUtf8(allocator: malloc);
    int volumeIdx = _bindings!.ds_find_volume_and_open(ptrName.cast<Int8>());

    malloc.free(ptrName);
    return volumeIdx;
  }

  static int clusterSize = 1024;

  static bool readStorage(int volumeIdx, int clusterIdx, Uint8List data) {
    if (_bindings == null) {
      return false;
    }
    if (data.length != clusterSize) {
      return false;
    }

    final blob = calloc<Uint8>(clusterSize);
    bool result = _bindings!.ds_read_storage(volumeIdx, clusterIdx, blob.cast<Int8>(), clusterSize) == 1;

    final blobBytes = blob.asTypedList(clusterSize);
    data.setAll(0, blobBytes);

    malloc.free(blob);
    return result;
  }

  static bool writeStorage(int volumeIdx, int clusterIdx, Uint8List data) {
    if (_bindings == null) {
      return false;
    }
    if (data.length != clusterSize) {
      return false;
    }

    final blob = calloc<Uint8>(clusterSize);
    final blobBytes = blob.asTypedList(clusterSize);
    blobBytes.setAll(0, data);

    bool result = _bindings!.ds_write_storage(volumeIdx, clusterIdx, blob.cast<Int8>(), clusterSize) == 1;

    malloc.free(blob);
    return result;
  }
}