import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class LivenessDetector {
  late final Interpreter _interpreter;
  final double spoofThreshold;

  LivenessDetector({this.spoofThreshold = 0.5}) {
    loadModel('assets/ml_models/model.tflite');
  }

  /// Load the TFLite model.
  Future<void> loadModel(String assetPath) async {
    _interpreter = await Interpreter.fromAsset(assetPath);
  }

  /// Close the interpreter when done.
  void close() {
    _interpreter.close();
  }

  /// Run liveness detection on the given image.
  /// Expects a 224x224 RGB image.
  Future<bool> isLive(img.Image faceImage) async {
    final input = Float32List(224 * 224 * 3);
    int i = 0;
    for (final p in faceImage) {
      input[i++] = p.r / 255.0;
      input[i++] = p.g / 255.0;
      input[i++] = p.b / 255.0;
    }

    final inputTensor = input.reshape([1, 224, 224, 3]);
    final outputTensor = Float32List(1).reshape([1, 1]);

    _interpreter.run(inputTensor, outputTensor);

    final score = outputTensor[0][0];
    debugPrint('Spoof score → $score');
    return score < spoofThreshold;
  }
}
