import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/blocs/camera/camera_bloc.dart';
import 'package:newsee/blocs/camera/camera_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';

class ImageView extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageView({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox.expand(
          child: Image.memory(
            imageBytes,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: (screenheight * 0.8),
          left: (screenwidth * 0.1),
          child: ElevatedButton(
            onPressed: () async {
              // context.read<CameraBloc>().add(CameraReCapture());
              // context.pop();
              final res = await context.pushNamed("camera");
              if (res != null && context.mounted) {
                context.pop(res);
              }
              // pop back to camera view
            },
            child: const Icon(Icons.camera),
          ),
        ),
        Positioned(
          top: (screenheight * 0.8),
          left: (screenwidth * 0.3),
          child: ElevatedButton(
            onPressed: () {
              print('Cropped image confirmed: $imageBytes');
              context.pop(imageBytes); //  return result
              // context.read<CameraBloc>().add(CroppExit(imagePath));
            },
            child: const Icon(Icons.check),
          ),
        ),
        Positioned(
          top: (screenheight * 0.8),
          left: (screenwidth * 0.5),
          child: ElevatedButton(
            onPressed: () {
              print(' Uploading image: $imageBytes');
              context.read<DocumentBloc>().add(
                UploadDocumentsEvent(
                  context: context,
                  docIndex: 0,
                  imgIndex: [],
                ),
              );
              context.pop();
            },
            child: const Icon(Icons.upload),
          ),
        ),
        Positioned(
          top: (screenheight * 0.8),
          left: (screenwidth * 0.7),
          child: ElevatedButton(
            onPressed: () {
              context.pop('close'); // Just go back without returning any image
            },
            child: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
