/* 
@author   :   karthick.d  
@desc     :   face detection and comparision with selfi image and image 
              present in the KYC id
 suresh DL : fDL. No. TN12 20210008898
 karthick DL :  fDL No. TN11 20210008092
 */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/ML/Recognition.dart';
import 'package:newsee/ML/Recognizer.dart';
import 'package:newsee/Utils/ocr_utils.dart';
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
  bool isKYCInvalid = false;
  // pick image from the gallery
  ScrollController _scrollController = ScrollController();
  Map<String, String> ocrresult = {};
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer(
    script: TextRecognitionScript.latin,
  );

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
      final inputImage = InputImage.fromFile(selImage!);

      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      String extractedText = recognizedText.text;
      print('extractedText : $extractedText');
      ocrresult = extractDLInfo(extractedText);
      // print(
      //   "idtype : $ocrresult['idtype'] \n id  : $ocrresult['id']  \n name : $ocrresult['name']",
      // );
      print(ocrresult);
      if (ocrresult['id']!.isEmpty) {
        isKYCInvalid = true;
        if (isKYCInvalid) {
          showAlertDialog(
            title: 'Processing Error',
            message: 'Upload Valid KYC Document',
          );
        }

        setState(() {
          selImage;
          isKYCInvalid;
          ocrresult;
        });
      } else {
        setState(() {
          selImage;
          ocrresult;
          doFaceDetection();
        });
      }
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
      final inputImage = InputImage.fromFile(selImage!);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      String extractedText = recognizedText.text;
      print('extractedText : $extractedText');
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
        // if (ocrresult['name']!.toLowerCase() ==
        //     faceRecognition.name.toString().toLowerCase()) {
        showAlertDialog(title: 'Success', message: 'Face Matched Successfully');

        // } else {
        //   showAlertDialog(
        //     title: 'Failure',
        //     message: 'Your Face Not Matched with KYC. Try Again',
        //   );
        // }
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

  TextEditingController textEditingController = TextEditingController(text: '');

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
                    controller: TextEditingController(text: ocrresult['name']),
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
                  TextField(
                    controller: TextEditingController(text: ocrresult['id']),
                    decoration: InputDecoration(
                      hintText: "ID Number",
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

  showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Processing Error'),
          titleTextStyle: TextStyle(color: Colors.red),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Upload Valid KYC Document'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1f4037),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  showAlertDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1f4037),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.sizeOf(context).height;
    final _width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Liveliness Check'),
        bottom: PreferredSize(
          preferredSize: Size(_width, 70),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text('1'),
                    ),
                    Text('Upload KYC'),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text('2'),
                    ),
                    Text('Upload Selfie'),
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green,

                      child: Text('3'),
                    ),
                    Text(' Verify'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      body: ListView(
        controller: _scrollController,
        children: [
          Card(
            // upload kyc card - start
            child: SizedBox(
              width: _width,
              height: _height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 215, 211, 211),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // following code showw the cropped image
                      // croppedImage != null
                      //     ? Image.memory(Uint8List.fromList(img.encodePng(croppedImage!)))
                      image != null
                          ? SafeArea(
                            child: FittedBox(
                              child: SizedBox(
                                width: image!.width.toDouble(),
                                height: image!.height.toDouble(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 120.0,
                                  ),
                                  child: CustomPaint(
                                    painter: Facepaint(
                                      facesList: faces,
                                      imageFile: image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // open gallery image
                                  isChecking = false;
                                  pickImage();
                                },
                                onLongPress: () {
                                  isChecking = false;
                                  captureImage();
                                },

                                borderRadius: BorderRadius.circular(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Scan KYC Document',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Use your camera', // More concise text
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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
                            child: Text('Upload KYC Document'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // open gallery image
                              scrollToNext(_height);
                            },
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ), // // upload kyc card - start
          Card(
            // upload selfie card - start
            child: SizedBox(
              width: _width,
              height: _height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 215, 211, 211),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // following code showw the cropped image
                      // croppedImage != null
                      //     ? Image.memory(Uint8List.fromList(img.encodePng(croppedImage!)))
                      image != null
                          ? SafeArea(
                            child: FittedBox(
                              child: SizedBox(
                                width: image!.width.toDouble(),
                                height: image!.height.toDouble(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 120.0,
                                  ),
                                  child: CustomPaint(
                                    painter: Facepaint(
                                      facesList: faces,
                                      imageFile: image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // open gallery image
                                  isChecking = true;
                                  // pickImage();
                                },
                                onLongPress: () {
                                  isChecking = true;
                                  captureImage();
                                },

                                borderRadius: BorderRadius.circular(12.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.camera_enhance,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Take a Selfie',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        'Use your camera', // More concise text
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 50),

                      ElevatedButton(
                        onPressed: () {
                          // open gallery image
                          isChecking = true;

                          // pickImage(context);
                        },
                        onLongPress: () {
                          isChecking = true;
                          captureImage();
                        },
                        child: Text('Check'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // open gallery image
                          scrollToNext(_height);
                        },
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ), // // upload selfie card - start
          Card(
            child: SizedBox(
              width: _width,
              height: _height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: ElevatedButton(onPressed: () {}, child: Text('Next')),
                ),
              ),
            ),
          ),
        ],
      ),
      /*
       Center(
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
      */
    );
  }

  void scrollToNext(double _height) {
    _scrollController.animateTo(
      _scrollController.offset + _height + 20,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
    );
  }
}
