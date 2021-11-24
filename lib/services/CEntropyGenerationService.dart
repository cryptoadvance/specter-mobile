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
    int width = img.width;
    int height = img.height;
    int uvRowStride = img.planes[1].bytesPerRow;
    int uvPixelStride = img.planes[1].bytesPerPixel!;

    const shift = (0xFF << 24);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);

    List<int> chunkAll = [];
    List<int> chunkYp = [], chunkUp = [], chunkVp = [];
    for(int x = 0; x < width; x++) {
      int pixelSum = 0;
      int pixelSumYp = 0, pixelSumUp = 0, pixelSumVp = 0;
      for(int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride * (x/2).floor() + uvRowStride*(y/2).floor();
        final int index = y * width + x;

        final yp = img.planes[0].bytes[index];
        final up = img.planes[1].bytes[uvIndex];
        final vp = img.planes[2].bytes[uvIndex];

        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 -vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        int pixel = shift | (b << 16) | (g << 8) | r;
        pixelSum += pixel;

        pixelSumYp += yp;
        pixelSumUp += up;
        pixelSumVp += vp;
      }

      chunkAll.add(pixelSum);

      chunkYp.add(pixelSumYp);
      chunkUp.add(pixelSumUp);
      chunkVp.add(pixelSumVp);
    }

    input.add(chunkAll);
    input.add(chunkYp);
    input.add(chunkUp);
    input.add(chunkVp);

    input.close();
    var digest = output.events.single;

    print('digest: ' + digest.toString());
  }

  void close() {
    print('CEntropyGenerationService close');
    _controller?.dispose();
  }
}