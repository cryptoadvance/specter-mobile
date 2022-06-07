import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'DiskContainer.dart';

class DiskHeader {
  final int version, headerCount;
  final List<int> clusters;
  final Map<int, List<int>> resourceMap;

  DiskHeader({
    required this.version,
    required this.headerCount,
    required this.clusters,
    required this.resourceMap
  });

  @override
  String toString() {
    List<String> resourceList = [];
    resourceMap.forEach((resID, clusters) {
      resourceList.add('resID: ' + resID.toString() + ', clusters: ' + clusters.join(','));
    });
    return jsonEncode({
      'version': version,
      'resources': resourceList
    });
  }

  List<int> getClustersByResourceMap() {
    Map<int, int> clustersMap = {};
    resourceMap.forEach((resID, clusters) {
      clusters.forEach((clusterID) {
        clustersMap[clusterID] = resID;
      });
    });
    List<int> clustersList = [];
    for (int i = 0; i < DiskBlobsContainer.clustersInHeader; i++) {
      int resID = 0;
      if (clustersMap.containsKey(i)) {
        resID = clustersMap[i]!;
      }
      clustersList.add(resID);
    }
    return clustersList;
  }
}

class DiskBlobsContainer {
  final DiskContainer _diskContainer;
  static int clustersInHeader = 500;

  DiskBlobsContainer({required DiskContainer diskContainer}): _diskContainer = diskContainer;

  void writeData(int resourceID, Uint8List data) {
    if (resourceID < 1) {
      throw 'wrong resourceID';
    }

    //
    _readDiskHeaders();

    //
    int dataLength = data.length;
    int dataChunkId = 0;
    for (int i = 0; i < dataLength; i += 1024) {
      int clusterId = findResourceDataChunkClusterId(resourceID, dataChunkId);
      if (clusterId < 0) {
        throw 'not enough space';
      }

      //
      int end = i + 1024;
      if (end > dataLength) {
        end = dataLength;
      }
      Iterable<int> dataX = data.getRange(i, end);
      Uint8List chunkData = Uint8List(1024);
      chunkData.setAll(0, dataX);

      //
      _diskContainer.writeCluster(clusterId, chunkData);

      //
      dataChunkId++;
    }

    //
    _writeDiskHeaders();
  }

  Uint8List readData(int resourceId) {
    if (resourceId < 1) {
      throw 'wrong resourceId';
    }

    //
    _readDiskHeaders();

    //
    BytesBuilder bytesBuilder = BytesBuilder();

    //
    for (int headerId = 0; headerId < diskHeaders.length; headerId++) {
      DiskHeader diskHeader = diskHeaders[headerId]!;
      List<int>? clusters = diskHeader.resourceMap[resourceId];
      if (clusters == null) {
        break;
      }
      clusters.forEach((clusterId) {
        Uint8List data = _diskContainer.readCluster(clusterId + headerId * (clustersInHeader + 2) + 1);
        bytesBuilder.add(data);
      });
    }

    return bytesBuilder.takeBytes();
  }

  /*
   * Header format:
   * [version] - uint32_t
   * [cluster 1] - resourceID
   * [cluster 2] - resourceID
   *
   * Header cluster: 0
   * Data clusters: 1, 2, 3, ..., 501           = 502 * 0 + 1
   * Header cluster: 502
   * Data clusters: 503, 504, 505, ..., 1003    = 502 * 1 + 1
   * Header cluster: 1004
   * Data clusters: 1005                        = 502 * 2 + 1
   */
  Map<int, DiskHeader> diskHeaders = {};
  void _readDiskHeaders() {
    diskHeaders.clear();

    diskHeaders[0] = _readDiskHeader(0);

    print('read header (struct): ' + diskHeaders[0].toString());
  }

  DiskHeader _readDiskHeader(int headerId) {
    Uint8List header = _diskContainer.readCluster(headerId * 502);
    //print('read header: ' + header.toString());

    ByteData byteData = header.buffer.asByteData();

    int version = byteData.getUint32(0);
    int headerCount = byteData.getUint32(4);

    List<int> clusters = [];
    Map<int, List<int>> resourceMap = HashMap();

    int offset = 24;
    int clusterID = 0;
    while(true) {
      int resID;
      try {
        resID = byteData.getUint16(offset);
      } catch(e) {
        break;
      }

      if (resID > 0) {
        if (!resourceMap.containsKey(resID)) {
          resourceMap[resID] = [];
        }
        resourceMap[resID]!.add(clusterID);
      }

      clusters.add(resID);

      offset += 2;
      clusterID++;
    }

    //
    DiskHeader diskHeader = DiskHeader(
      version: version,
      headerCount: headerCount,
      clusters: clusters,
      resourceMap: resourceMap
    );
    return diskHeader;
  }

  void _writeDiskHeaders() {
    _writeDiskHeader(0, diskHeaders[0]!);

    //
    print('write header (struct): ' + diskHeaders[0]!.toString());
  }

  void _writeDiskHeader(int headerId, DiskHeader diskHeader) {
    ByteData byteData = ByteData(1024);

    int version = diskHeader.version;
    int headerCount = diskHeader.headerCount;
    if (version < 100) {
      version = 100;
    }
    if (headerCount < 1) {
      headerCount = 1;
    }

    byteData.setUint32(0, version);
    byteData.setUint32(4, headerCount);

    List<int> clusters = diskHeader.getClustersByResourceMap();

    int offset = 24;
    clusters.forEach((resID) {
      byteData.setUint16(offset, resID);
      offset += 2;
    });

    Uint8List data = byteData.buffer.asUint8List();

    //print('write header: ' + data.toString());

    _diskContainer.writeCluster(headerId * 502, data);
  }

  int findResourceDataChunkClusterId(int resourceId, int dataChunkId) {
    for (int headerId = 0; headerId < diskHeaders.length; headerId++) {
      DiskHeader diskHeader = diskHeaders[headerId]!;
      List<int>? clusters = diskHeader.resourceMap[resourceId];
      if (clusters == null) {
        diskHeader.resourceMap[resourceId] = [];
        clusters = diskHeader.resourceMap[resourceId];
      }

      //
      if (clusters!.length > dataChunkId) {
        return clusters[dataChunkId] + headerId * (clustersInHeader + 2) + 1;
      }

      //Find free cluster
      int clusterId = findFreeCluster(diskHeader, resourceId);
      if (clusterId < 0) {
        continue;
      }

      //
      clusters.insert(dataChunkId, clusterId);
      diskHeader.clusters[clusterId] = resourceId;
      return clusterId + headerId * (clustersInHeader + 2) + 1;
    }
    return -1;
  }

  int findFreeCluster(DiskHeader diskHeader, int useResourceId) {
    for (int clusterId = 0; clusterId < diskHeader.clusters.length; clusterId++) {
      int resId = diskHeader.clusters[clusterId];
      if (resId == 0) {
        return clusterId;
      }
    }
    return -1;
  }
}