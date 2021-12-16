import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CEntropyGenerationService {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  Future<bool> init() async {
    print('CEntropyGenerationService init');

    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera
    ].request();
    print(statuses[Permission.camera]);

    if (!(await Permission.camera.request().isGranted)) {
      return false;
    }

    var cameras = await availableCameras();
    var firstCamera = cameras.first;
    print('first camera: ' + firstCamera.name);

    _controller = CameraController(firstCamera, ResolutionPreset.low);
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    await _controller!.startImageStream(processImageFrame);
    return true;
  }

  void processImageFrame(CameraImage img) {
    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);

    for (int planeIdx = 0; planeIdx < img.planes.length; planeIdx++) {
      var plane = img.planes[planeIdx];
      input.add(plane.bytes);
    }

    input.close();
    var digest = output.events.single;

    print('digest: ' + digest.toString());
  }

  Future<void> close() async {
    print('CEntropyGenerationService close');
    await _controller?.dispose();
    return;
  }
}