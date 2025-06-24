import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/blocs/camera/camera_event.dart';
import 'package:newsee/blocs/camera/camera_repository.dart';
import 'package:newsee/blocs/camera/camera_state.dart';

/* 
@author         :   ganeshkumar.b   12/05/2025
@description    :   Bloc that perform action on dispatched events
                    like CameraOpen,CameraLensChange,CameraCapture,CameraReCapture,CameraExit
@props          :   null

 */
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;
  Uint8List? imageBytes;
  late List<CameraDescription> cameras;

  CameraBloc() : super(CameraIntialize()) {
    on<CameraOpen>(camerainit);
    on<CameraLensChange>(camerachange);
    on<FlashModeChange>(cameraflash);
    on<CaptureImage>(cameracapture);
    on<CameraReCapture>(camerarecaptrue);
    on<CameraExit>(confirmimage);
  }

  // It performs initialize then Camera
  Future<void> camerainit(event, emit) async {
    emit(CameraIntialize());
    try {
      cameras = await availableCameras();
      controller = CameraController(
        cameras[0],
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );
      await controller?.initialize();
      emit(CameraRun(controller!));
    } catch (error) {
      emit(CameraFailure(error.toString()));
    }
  }

  // It performs Change the Camera front and rear
  Future<void> camerachange(event, emit) async {
    final lendir = controller?.description.lensDirection;
    print("lendir $lendir");
    if (lendir == CameraLensDirection.back) {
      final camerasetup = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      controller?.setDescription(camerasetup);
      controller?.initialize();
      emit(CameraRun(controller!));
    } else if (lendir == CameraLensDirection.front) {
      final camerasetup = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      controller?.setDescription(camerasetup);
      controller?.initialize();
      emit(CameraRun(controller!));
    } else {
      final camerasetup = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      controller?.setDescription(camerasetup);
      controller?.initialize();
      emit(CameraRun(controller!));
    }
    print("Switched to ${cameras[0].lensDirection}");
  }

  // It performs On and off the flash mode
  Future<void> cameraflash(event, emit) async {
    if (controller?.value.flashMode == FlashMode.torch) {
      await controller?.setFlashMode(FlashMode.off);
      emit(CameraRun(controller!));
    } else {
      await controller?.setFlashMode(FlashMode.torch);
      emit(CameraRun(controller!));
    }
  }

  // It performs Capturing Image
  Future<void> cameracapture(event, emit) async {
    if (controller != null && controller!.value.isInitialized) {
      final imagestate = await controller!.takePicture();
      imageBytes = await imagestate.readAsBytes();
      if (controller?.value.flashMode == FlashMode.torch) {
        await controller?.setFlashMode(FlashMode.off);
      }
      final CameraCaptureResponse cameraresponse = CameraCaptureResponse(
        xfile: imagestate,
        imageData: imageBytes!,
      );
      emit(CameraCaptureData(cameraresponse));
    } else {
      print("Camera Capture Not Working");
    }
  }

  // It performs Reintiate the camera to capture new image
  Future<void> camerarecaptrue(event, emit) async {
    await controller?.initialize();
    emit(CameraRun(controller!));
  }

  // It performs Reintiate the camera to capture new image
  Future<void> confirmimage(CameraExit event, Emitter emit) async {
    // if (controller != null && controller!.value.isInitialized) {
    //   final imagestate = await controller!.takePicture();
    //   // imageBytes = await imagestate.readAsBytes();
    //   emit(CameraConfirmData(imagestate));
    // } else {
    //   print("Camera Capture Not Working");
    // }
    try {
      final imagestate = event.filePath;
      emit(CameraConfirmData(imagestate));
    } catch (error) {
      emit(CameraFailure(error.toString()));
    }
  }

  //To clean the camera Controller
  // @override
  // Future<void> close() {
  //   controller?.dispose();
  //   return super.close();
  // }
}
