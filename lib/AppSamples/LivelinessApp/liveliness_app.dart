import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/LivelinessApp/face_detection_capture.dart';
import 'package:newsee/AppSamples/LivelinessApp/face_detection_screen.dart';

class LivelinessApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const LivelinessApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FaceDetectionCapture(cameras: cameras));
  }
}
