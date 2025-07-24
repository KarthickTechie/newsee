import 'package:flutter/foundation.dart'; // Add this import
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerFromBytes extends StatefulWidget {
  final FilePickerResult? filedata;
  final String? filePath; // pass the picked bytes here
  const PDFViewerFromBytes({super.key, this.filedata, this.filePath});

  @override
  PDFViewerFromBytesState createState() => PDFViewerFromBytesState();
}

class PDFViewerFromBytesState extends State<PDFViewerFromBytes> {
  late PdfControllerPinch? _pdfController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (widget.filePath == null) {
        if (kIsWeb) {
          print("passing for web here");
          final Uint8List? pdfpath = widget.filedata?.files.single.bytes;
          print("pdfpath is print for web $pdfpath");
          final document = PdfDocument.openData(pdfpath!);
          setState(() {
            _pdfController = PdfControllerPinch(document: document);
            _isLoading = false; // PDF loaded, update loading state
          });
        } else {
          final pdfpath = widget.filedata?.files.single.path;
          if (pdfpath != null) {
            print("pdfpath is print for android $pdfpath");
            final document = PdfDocument.openFile(pdfpath);
            setState(() {
              _pdfController = PdfControllerPinch(document: document);
              _isLoading = false; // PDF loaded, update loading state
            });
          }
        }
      } else {
        if (widget.filePath != null) {
          final document = PdfDocument.openFile(widget.filePath!);
          setState(() {
            _pdfController = PdfControllerPinch(document: document);
            _isLoading = false; // PDF loaded, update loading state
          });
        }
      }

      print("_pdfController: $_pdfController");
    } catch (e) {
      print("Error loading PDF: $e");
      setState(() {
        _isLoading = false; // Handle error, stop loading
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions:
            widget.filePath == null
                ? [
                  IconButton(
                    icon: const Icon(Icons.upload_file),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ]
                : [],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pdfController == null
              ? const Center(child: Text('Failed to load PDF'))
              : PdfViewPinch(controller: _pdfController!),
    );
  }
}
