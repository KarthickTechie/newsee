import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceDetectionCapture extends StatefulWidget {
  final List<CameraDescription> cameras;

  const FaceDetectionCapture({Key? key, required this.cameras})
    : super(key: key);

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

// class _FaceDetectionScreenState extends State<FaceDetectionCapture> {
//   late CameraController _controller;
//   late FaceDetector _faceDetector;
//   bool _isBusy = false;
//   int _blinkCount = 0;
//   String _headMotion = 'No motion';
//   bool _wasEyeClosed = false;
//   int _currentCameraIndex = 0;
//   bool _headMovedLeft = false;
//   bool _headMovedRight = false;
//   String _captureStatus = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeFaceDetector();
//     _initializeCamera(widget.cameras[_currentCameraIndex]);
//   }

//   void _initializeCamera(CameraDescription camera) {
//     _controller = CameraController(camera, ResolutionPreset.veryHigh);
//     _controller
//         .initialize()
//         .then((_) {
//           if (!mounted) return;
//           _controller.startImageStream(_processCameraImage);
//           setState(() {});
//         })
//         .catchError((e) {
//           print('Camera initialization error: $e');
//         });
//   }

//   void _initializeFaceDetector() {
//     final options = FaceDetectorOptions(
//       enableClassification: true,
//       enableTracking: true,
//       enableLandmarks: true,
//       performanceMode: FaceDetectorMode.accurate,
//       minFaceSize: 0.1,
//     );
//     _faceDetector = FaceDetector(options: options);
//   }

//   Future<void> _processCameraImage(CameraImage image) async {
//     if (_isBusy) return;
//     _isBusy = true;

//     final inputImage = _cameraImageToInputImage(image);
//     print(
//       'Processing image: ${image.width}x${image.height}, format: ${image.format.group}',
//     );
//     final faces = await _faceDetector.processImage(inputImage);
//     print('Detected faces: ${faces.length}');

//     setState(() {
//       if (faces.isNotEmpty) {
//         final face = faces.first;
//         final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
//         final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;
//         print('Left eye: $leftEyeOpen, Right eye: $rightEyeOpen');
//         if (leftEyeOpen < 0.5 || rightEyeOpen < 0.5) {
//           if (!_wasEyeClosed) {
//             _blinkCount++;
//             _wasEyeClosed = true;
//             print('Blink detected! Total: $_blinkCount');
//           }
//         } else {
//           _wasEyeClosed = false;
//         }

//         final rotY = face.headEulerAngleY ?? 0.0;
//         final rotZ = face.headEulerAngleZ ?? 0.0;
//         print('Head angles: Y=$rotY, Z=$rotZ');
//         if (rotY > 10 && !_headMovedRight) {
//           _headMovedRight = true;
//           _headMotion = 'Head turned right';
//         } else if (rotY < -10 && !_headMovedLeft) {
//           _headMovedLeft = true;
//           _headMotion = 'Head turned left';
//         } else if (rotZ > 10) {
//           _headMotion = 'Head tilted right';
//         } else if (rotZ < -10) {
//           _headMotion = 'Head tilted left';
//         } else {
//           _headMotion = 'No motion';
//         }

//         // Check capture conditions
//         if (_blinkCount >= 3 &&
//             _headMovedLeft &&
//             _headMovedRight &&
//             _captureStatus.isEmpty) {
//           _captureImage();
//         }
//       } else {
//         _headMotion =
//             'No face detected. Please position your face in the frame.';
//       }
//     });

//     _isBusy = false;
//   }

//   Future<void> _captureImage() async {
//     try {
//       final XFile image = await _controller.takePicture();
//       final Directory tempDir = await getTemporaryDirectory();
//       final String filePath =
//           '${tempDir.path}/capture_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       await image.saveTo(filePath);
//       setState(() {
//         _captureStatus = 'Image captured at $filePath';
//       });
//       print('Image saved to: $filePath');
//     } catch (e) {
//       print('Error capturing image: $e');
//       setState(() {
//         _captureStatus = 'Failed to capture image';
//       });
//     }
//   }

//   InputImage _cameraImageToInputImage(CameraImage image) {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();

//     final Size imageSize = Size(
//       image.width.toDouble(),
//       image.height.toDouble(),
//     );
//     final InputImageRotation rotation =
//         widget.cameras[_currentCameraIndex].lensDirection ==
//                 CameraLensDirection.front
//             ? InputImageRotation.rotation270deg
//             : InputImageRotation.rotation90deg;
//     final InputImageFormat format = InputImageFormat.nv21;

//     return InputImage.fromBytes(
//       bytes: bytes,
//       metadata: InputImageMetadata(
//         size: imageSize,
//         rotation: rotation,
//         format: format,
//         bytesPerRow: image.planes[0].bytesPerRow,
//       ),
//     );
//   }

//   void _switchCamera() async {
//     if (widget.cameras.length < 2) return;
//     setState(() {
//       _isBusy = true;
//     });
//     await _controller.stopImageStream();
//     await _controller.dispose();

//     _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
//     _initializeCamera(widget.cameras[_currentCameraIndex]);
//     setState(() {
//       _isBusy = false;
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Blink & Head Motion Detection')),
//       body: Stack(
//         children: [
//           CameraPreview(_controller),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               color: Colors.black54,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Blinks: $_blinkCount',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   Text(
//                     'Head Motion: $_headMotion',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   Text(
//                     'Camera: ${widget.cameras[_currentCameraIndex].lensDirection == CameraLensDirection.front ? "Front" : "Rear"}',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   Text(
//                     'Capture: $_captureStatus',
//                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _switchCamera,
//         child: const Icon(Icons.flip_camera_ios),
//       ),
//     );
//   }
// }
class _FaceDetectionScreenState extends State<FaceDetectionCapture> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isBusy = false;
  int _blinkCount = 0;
  String _headMotion = 'No motion';
  bool _wasEyeClosed = false;
  int _currentCameraIndex = 1;
  bool _headMovedLeft = false;
  bool _headMovedRight = false;
  String _captureStatus = '';

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera(widget.cameras[_currentCameraIndex]);
  }

  void _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.veryHigh);
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          _controller.startImageStream(_processCameraImage);
          setState(() {});
        })
        .catchError((e) {
          print('Camera initialization error: $e');
        });
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.1,
    );
    _faceDetector = FaceDetector(options: options);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;

    final inputImage = _cameraImageToInputImage(image);
    print(
      'Processing image: ${image.width}x${image.height}, format: ${image.format.group}',
    );
    final faces = await _faceDetector.processImage(inputImage);
    print('Detected faces: ${faces.length}');

    setState(() {
      if (faces.isNotEmpty) {
        final face = faces.first;
        final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;
        print('Left eye: $leftEyeOpen, Right eye: $rightEyeOpen');
        if (leftEyeOpen < 0.5 || rightEyeOpen < 0.5) {
          if (!_wasEyeClosed) {
            _blinkCount++;
            _wasEyeClosed = true;
            print('Blink detected! Total: $_blinkCount');
          }
        } else {
          _wasEyeClosed = false;
        }

        final rotY = face.headEulerAngleY ?? 0.0;
        final rotZ = face.headEulerAngleZ ?? 0.0;
        print('Head angles: Y=$rotY, Z=$rotZ');
        if (rotY > 10 && !_headMovedRight) {
          _headMovedRight = true;
          _headMotion = 'Head turned right';
        } else if (rotY < -10 && !_headMovedLeft) {
          _headMovedLeft = true;
          _headMotion = 'Head turned left';
        } else if (rotZ > 10) {
          _headMotion = 'Head tilted right';
        } else if (rotZ < -10) {
          _headMotion = 'Head tilted left';
        } else {
          _headMotion = 'No motion';
        }

        // Check capture conditions
        if (_blinkCount >= 3 && _captureStatus.isEmpty) {
          Future.delayed(const Duration(milliseconds: 500), _captureImage);
        }
      } else {
        _headMotion =
            'No face detected. Please position your face in the frame.';
      }
    });

    _isBusy = false;
  }

  Future<void> _captureImage() async {
    try {
      final XFile image = await _controller.takePicture();
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/capture_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(filePath);
      setState(() {
        _captureStatus = 'Image captured at $filePath';
      });
      print('Image saved to: $filePath');
      _showImagePreview(filePath);
    } catch (e) {
      print('Error capturing image: $e');
      setState(() {
        _captureStatus = 'Failed to capture image';
      });
    }
  }

  void _showImagePreview(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Captured Image Preview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Image.file(
                  File(filePath),
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Error loading image');
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputImage _cameraImageToInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final InputImageRotation rotation =
        widget.cameras[_currentCameraIndex].lensDirection ==
                CameraLensDirection.front
            ? InputImageRotation.rotation270deg
            : InputImageRotation.rotation90deg;
    final InputImageFormat format = InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  void _switchCamera() async {
    if (widget.cameras.length < 2) return;
    setState(() {
      _isBusy = true;
    });
    await _controller.stopImageStream();
    await _controller.dispose();

    _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
    _initializeCamera(widget.cameras[_currentCameraIndex]);
    setState(() {
      _isBusy = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Blink & Head Motion Detection')),
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blinks: $_blinkCount',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Head Motion: $_headMotion',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Camera: ${widget.cameras[_currentCameraIndex].lensDirection == CameraLensDirection.front ? "Front" : "Rear"}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Capture: $_captureStatus',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchCamera,
        child: const Icon(Icons.flip_camera_ios),
      ),
    );
  }
}
