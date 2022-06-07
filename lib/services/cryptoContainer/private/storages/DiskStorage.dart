import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../DiskBlobsContainer.dart';

abstract class DiskStorage {
  final int _resourceID;
  late final DiskBlobsContainer _diskBlobsContainer;

  static const int packHeaderSize = 4 + 20;

  DiskStorage({
    required DiskBlobsContainer diskBlobsContainer,
    required int resourceID
  }): _diskBlobsContainer = diskBlobsContainer, _resourceID = resourceID;
  
  DiskBlobsContainer getContainer() {
    return _diskBlobsContainer;
  }

  int getResourceID() {
    return _resourceID;
  }

  Uint8List packData(Uint8List data) {
    int allLen = data.lengthInBytes + packHeaderSize;
    var bytes = Uint8List(allLen);
    var buffer = bytes.buffer;
    var blob = ByteData.view(buffer);

    var digest = sha1.convert(data);
    //print('hash: ' + digest.bytes.toString() + ' ' + digest.bytes.length.toString());

    blob.setUint32(0, data.length);
    bytes.setAll(4, digest.bytes);
    bytes.setAll(packHeaderSize, data);

    //print('bytes: ' + bytes.toString());
    return bytes;
  }

  Uint8List unpackData(Uint8List pack) {
    var buffer = pack.buffer;
    var blob = ByteData.view(buffer);

    int len = blob.getUint32(0);

    var hashData = Uint8List(20);
    hashData.setAll(0, pack.getRange(4, 4 + 20));

    var data = Uint8List(len);
    data.setAll(0, pack.getRange(packHeaderSize, packHeaderSize + len));

    //
    List<int> digestBytes = sha1.convert(data).bytes;
    //print('hash: ' + hashData.toString() + ' ' + digestBytes.toString());

    if (!compareSigns(hashData, digestBytes)) {
      throw 'wrong disk storage sign';
    }

    return data;
  }

  bool compareSigns(Uint8List signA, List<int> signB) {
    if ((signA.length != 20) && (signB.length != 20)) {
      return false;
    }

    for (int i = 0; i < signA.length; i++) {
      if (signB[i] != signA[i]) {
        return false;
      }
    }

    return true;
  }
}