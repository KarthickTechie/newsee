import 'package:flutter/foundation.dart'; // Add this import
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerFromBytes extends StatefulWidget {
  final FilePickerResult? filedata; // pass the picked bytes here
  const PDFViewerFromBytes({super.key, required this.filedata});

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
      appBar: AppBar(title: const Text('PDF Viewer')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pdfController == null
              ? const Center(child: Text('Failed to load PDF'))
              : PdfViewPinch(controller: _pdfController!),
    );
  }
}
