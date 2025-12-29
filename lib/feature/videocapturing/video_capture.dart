/*
author: Gayathri B 
date: 01/07/2025
description: Video capture screen to record videos using device camera

*/

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/feature/videocapturing/video_preview.dart';
import 'package:video_compress/video_compress.dart';

class VideoCapture extends StatefulWidget {
  String capturedTime;
  String capturedDate;
  String finalData;
  String videoFile;

  VideoCapture({
    super.key,
    required this.finalData,
    required this.capturedDate,
    required this.capturedTime,
    required this.videoFile,
  });

  @override
  State<VideoCapture> createState() => _VideoCaptureState();
}

class _VideoCaptureState extends State<VideoCapture> {
  CameraController? controller;
  List<CameraDescription> cameras = [];

  bool isRecording = false;
  bool isProcessing = false;
  int recordingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  // load available cameras
  Future<void> loadCamera() async {
    try {
      // create instance of available cameras
      cameras = await availableCameras();
      controller = CameraController(
        cameras.first,
        ResolutionPreset.low,
        enableAudio: true,
      );

      await controller!.initialize();

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  // start video recording

  Future<void> startRecording() async {
    if (isProcessing) return;
    // check if controller is initialized
    if (controller == null || !controller!.value.isInitialized) return;

    isProcessing = true;

    try {
      await controller!.startVideoRecording();

      setState(() {
        isRecording = true;
        recordingSeconds = 0;
      });
      // start timer to track recording duration
      timer = Timer.periodic(const Duration(seconds: 1), (time) async {
        if (!mounted) return;

        setState(() => recordingSeconds++);
        // auto stop recording after 15 seconds
        if (recordingSeconds >= 15) {
          time.cancel();
          await stopRecording();
        }
      });
    } catch (e) {
      debugPrint("Start Recording Error: $e");
    } finally {
      isProcessing = false;
    }
  }

  // stop video recording
  Future<void> stopRecording() async {
    if (isProcessing) return;
    // check if controller is recording
    if (controller == null || !controller!.value.isRecordingVideo) return;

    isProcessing = true;

    try {
      // cancel the timer
      timer?.cancel();
      // stop video recording
      XFile recordedFile = await controller!.stopVideoRecording();
      // get recorded video path
      final recordedPath = recordedFile.path;
      // read video file as bytes
      final videoBytes = await recordedFile.readAsBytes();
      // save video bytes to a temporary file

      final videoFile = await MediaService().saveBytesToFile(
        videoBytes,
        '${Random().nextInt(100000).toString()}-videorecord.mp4',
      );

      //       final MediaInfo info = await VideoCompress.compressVideo(
      //   filePath,
      //   quality: VideoQuality.LowQuality, // Choose a quality setting
      //   deleteOrigin: false, // Keep the original file
      // )

      final mediaInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, 
      );
      print("mediaInfo ${mediaInfo.toString()}");
      print("videoFile ${videoFile.path}");
      print("VideoQuality ${VideoQuality.DefaultQuality}");


      widget.videoFile = mediaInfo!.path!;

      // capture current data
      final String capturedDate =
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
      // capture current time
      final String capturedTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

      setState(() {
        isRecording = false;
        recordingSeconds = 0;
      });

      if (!mounted) return;
      // navigate to video preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoPreview(
                videoPath: recordedPath,
                finalDataValue: widget.finalData,
                capturedDate: capturedDate,
                capturedTime: capturedTime,
                videoFile: videoFile.path,
              ),
        ),
      );
    } catch (e) {
      debugPrint("Stop Recording Error: $e");
    } finally {
      isProcessing = false;
    }
  }
  // format time in mm:ss for video display

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // show loading indicator if camera is not initialized
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Video Capture")),
      body: Stack(
        children: [
          // display camera preview
          CameraPreview(controller!),
          // show recording timer
          if (isRecording)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formatTime(recordingSeconds),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // capture/stop button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed:
                    isProcessing
                        ? null
                        : isRecording
                        ? () async => await stopRecording()
                        : () async {
                          // get current location
                          final location = await MediaService().getLocation(
                            context,
                          );
                          // get location details
                          final placeMark = await MediaService()
                              .getLocationDetails(
                                location.position!.latitude,
                                location.position!.longitude,
                              );

                          final placeDetails = jsonEncode(placeMark[0]);
                          final placeData = jsonDecode(placeDetails);
                          // concatenate location details into a single string

                          final placeDataConcat =
                              [
                                    placeData['name'],
                                    placeData['street'],
                                    placeData['subThoroughfare'],
                                    placeData['thoroughfare'],
                                    placeData['subLocality'],
                                    placeData['locality'],
                                    placeData['subAdministrativeArea'],
                                    placeData['administrativeArea'],
                                    placeData['postalCode'],
                                    placeData['country'],
                                    placeData['isoCountryCode'],
                                  ]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .toList();

                          final int splitIndex = placeDataConcat.length - 4;
                          // split the location data into two parts for better readability
                          final finalData =
                              "${placeDataConcat.take(splitIndex).join(',')}\n${placeDataConcat.skip(splitIndex).join(', ')}";

                          widget.finalData = finalData;

                          await startRecording();
                        },
                // button label
                child: Text(isRecording ? "Stop Recording" : "Capture Video"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
