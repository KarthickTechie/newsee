import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/ocrservice/page/modal/salaryslip_details.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_bloc.dart';
import 'package:newsee/feature/salary_slip/page/salary_slip_page.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IncomeExpancePage extends StatefulWidget {
  // final Map<String, dynamic>?data;
  const IncomeExpancePage({Key? key}) : super(key: key);
  @override
  State<IncomeExpancePage> createState() => _IncomeExpancePageState();
}

class _IncomeExpancePageState extends State<IncomeExpancePage> {
    final FormGroup salaryDetailsForm = AppForms.SALARY_DETAILS_FORM;

    mappingSalaryData(data) {
      // salaryDetailsForm.controls['SalaryMonth']!.value = data['salaryMonth'] ?? '';
      // salaryDetailsForm.controls['basic']!.value = data['earnings']['Basic Pay'] ?? '';
      // salaryDetailsForm.controls['hra']!.value = data['earnings']['HRA'] ?? '';
      // salaryDetailsForm.controls['otherallowance']!.value = data['earnings']['Other Allowances'] ?? '';
      // salaryDetailsForm.controls['grossPay']!.value = data['earnings']['Total Earnings'] ?? '';
      // salaryDetailsForm.controls['pfDeduction']!.value = data['deductions']['PF'] ?? '';
      // // salaryDetailsForm.controls['medicalInsurance']!.value = data['deductions'][''] ?? '';
      // salaryDetailsForm.controls['otherDeduction']!.value = data['deductions']['Other Deduction'] ?? '';
      // salaryDetailsForm.controls['totalDeduction']!.value = data['deductions']['Total Deductions'] ?? '';
      // salaryDetailsForm.controls['netPay']!.value = data['net_amount'] ?? '';

      salaryDetailsForm.patchValue(data);
    }
  

  @override
  void initState() {
    super.initState();
    AppForms.SALARY_DETAILS_FORM.reset();
    //  if (widget.data != null) {
    //   salaryDetailsForm.patchValue(widget.data!);
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income & Expense'),
        actions: [ IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalarySlipPage(
                    onDataReceived: (SalaryslipDetails? salaryData) {
                      print("Received salary data: $salaryData");
                      if (salaryData != null) {
                        Navigator.pop(context, salaryData);

                        mappingSalaryData(salaryData.toMapForm());
                      }


                    },
                  ),
                ),
              );
              
            },
          ),],
      
        automaticallyImplyLeading: false,
      ),

      body: ReactiveForm(
        formGroup: salaryDetailsForm,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controlName: 'salaryMonth',
                  label: 'Salary Month',
                  mantatory: true,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'basic',
                  label: 'Basic Salary',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'hra',
                  label: 'HRA',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'otherAllowance',
                  label: 'Other allowance',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'pfDeduction',
                  label: 'PF Deduction',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'medicalInsurance',
                  label: 'Medical Insurance',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'otherDeduction',
                  label: 'Other Deduction',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'grossPay',
                  label: 'GrossPay',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'totalDeduction',
                  label: 'Total Deduction',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 12),
                IntegerTextField(
                  controlName: 'netPay',
                  label: 'Net Pay',
                  mantatory: true,
                  // maxlength: 12,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 9, 110),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (salaryDetailsForm.valid) {
                        print('loan product form value => ${salaryDetailsForm.value}');
                         showDialog(
                        context: context,
                        builder:
                            (_) => SysmoAlert.success(
                              message:"salary details saved successfully",
                              onButtonPressed: () {
                                Navigator.pop(context);
                                goToNextTab(context: context);

                                
                              },
                            ),
                      );

                      } else {
                        salaryDetailsForm.markAllAsTouched();

                      }
                    },

                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
