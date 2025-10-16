// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class LottiAnmationWidget extends StatelessWidget {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Lottie.asset(
//           "assets/No_Data_found.json", // Lottie file
//           width: 200,
//           height: 200,
//           repeat: true,
//         ),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LottiAnmationWidget extends StatefulWidget {
  const LottiAnmationWidget({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<LottiAnmationWidget> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isValidDocument = false;
  String _errorMessage = '';
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> _validateDocument() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Validate Aadhaar card (e.g., check for 12-digit number)
      bool isValid = _isAadhaarValid(recognizedText.text);

      setState(() {
        _isValidDocument = isValid;
        _errorMessage = isValid ? '' : 'Please capture a correct document';
      });
    } catch (e) {
      setState(() {
        _isValidDocument = false;
        _errorMessage = 'Error processing image: $e';
      });
    }
  }

  bool _isAadhaarValid(String text) {
    // Basic Aadhaar validation: Check for 12-digit number
    final aadhaarPattern = RegExp(r'\b\d{4}\s?\d{4}\s?\d{4}\b');
    final hasGovernmentOfIndia = text.contains('Government of India');
    return aadhaarPattern.hasMatch(text) && hasGovernmentOfIndia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Aadhaar Card')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller!),
                // Display error message if document is invalid
                if (!_isValidDocument && _errorMessage.isNotEmpty)
                  Positioned(
                    bottom: 100,
                    left: 20,
                    right: 20,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Show capture button only if document is valid
                if (_isValidDocument)
                  Positioned(
                    bottom: 20,
                    left: MediaQuery.of(context).size.width / 2 - 30,
                    child: FloatingActionButton(
                      onPressed: () async {
                        final image = await _controller!.takePicture();
                        // Handle the captured image (e.g., save or process further)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Image captured: ${image.path}')),
                        );
                      },
                      child: const Icon(Icons.camera),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validateDocument,
        child: const Icon(Icons.scanner),
      ),
    );
  }
}
