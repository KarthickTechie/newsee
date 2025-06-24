import 'package:camera/camera.dart';
import 'package:newsee/blocs/camera/camera_repository.dart';

class CameraState {}

class CameraIntialize extends CameraState {}

class CameraRun extends CameraState {
  final CameraController controller;
  CameraRun(this.controller);
}

class CameraFailure extends CameraState {
  final String errormsg;
  CameraFailure(this.errormsg);
}

class CameraCaptureData extends CameraState {
  // final Uint8List imagedata;
  // CameraCaptureData(this.imagedata);
  final CameraCaptureResponse captureresponse;
  CameraCaptureData(this.captureresponse);
}

class CameraConfirmData extends CameraState {
  final XFile xfiledata;
  CameraConfirmData(this.xfiledata);
}
