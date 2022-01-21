import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class SGenerateEntropyExternalEvent {
  List<int>? digest;

  SGenerateEntropyExternalEvent({this.digest});

  bool isGenerated() {
    return digest != null;
  }

  String getHexView() {
    if (digest == null) {
      return '';
    }
    return HEX.encode(digest!);
  }

  @override
  String toString() {
    return jsonEncode({
      'digest': digest!.toString()
    });
  }
}

class CEntropyExternalGenerationService {
  bool isStarted = false;
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  late StreamController<SGenerateEntropyExternalEvent> streamController = StreamController<SGenerateEntropyExternalEvent>.broadcast();
  late Stream<SGenerateEntropyExternalEvent> stream = streamController.stream;

  StreamSubscription<SGenerateEntropyExternalEvent> init(void Function(SGenerateEntropyExternalEvent) cb) {
    return stream.listen((item) {
      cb(item);
    });
  }

  Future<bool> start() async {
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

    _controller = CameraController(firstCamera, ResolutionPreset.low, enableAudio: false);
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    await _controller!.startImageStream(processImageFrame);
    isStarted = true;
    return true;
  }

  CameraController? getCameraController() {
    if (!isStarted) {
      return null;
    }
    return _controller;
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

    streamController.add(SGenerateEntropyExternalEvent(digest: digest.bytes));
  }

  Future<void> close() async {
    print('CEntropyGenerationService close');
    isStarted = false;
    await _controller?.dispose();
    _controller = null;
    return;
  }
}