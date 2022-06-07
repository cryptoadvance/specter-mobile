import 'dart:convert';
import 'dart:typed_data';

import '../DiskBlobsContainer.dart';
import 'DiskStorage.dart';

class DiskStorageJSON extends DiskStorage {
  final jsonEncoder = JsonEncoder();

  DiskStorageJSON({
    required DiskBlobsContainer diskBlobsContainer,
    required int resourceID
  }): super(diskBlobsContainer: diskBlobsContainer, resourceID: resourceID);

  void saveData(dynamic obj) {
    if (obj is String) {
      throw 'wrong obj type';
    }
    String str = jsonEncoder.convert(obj);
    Uint8List data = Uint8List.fromList(str.codeUnits);
    Uint8List bytes = packData(data);
    getContainer().writeData(getResourceID(), bytes);
  }

  dynamic readData() {
    Uint8List readData = getContainer().readData(getResourceID());
    if (readData.isEmpty) {
      return null;
    }
    Uint8List data = unpackData(readData);
    String str = String.fromCharCodes(data);
    var obj = jsonDecode(str);
    return obj;
  }
}