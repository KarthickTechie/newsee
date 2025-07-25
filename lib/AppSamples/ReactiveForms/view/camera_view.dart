import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/blocs/camera/camera_bloc.dart';
import 'package:newsee/blocs/camera/camera_event.dart';
import 'package:newsee/blocs/camera/camera_state.dart';

class CameraView extends StatelessWidget {
  final mediaService = MediaService();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return BlocConsumer<CameraBloc, CameraState>(
      listener: (context, state) async {
        try {
          String? imagePath;
          Uint8List? originalBytes;

          if (state is CameraConfirmData) {
            imagePath = state.xfiledata.path;
            originalBytes = await state.xfiledata.readAsBytes();
          } else if (state is CameraCaptureData) {
            imagePath = state.captureresponse.xfile.path;
            originalBytes = state.captureresponse.imageData;
          }
          if (imagePath != null) {
            final cropdata = await mediaService.cropper(context, imagePath);

            if (cropdata != null && context.mounted) {
              context.pop(cropdata);
            }
            // If crop canceled
            else if (context.mounted) {
              context.pop(originalBytes);
            }
          }
        } catch (e) {
          print('Crop Error: $e');
        }
      },
      builder: (context, state) {
        if (state is CameraIntialize) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CameraRun) {
          // added safeArea widget for cropper ui issues
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  padding:
                      kIsWeb
                          ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                          : EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Center(
                    child: CameraPreview(
                      state.controller,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Ink(
                                      decoration: ShapeDecoration(
                                        color: Colors.lightBlue,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          (state.controller.value.flashMode ==
                                                  FlashMode.torch)
                                              ? Icons.flash_on
                                              : Icons.flash_off,
                                        ),
                                        onPressed:
                                            () => {
                                              context.read<CameraBloc>().add(
                                                FlashModeChange(),
                                              ),
                                            },
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Ink(
                                      decoration: ShapeDecoration(
                                        color: Colors.lightBlue,
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.camera),
                                        onPressed:
                                            () => {
                                              context.read<CameraBloc>().add(
                                                CaptureImage(),
                                              ),
                                            },
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                kIsWeb
                                    ? const SizedBox.shrink()
                                    : Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Ink(
                                          decoration: ShapeDecoration(
                                            color: Colors.lightBlue,
                                            shape: CircleBorder(),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              (state
                                                          .controller
                                                          .description
                                                          .lensDirection ==
                                                      CameraLensDirection.front)
                                                  ? Icons.camera_front
                                                  : Icons.camera_rear,
                                            ),
                                            onPressed:
                                                () => {
                                                  context
                                                      .read<CameraBloc>()
                                                      .add(CameraLensChange()),
                                                },
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        //  else if (state is CameraCaptureData) {
        //   return Stack(
        //     children: [
        //       SizedBox.expand(
        //         child: Image.memory(
        //           state.captureresponse.imageData,
        //           width: double.infinity,
        //           height: double.infinity,
        //         ),
        //       ),
        //       Positioned(
        //         top: (screenheight * 0.8),
        //         left: (screenwidth * 0.1),
        //         child: Center(
        //           child: ElevatedButton.icon(
        //             icon: const Icon(Icons.camera),
        //             onPressed:
        //                 () => {
        //                   context.read<CameraBloc>().add(CameraReCapture()),
        //                 },
        //             label: Text("Capture"),
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         top: (screenheight * 0.8),
        //         left: (screenwidth * 0.5),
        //         child: Center(
        //           child: ElevatedButton.icon(
        //             icon: const Icon(Icons.check),
        //             onPressed:
        //                 () => {
        //                   print('Camera Data: ${state.captureresponse.xfile}'),
        //                   context.read<CameraBloc>().add(
        //                     CameraExit(state.captureresponse.xfile),
        //                   ),
        //                 },
        //             label: Text("Ok"),
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         top: (screenheight * 0.8),
        //         left: (screenwidth * 0.8),
        //         child: ElevatedButton(
        //           onPressed: () {
        //             print(
        //               ' Uploading image: ${state.captureresponse.imageData}',
        //             );
        //             // context.read<DocumentBloc>().add(UploadDocumentsEvent());
        //             context.pop();
        //           },
        //           child: const Icon(Icons.upload),
        //         ),
        //       ),
        //     ],
        //   );
        // }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
