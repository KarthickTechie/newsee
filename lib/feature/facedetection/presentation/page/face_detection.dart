/* 
@author   :   karthick.d  
@desc     :   face detection and comparision with selfi image and image 
              present in the KYC id

 */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/ML/Recognition.dart';
import 'package:newsee/ML/Recognizer.dart';
import 'package:newsee/feature/facedetection/presentation/page/face_paint.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui show Codec, FrameInfo, Image, ImmutableBuffer;

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  File? selImage;
  late List<Face> faces;
  ui.Image? image;
  img.Image? croppedImage;
  late Recognizer recognizer;
  late FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
    ),
  );

  bool isChecking = false;
  // pick image from the gallery

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recognizer = Recognizer();
  }

  pickImage() async {
    final picker = ImagePicker();
    final imageFilePath = await picker.pickImage(source: ImageSource.gallery);
    if (imageFilePath != null) {
      selImage = File(imageFilePath.path);
      setState(() {
        selImage;
        doFaceDetection();
      });
    }
  }

  // capture selfie from camera

  captureImage() async {
    final picker = ImagePicker();
    final imageFilePath = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (imageFilePath != null) {
      selImage = File(imageFilePath.path);
      setState(() {
        selImage;
        doFaceDetection();
        //cropTheFaceData();
      });
    }
  }

  void doFaceDetection() async {
    final inputImage = InputImage.fromFile(selImage!);
    faces = await faceDetector.processImage(inputImage);
    for (final face in faces) {
      final boundingBox = face.boundingBox;
      print('face => ${boundingBox.toString()}');
      cropTheFaceData(face);
    }
    drawRectangleAroundFace();

    // crop the face from image data for creating tensorflow embedding
  }

  drawRectangleAroundFace() async {
    final imageBytes = await selImage!.readAsBytes();
    image = await decodeImageFromList(imageBytes);
    setState(() {
      image;
      faces;
    });
  }

  cropTheFaceData(Face face) async {
    if (selImage != null) {
      final imgbytes = await selImage!.readAsBytes();

      img.Image? tmpImage = img.decodeImage(imgbytes);
      final faceRect = face.boundingBox;
      croppedImage = img.copyCrop(
        tmpImage!,
        x: faceRect.left.toInt(),
        y: faceRect.top.toInt(),
        width: faceRect.width.toInt(),
        height: faceRect.height.toInt(),
      );

      Recognition faceRecognition = await recognizer.recognize(
        croppedImage!,
        faceRect,
      );
      final faceEmbedding = faceRecognition.embeddings;
      if (!isChecking) {
        print('faceembedding : ${faceEmbedding.toString()}');

        showFaceRegistrationDialogue(
          Uint8List.fromList(img.encodePng(croppedImage!)),
          faceRecognition,
        );
      } else {
        print('name : ${faceRecognition.name.toString()}');
      }
      setState(() {
        croppedImage;
        image;
        faces;
      });
    }
  }

  /// this function shows the alert dialog to save he cropped face embedding
  /// and name of the person and save in db

  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Register Face", textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(
                      cropedFace,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1f4037),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      recognizer.registerFaceInDB(
                        textEditingController.text,
                        recognition.embeddings,
                      );
                      textEditingController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Face Registered")),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // following code showw the cropped image
            // croppedImage != null
            //     ? Image.memory(Uint8List.fromList(img.encodePng(croppedImage!)))
            image != null
                ? FittedBox(
                  child: SizedBox(
                    width: image!.width.toDouble(),
                    height: image!.height.toDouble(),
                    child: CustomPaint(
                      painter: Facepaint(facesList: faces, imageFile: image),
                    ),
                  ),
                )
                : Icon(Icons.image_outlined, size: 50),

            ElevatedButton(
              onPressed: () {
                // open gallery image
                isChecking = false;
                pickImage();
              },
              onLongPress: () {
                isChecking = false;

                captureImage();
              },
              child: Text('Choose Image'),
            ),
            ElevatedButton(
              onPressed: () {
                // open gallery image
                isChecking = true;

                pickImage();
              },
              onLongPress: () {
                isChecking = true;
                captureImage();
              },
              child: Text('Check'),
            ),
          ],
        ),
      ),
    );
  }
}
