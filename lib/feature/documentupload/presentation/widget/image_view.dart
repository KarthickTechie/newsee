import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/widgets/confirmation_delete_alert.dart';

class ImageView extends StatefulWidget {
  final Uint8List imageBytes;
  final int docIndex;
  final bool isUploaded;
  final int? imgIndex;

  const ImageView({
    super.key,
    required this.imageBytes,
    required this.docIndex,
    required this.isUploaded,
    this.imgIndex,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late Uint8List _imageBytes;
  bool _isUploaded = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.imageBytes;
    _isUploaded = widget.isUploaded;
  }

  Future<void> _captureImage() async {
    final res = await context.pushNamed("camera");
    if (!mounted || res == null || res is! Uint8List) return;

    setState(() {
      _imageBytes = res;
      _isUploaded = false;
    });
  }

  Future<void> _uploadImage() async {
    setState(() => _isUploading = true);

    context.pop(_imageBytes);

    final updatedState = await context.read<DocumentBloc>().stream.firstWhere(
      (state) => state.fetchStatus != SubmitStatus.loading,
    );

    setState(() {
      _isUploading = false;
      _isUploaded = true;
    });
  }

  Future<void> _deleteImage() async {
    final confirmed = await confirmAndDeleteImage(context);
    if (confirmed == true) {
      setState(() => _isUploading = true);

      context.read<DocumentBloc>().add(
        DeleteDocumentImageEvent(
          docIndex: widget.docIndex,
          imgIndex: widget.imgIndex,
        ),
      );

      context.pop();

      setState(() {
        _isUploading = false;
        _isUploaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("View Image")),
      body: Stack(
        children: [
          /* @modifiedBy    :  Lathamani   10/07/2025
     @desc          :  added padding all sided on image 
  */
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox.expand(
              child: Image.memory(_imageBytes, fit: BoxFit.contain),
            ),
          ),
          if (_isUploading) const Center(child: CircularProgressIndicator()),

          // Show Delete if uploaded
          if (_isUploaded && !_isUploading)
            Positioned(
              bottom: 60,
              left: screenWidth * 0.1,
              child: ElevatedButton.icon(
                onPressed: _deleteImage,
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
              ),
            ),

          // Show Upload and Capture if NOT uploaded
          if (!_isUploaded && !_isUploading)
            Positioned(
              bottom: 60,
              left: screenWidth * 0.0,
              child: ElevatedButton.icon(
                onPressed: _captureImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture"),
              ),
            ),

          if (!_isUploaded && !_isUploading)
            Positioned(
              bottom: 60,
              left: screenWidth * 0.4,
              child: ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload"),
              ),
            ),

          // Always show close
          if (!_isUploading)
            Positioned(
              bottom: 60,
              left: screenWidth * 0.7,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close),
                label: const Text("Close"),
              ),
            ),
        ],
      ),
    );
  }
}
