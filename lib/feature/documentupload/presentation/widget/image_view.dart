import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';

class ImageView extends StatefulWidget {
  final Uint8List imageBytes;
  final int docIndex;
  final bool isUploaded;

  const ImageView({
    super.key,
    required this.imageBytes,
    required this.docIndex,
    required this.isUploaded,
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

    // context.read<DocumentBloc>().add(
    //   UploadDocumentByBytesEvent(
    //     context: context,
    //     docIndex: widget.docIndex,
    //     imageBytes: _imageBytes,
    //   ),
    // );
    context.pop(_imageBytes);

    final updatedState = await context.read<DocumentBloc>().stream.firstWhere(
      (state) => state.fetchStatus != SubmitStatus.loading,
    );

    setState(() {
      _isUploading = false;
      _isUploaded = true;
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Image uploaded successfully.")),
    // );
  }

  Future<void> _deleteImage() async {
    setState(() => _isUploading = true);

    context.read<DocumentBloc>().add(
      DeleteDocumentImageEvent(docIndex: widget.docIndex),
    );

    final updatedState = await context.read<DocumentBloc>().stream.firstWhere(
      (state) => state.fetchStatus != SubmitStatus.loading,
    );

    setState(() {
      _isUploading = false;
      _isUploaded = false;
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Image deleted successfully.")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("View Image")),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.memory(_imageBytes, fit: BoxFit.contain),
          ),

          if (_isUploading) const Center(child: CircularProgressIndicator()),

          // Show Delete if uploaded
          if (_isUploaded && !_isUploading)
            Positioned(
              bottom: 30,
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
              bottom: 30,
              left: screenWidth * 0.1,
              child: ElevatedButton.icon(
                onPressed: _captureImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture"),
              ),
            ),

          if (!_isUploaded && !_isUploading)
            Positioned(
              bottom: 30,
              left: screenWidth * 0.5,
              child: ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload"),
              ),
            ),

          // Always show close
          if (!_isUploading)
            Positioned(
              bottom: 30,
              left: screenWidth * 0.8,
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
