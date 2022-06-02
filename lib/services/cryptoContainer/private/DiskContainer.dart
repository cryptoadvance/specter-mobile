import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:specter_rust/DiskStorage.dart';

class DiskContainer {
  static const int usedVolumes = 5;

  Future<bool> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print('path: ' + appDocPath);

    var res = DiskStorage.openStorage(appDocPath);
    print('open storage: ' + res.toString());

    //test();

    return true;
  }

  bool createVolume(int volumeIdx, String pass) {
    return DiskStorage.createVolume(volumeIdx, pass);
  }

  bool findVolumeAndOpen(String pass) {
    int volumeIdx = DiskStorage.findVolumeAndOpen(pass);
    if (volumeIdx < 0) {
      return false;
    }
    print('Find volume: ' + volumeIdx.toString());
    return true;
  }

  void test() {
    var res = DiskStorage.createVolume(3, "1234");
    print('create volume: ' + res.toString());


    Uint8List data = Uint8List.fromList('test1'.codeUnits);
    Uint8List writeData = Uint8List(1024);
    for (var i = 0; i < data.length; i++) {
      writeData[i] = data[i];
    }

    res = DiskStorage.writeStorage(0, 0, writeData);
    print('write storage: ' + res.toString());

    Uint8List readData = Uint8List(1024);
    DiskStorage.readStorage(0, 0, readData);
    print('read: ' + readData.toString());
  }
}