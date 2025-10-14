import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdfx/pdfx.dart';

class BalanceSheetParser extends StatefulWidget {
  const BalanceSheetParser({super.key});

  @override
  State<BalanceSheetParser> createState() => _BalanceSheetParserState();
}

class _BalanceSheetParserState extends State<BalanceSheetParser> {
  List<Map<String, String>> _extracted = [];
  String _error = '';
  String _year1 = '2022';
  String _year2 = '2021';

  Future<void> _pickAndParse() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    String? path = result?.files.single.path;
    if (path != null) {
      try {
        String allText = await _extractTextWithOcr(path);
        List<Map<String, String>> parsed = _parseBalanceSheet(allText);
        setState(() {
          _extracted = parsed;
          _error = '';
        });
      } catch (e) {
        setState(() {
          _error = 'Error parsing PDF: $e';
          _extracted = [];
        });
      }
    }
  }

  Future<String> _extractTextWithOcr(String pdfPath) async {
    String allText = '';
    final document = await PdfDocument.openFile(pdfPath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      for (int i = 1; i <= document.pagesCount; i++) {
        final page = await document.getPage(i);

        // Render page to PNG image bytes (use double resolution for better OCR accuracy)

        final pageImage = await page.render(
          width: page.width,
          height: page.height,
          format: PdfPageImageFormat.png,
          backgroundColor: '#FFFFFF',
        );
        // final inputImage = InputImage.fromBitmap(
        //   bitmap: pageImage!.bytes,
        //   width: pageImage.width!,
        //   height: pageImage.height!,
        // );

        // // Create InputImage from bytes for ML Kit
        final inputImage = InputImage.fromBytes(
          bytes: Uint8List.fromList(pageImage!.bytes),
          metadata: InputImageMetadata(
            size: Size(
              pageImage.width!.toDouble(),
              pageImage.height!.toDouble(),
            ),
            rotation: InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: pageImage.width!, // Assuming RGBA for PNG
          ),
        );

        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );
        allText += recognizedText.text + '\n\n--- Page $i ---\n\n';

        // Clean up
        await page.close();
      }
    } finally {
      await document.close();
      textRecognizer.close();
    }

    return allText;
  }

  List<Map<String, String>> _parseBalanceSheet(String text) {
    List<Map<String, String>> extracted = [];
    List<String> lines = text.split('\n');
    String currentSection = '';
    RegExp numberPattern = RegExp(r'^\s*[\d,]+\.?\d*\s*$');
    String year1 = '2022';
    String year2 = '2021';

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty ||
          line.contains('--- Page') ||
          line.startsWith('H i g h') ||
          line.contains('For and on Behalf'))
        continue; // Skip noise

      // Detect years from header (adjust for OCR variations)
      if (line.contains('Particulars') &&
          line.contains('Note No.') &&
          (line.contains('March 31') || line.contains('March'))) {
        // Extract years from line parts
        RegExp yearRegex = RegExp(r'March 31,\s*(\d{4})');
        var matches = yearRegex.allMatches(line);
        if (matches.length >= 2) {
          year1 = matches.elementAt(0).group(1)!;
          year2 = matches.elementAt(1).group(1)!;
        }
        continue;
      }

      // Detect main sections (case-insensitive for OCR)
      if (line.toUpperCase().contains('ASSETS')) {
        extracted.add({'particular': 'ASSETS', year1: '', year2: ''});
        currentSection = 'Assets';
        continue;
      } else if (line.toUpperCase().contains('NON-CURRENT ASSETS') ||
          line.toUpperCase().contains('NON CURRENT ASSETS')) {
        extracted.add({
          'particular': 'Non-current Assets',
          year1: '',
          year2: '',
        });
        currentSection = 'Non-current Assets';
        continue;
      } else if (line.toUpperCase().contains('CURRENT ASSETS')) {
        extracted.add({'particular': 'Current Assets', year1: '', year2: ''});
        currentSection = 'Current Assets';
        continue;
      } else if (line.toUpperCase().contains('EQUITY AND LIABILITIES')) {
        extracted.add({
          'particular': 'EQUITY AND LIABILITIES',
          year1: '',
          year2: '',
        });
        currentSection = 'Equity and Liabilities';
        continue;
      } else if (line.toUpperCase().contains('EQUITY')) {
        extracted.add({'particular': 'EQUITY', year1: '', year2: ''});
        currentSection = 'Equity';
        continue;
      } else if (line.toUpperCase().contains('LIABILITIES')) {
        extracted.add({'particular': 'LIABILITIES', year1: '', year2: ''});
        currentSection = 'Liabilities';
        continue;
      } else if (line.toUpperCase().contains('NON-CURRENT LIABILITIES') ||
          line.toUpperCase().contains('NON CURRENT LIABILITIES')) {
        extracted.add({
          'particular': 'Non-Current Liabilities',
          year1: '',
          year2: '',
        });
        currentSection = 'Non-Current Liabilities';
        continue;
      } else if (line.toUpperCase().contains('CURRENT LIABILITIES')) {
        extracted.add({
          'particular': 'Current Liabilities',
          year1: '',
          year2: '',
        });
        currentSection = 'Current Liabilities';
        continue;
      }

      // Parse item lines (handle sub-items like a), b), and totals)
      if (line.startsWith(RegExp(r'[a-g])'))) {
        // Sub-items
        var parts = line.split(RegExp(r'\s{2,}'));
        if (parts.length >= 4) {
          String particular = parts.sublist(0, parts.length - 3).join(' ');
          String note = parts[parts.length - 3].trim();
          String val1 = parts[parts.length - 2].trim();
          String val2 = parts[parts.length - 1].trim();
          if (numberPattern.hasMatch(val1) && numberPattern.hasMatch(val2)) {
            particular = '$particular (Note $note)';
            extracted.add({
              'particular': particular,
              year1: val1.replaceAll(',', ''),
              year2: val2.replaceAll(',', ''),
            });
          }
        }
      } else if (numberPattern.hasMatch(line.split(RegExp(r'\s{2,}')).last)) {
        // Total lines
        var parts = line.split(RegExp(r'\s{2,}'));
        if (parts.length >= 2 &&
            numberPattern.hasMatch(parts[parts.length - 2]) &&
            numberPattern.hasMatch(parts.last)) {
          String particular = parts.sublist(0, parts.length - 2).join(' ');
          if (particular.toUpperCase().contains('TOTAL ASSETS') ||
              particular.toUpperCase().contains('TOTAL EQUITY')) {
            extracted.add({
              'particular': particular.toUpperCase(),
              year1: parts[parts.length - 2].replaceAll(',', ''),
              year2: parts.last.replaceAll(',', ''),
            });
          } else {
            extracted.add({
              'particular': particular,
              year1: parts[parts.length - 2].replaceAll(',', ''),
              year2: parts.last.replaceAll(',', ''),
            });
          }
        }
      }
    }

    // Update years if detected
    _year1 = year1;
    _year2 = year2;

    return extracted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Balance Sheet Parser')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickAndParse,
              child: const Text('Upload Balance Sheet PDF'),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_error, style: const TextStyle(color: Colors.red)),
              ),
            if (_extracted.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Particular'), numeric: false),
                    DataColumn(
                      label: Text('March 31, $_year1 (₹ Cr)'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('March 31, $_year2 (₹ Cr)'),
                      numeric: true,
                    ),
                  ],
                  rows:
                      _extracted.map((item) {
                        bool isHeader = (item[_year1] ?? '').isEmpty;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                item['particular'] ?? '',
                                style:
                                    isHeader
                                        ? const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        )
                                        : null,
                              ),
                            ),
                            DataCell(Text(item[_year1] ?? '')),
                            DataCell(Text(item[_year2] ?? '')),
                          ],
                        );
                      }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
