import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/feature/ocrservice/page/income_expance_page.dart';
import 'package:newsee/feature/ocrservice/page/modal/salaryslip_details.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_bloc.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_event.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_state.dart';
import 'package:path/path.dart';

class SalarySlipPage extends StatefulWidget {
  final  Function(SalaryslipDetails? salaryData) onDataReceived;
  const SalarySlipPage({Key? key , required this.onDataReceived }) : super(key: key);

  @override
  SalarySlipState createState() => SalarySlipState();
}

class SalarySlipState extends State<SalarySlipPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? payslipData;
  SalaryslipDetails? salaryDetails;
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).chain(CurveTween(curve: Curves.bounceIn)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    } catch (error) {
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
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      String text = recognizedText.text;

      Map<String, dynamic> data = {};
      Map<String, String> earnings = {};
      Map<String, String> deductions = {};
      List<double> amounts = [];

      var monthMatch = RegExp(
        r'Pay Slip for the Month of ([\w]+ \d{4})',
      ).firstMatch(text);
      if (monthMatch != null) {
        data['salary_month'] = monthMatch.group(1);
      }

      String currencyPattern = r'(?:₹|Rs\.?|Rs|INR)?\s*';
      var amountMatches = RegExp(
        r'(?:₹|Rs\.?|Rs|INR)?\s*([\d,]+\.\d{2})',
      ).allMatches(text);
      for (var match in amountMatches) {
        String cleanAmountStr = match.group(1)!.replaceAll(',', '');
        if (cleanAmountStr.startsWith('7')) {
          cleanAmountStr = cleanAmountStr.replaceFirst('7', '');
        }
        double amount =
            cleanAmountStr.isNotEmpty ? double.parse(cleanAmountStr) : 0.0;
        amounts.add(amount);
      }

      amounts = amounts.toSet().toList();
      amounts.sort((a, b) => b.compareTo(a));

      final NumberFormat inrFormat = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 2,
      );
      List<String> formattedAmounts =
          amounts.map((amount) => inrFormat.format(amount)).toList();

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
        earnings['OtherAllowances'] = inrFormat.format(otherAllowances);
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
        deductions['OtherDeduction'] = inrFormat.format(otherDeduction);
      } else {
        deductions['OtherDeduction'] = inrFormat.format(totDeductions);
      }

      deductions['Net Amount'] = inrFormat.format(amounts[1]);
      data['earnings'] = earnings;
      data['deductions'] = deductions;

      print("final payslip => $data");

      setState(() {
        salaryDetails = SalaryslipDetails.salaryMap(data);
        print("salary details full map details => $salaryDetails");
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
    // return BlocConsumer<PayslipBloc,PayslipState>(
      // listener: (context, state) {
      //   if(state.saveStatus == SaveStatus.success){
      //     payslipData = state.payslipData;
      //     Navigator.pop(context);

      //   }
      // },
      return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Upload your payslip as a PDF, or scan a physical document to extract salary data.',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              print('Upload PDF tapped');
                            },
                            borderRadius: BorderRadius.circular(12.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Upload PDF',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Supports PDF',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              captureAndExtractPayslipData();
                            },
                            borderRadius: BorderRadius.circular(12.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Scan Document',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Use your camera',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  if (payslipData != null) ...[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.blueAccent, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.description, size: 24, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  'payslip_${payslipData!['salary_month']?.toLowerCase().replaceAll(' ', '_') ?? 'jan_2024'}.pdf',
                                  style: TextStyle(fontSize: 16.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Icon(Icons.check_circle, color: Colors.green, size: 24),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Extraction Complete!',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payslip for: ${payslipData!['salary_month'] ?? 'Unknown'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'EARNINGS',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        'DEDUCTIONS',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashGapLength: 2.0,
                                    dashColor: Colors.grey,
                                  ),
                                  const SizedBox(height: 8.0),
                                  _buildItemRow(
                                    'Basic Pay:',
                                    payslipData!['earnings']['Basic Pay'] ?? '₹0.00',
                                    'PF:',
                                    payslipData!['deductions']['PF'] ?? '₹0.00',
                                  ),
                                  _buildItemRow(
                                    'HRA:',
                                    payslipData!['earnings']['HRA'] ?? '₹0.00',
                                    'Insurance:',
                                    payslipData!['deductions']['Insurance'] ??
                                        '₹0.00',
                                  ),
                                  _buildItemRow(
                                    'Allowances:',
                                    payslipData!['earnings']['OtherAllowances'] ??
                                        '₹0.00',
                                    'Deductions:',
                                    payslipData!['deductions']['Other Deduction'] ??
                                        '₹0.00',
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Divider(color: Colors.grey),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Gross pay:'),
                                      SizedBox(width: 20),
                                      Flexible(
                                        child: Text(
                                          payslipData!['earnings']['Total Earnings'] ??
                                              '₹0.00',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('TOTAL DEDUCTION:'),
                                      SizedBox(width: 20),
                                      Flexible(
                                        child: Text(
                                          payslipData!['deductions']['Total Deductions'] ??
                                              '₹0.00',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  GestureDetector(
                                    onTap: (){
                                      print('go to income and expense page $payslipData');
                                      widget.onDataReceived(salaryDetails);
                                      // context.read<PayslipBloc>().add(LoadPayslipEvent(payslipdata: payslipData!));
                                    },
                                    
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 16.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'NET AMOUNT: ${payslipData!['deductions']['Net Amount'] ?? '₹0.00'}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Icon(Icons.check_circle, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      );
    
  }

  Widget _buildItemRow(
    String earningsLabel,
    String earningsAmount,
    String deductionsLabel,
    String deductionsAmount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(earningsLabel),
                Flexible(
                  child: Text(
                    earningsAmount,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deductionsLabel),
                Flexible(
                  child: Text(
                    deductionsAmount,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
