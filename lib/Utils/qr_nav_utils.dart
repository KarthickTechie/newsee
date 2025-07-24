import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        height: 180,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text('QR Scanner'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                _navigateToQRScanner(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('OCR'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
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
