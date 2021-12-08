import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:camera/camera.dart';

class CEntropyGenerationService {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  void init() async {
    print('CEntropyGenerationService init');

    var cameras = await availableCameras();
    var firstCamera = cameras.first;
    print('first camera: ' + firstCamera.name);

    _controller = CameraController(firstCamera, ResolutionPreset.low);
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    await _controller!.startImageStream(processImageFrame);
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

  void close() {
    print('CEntropyGenerationService close');
    _controller?.dispose();
  }
}