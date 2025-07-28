import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const FaceDetectionScreen({Key? key, required this.cameras})
    : super(key: key);

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isBusy = false;
  int _blinkCount = 0;
  String _headMotion = 'No motion';
  bool _wasEyeClosed = false;
  int _currentCameraIndex = 0; // 0 for front, 1 for rear (if available)

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    _initializeCamera(widget.cameras[_currentCameraIndex]);
  }

  void _initializeCamera(CameraDescription camera) {
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
        if (rotY > 10) {
          _headMotion = 'Head turned right';
        } else if (rotY < -10) {
          _headMotion = 'Head turned left';
        } else if (rotZ > 10) {
          _headMotion = 'Head tilted right';
        } else if (rotZ < -10) {
          _headMotion = 'Head tilted left';
        } else {
          _headMotion = 'No motion';
        }
      } else {
        _headMotion =
            'No face detected. Please position your face in the frame.';
      }
    });

    _isBusy = false;
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
    if (widget.cameras.length < 2) return; // No other camera available
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
