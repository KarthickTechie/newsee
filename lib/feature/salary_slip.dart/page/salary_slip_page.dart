import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SalarySlipPage extends StatefulWidget {
  const SalarySlipPage({Key? key}) : super(key: key);

  @override
  SalarySlipState createState() => SalarySlipState();
}

class SalarySlipState extends State<SalarySlipPage> {
  Map<String, dynamic>? payslipData;
  String errorMessage = '';

  List<double> findSumCombination(List<double> numbers, double target) {
    for (int i = 1; i < (1 << numbers.length); i++) {
      double sum = 0;
      List<double> combination = [];
      for (int j = 0; j < numbers.length; j++) {
        if (i & (1 << j) != 0) {
          sum += numbers[j];
          combination.add(numbers[j]);
        }
      }
      if ((sum - target).abs() < 0.01) {
        return combination;
      }
    }
    return [];
  }

  Future<double> setBaicValue(basic, grosspay) async {
    try {
      if (basic != -1) {
        return basic;
      } else {
        final getBasicAmount = (grosspay * 0.5);
        return getBasicAmount;
      }
    } catch(error) {
      final baiscpay = 0.00;
      return baiscpay; 
    }
  }

  Future<void> captureAndExtractPayslipData() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) {
        throw Exception('No image captured');
      }
      final String imagePath = image.path;

      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      String text = recognizedText.text;

      Map<String, dynamic> data = {};
      Map<String, String> earnings = {};
      Map<String, String> deductions = {};
      List<double> amounts = [];

      var monthMatch = RegExp(r'Pay Slip for the Month of ([\w]+ \d{4})').firstMatch(text);
      if (monthMatch != null) {
        data['salary_month'] = monthMatch.group(1);
      }

      String currencyPattern = r'(?:₹|Rs\.?|Rs|INR)?\s*';
      var amountMatches = RegExp(r'(?:₹|Rs\.?|Rs|INR)?\s*([\d,]+\.\d{2})').allMatches(text);
      for (var match in amountMatches) {
        String cleanAmountStr = match.group(1)!.replaceAll(',', '');
        if (cleanAmountStr.startsWith('7')) {
          cleanAmountStr = cleanAmountStr.replaceFirst('7', '');
        }
        double amount = cleanAmountStr.isNotEmpty ? double.parse(cleanAmountStr) : 0.0;
        amounts.add(amount);
      }

      // Remove duplicates from amounts
      amounts = amounts.toSet().toList();

      amounts.sort((a, b) => b.compareTo(a));

      final NumberFormat inrFormat = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 2,
      );
      List<String> formattedAmounts = amounts.map((amount) => inrFormat.format(amount)).toList();

      final grossPay = amounts[0];
      earnings['Total Earnings'] = inrFormat.format(grossPay);

      final netPay = amounts[1];
      data['net_amount'] = inrFormat.format(netPay);

      final basicmatch = amounts.firstWhere(
        (val) => val >= (grossPay * 0.4) && val <= (grossPay * 0.6),
        orElse: () => -1,
      );

      final getBasicAmount = await setBaicValue(basicmatch, grossPay);

      earnings['Basic Pay'] = inrFormat.format(getBasicAmount);
 
      final hramatch = amounts.firstWhere(
        (val) => val >= (getBasicAmount * 0.5) && val <= (getBasicAmount * 0.8),
        orElse: () => -1,
      );

      if (hramatch != -1) {
        earnings['HRA'] = inrFormat.format(hramatch);
      }

      final otherAllowances = grossPay - getBasicAmount - hramatch;
      if (otherAllowances > 0) {
        earnings['Other Allowances'] = inrFormat.format(otherAllowances);
      }

      final totDeductions = grossPay - netPay;
      if (totDeductions > 0) {
        deductions['Total Deductions'] = inrFormat.format(totDeductions);
      }

      final double pfDeduct = 1800.0;
      final pfDeduction = amounts.firstWhere(
        (val) => val == pfDeduct,
        orElse: () => -1,
      );

      if (pfDeduction > 0) {
        deductions['PF'] = inrFormat.format(1800.00);
        final otherDeduction = totDeductions - 1800.00;
        deductions['Insurance'] = inrFormat.format(0.00);
        deductions['Other Deduction'] = inrFormat.format(otherDeduction);
      } else {
        deductions['Other Deduction'] = inrFormat.format(totDeductions);
      }

      deductions['Net Amount'] = inrFormat.format(amounts[1]);

      // deductions['PF'] = inrFormat.format(1800.00);

      // final otherDeduction = totDeductions - 1800.00;

      // List<double> sumOfDeduction = findSumCombination(amounts, totDeductions);

      // print("exists $sumOfDeduction");

      // double otherDeduction = 0;
      // for (int k = 0; k < sumOfDeduction.length; k++) {
      //   if (sumOfDeduction[k] == 1800.00) {
      //     deductions['PF'] = inrFormat.format(sumOfDeduction[k]);
      //   } else {
      //     otherDeduction = otherDeduction + sumOfDeduction[k];
      //   }
      // }

      

      data['earnings'] = earnings;
      data['deductions'] = deductions;

      print("final payslip => $data");

      setState(() {
        payslipData = data;
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error processing payslip: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payslip Extractor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: captureAndExtractPayslipData,
              child: const Text('Capture Payslip Photo'),
            ),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (payslipData != null) ...[
              Text(
                'Payslip for: ${payslipData!['salary_month'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: const [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  ..._buildTableRows(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    final earnings = payslipData!['earnings'] as Map<String, String>;
    final deductions = payslipData!['deductions'] as Map<String, String>;

    List<String> earningsFields = [
      'Basic Pay',
      'HRA',
      'Other Allowances',
      'Total Earnings',
    ];
    List<String> deductionsFields = [
      'PF',
      'Insurance',
      'Other Deduction',
      'Total Deductions',
      'Net Amount',
    ];

    List<TableRow> rows = [];
    int maxRows = earningsFields.length > deductionsFields.length ? earningsFields.length : deductionsFields.length;

    for (int i = 0; i < maxRows; i++) {
      String earningLabel = i < earningsFields.length ? earningsFields[i] : '';
      String earningValue = i < earningsFields.length ? earnings[earningsFields[i]] ?? '0.00' : '';
      String deductionLabel = i < deductionsFields.length ? deductionsFields[i] : '';
      String deductionValue = i < deductionsFields.length ? deductions[deductionsFields[i]] ?? '0.00' : '';

      // Apply light grey background only to the Net Amount value cell
      Widget valueWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          deductionValue,
          textAlign: TextAlign.right,
        ),
      );

      if (deductionLabel == 'Net Amount') {
        valueWidget = Container(
          color: Colors.grey, // Light grey background for Net Amount cell
          padding: const EdgeInsets.all(8.0),
          child: Text(
            deductionValue,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        );
      }

      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(earningLabel),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  earningValue,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(deductionLabel),
              ),
            ),
            TableCell(
              child: valueWidget,
            ),
          ],
        ),
      );
    }

    return rows;
  }
}