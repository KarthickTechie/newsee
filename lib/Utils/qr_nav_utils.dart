import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppSamples/LivelinessApp/liveliness_app.dart';
import 'package:newsee/feature/ocr/presentation/page/ocr_page.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/feature/qrscanner/presentation/page/qr_scanner_page.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:xml2json/xml2json.dart';

void showScannerOptions(BuildContext context) {
  BuildContext ctx = context;
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bottomSheetContext) {
      return Container(
        padding: EdgeInsets.all(16),
        height: 300,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text('QR Scanner'),
              onTap: () {
                Navigator.pop(bottomSheetContext); // Close bottom sheet
                _navigateToQRScanner(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('OCR'),
              onTap: () {
                Navigator.pop(bottomSheetContext); // Close bottom sheet
                _navigateToOCRScanner(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.face_5),
              title: Text('LivelinessCheck'),
              onTap: () {
                Navigator.pop(bottomSheetContext); // Close bottom sheet
                _navigateToLivelinessCheck(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

// Navigate to QR Scanner page
void _navigateToQRScanner(BuildContext context) {
  BuildContext ctx = context;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => QRScannerPage(
            onQRScanned: (result) {
              _showResultDialog(
                ctx,
                result,
                'QR',
              ); // Show result in AlertDialog
            },
          ),
    ),
  );
}

// route to OCR page

void _navigateToOCRScanner(BuildContext context) {
  BuildContext ctx = context;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => OCRScannerPage(
            onTextDetected: (result) {
              print('OCR Result => $result');
              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('OCR Scan Result'),
                    content: Text(result),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // ctx.read<PersonalDetailsBloc>().add(
                          //   ScannerResponseEvent(
                          //     scannerResponse: {'aadhaarResponse': result},
                          //   ),
                          // );
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
    ),
  );
}

void _navigateToLivelinessCheck(BuildContext ctx) async {
  final cameras = await availableCameras();
  Navigator.push(
    ctx,
    MaterialPageRoute(builder: (routeCtx) => LivelinessApp(cameras: cameras)),
  );
}

// Show AlertDialog with QR scan result
void _showResultDialog(BuildContext context, String result, String source) {
  try {
    BuildContext ctx = context;

    Navigator.pop(context);
    final xml2json = Xml2Json();
    xml2json.parse(result);
    final jsonString = xml2json.toBadgerfish();
    final jsonObject = jsonDecode(jsonString);
    final aadharResp =
        jsonObject['PrintLetterBarcodeData'] as Map<String, dynamic>;
    aadharResp.entries.forEach((v) => print(v));
    final aadhaarId = aadharResp['@uid'];
    print("jsonObject => $aadhaarId");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Scan Result'),
          content: Text(aadhaarId),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ctx.read<PersonalDetailsBloc>().add(
                  ScannerResponseEvent(
                    scannerResponse: {'aadhaarResponse': aadharResp},
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showDialog(
      context: context,
      builder:
          (_) => SysmoAlert.failure(
            message: 'Error : $e',
            onButtonPressed: () => Navigator.pop(context),
          ),
    );
  }
}
