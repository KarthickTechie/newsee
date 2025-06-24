import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IncomeDetailsPage extends StatelessWidget {
  final String title;

  IncomeDetailsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'occupation': FormControl<String>(validators: [Validators.required]),
    'grossincome': FormControl<String>(validators: [Validators.required]),
    'grossmonthly': FormControl<String>(validators: [Validators.required]),
    'netincome': FormControl<String>(validators: [Validators.required]),
    'networth': FormControl<String>(validators: [Validators.required]),
    'company': FormControl<String>(validators: [Validators.required]),
    'totalyears': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Income Details")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'occupation',
                  label: 'Occupation',
                  items: [
                    'Agriculturalist',
                    'Business',
                    'Chartered Accountant',
                    'Ex Servicemen',
                    'Others',
                    'Pensioner',
                    'Prof/Self Employed',
                    'Salaried',
                  ],
                ),
                IntegerTextField(
                  controlName: 'grossincome',
                  label: 'Gross Income/Salary(₹) (Per Month)',
                  mantatory: true,
                ),
                IntegerTextField(
                  controlName: 'grossmonthly',
                  label: 'Gross Monthly Deductions(₹) (Per Month)',
                  mantatory: true,
                ),
                IntegerTextField(
                  controlName: 'netincome',
                  label: 'Net Income(₹) (Per Year)',
                  mantatory: true,
                ),
                IntegerTextField(
                  controlName: 'networth',
                  label: 'Networth of the Applicant(₹)',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'company',
                  label: 'Company',
                  mantatory: true,
                ),
                IntegerTextField(
                  controlName: 'totalyears',
                  label: 'Total Years of Employment',
                  mantatory: true,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (form.valid) {
                        final tabController = DefaultTabController.of(context);
                        if (tabController.index < tabController.length - 1) {
                          tabController.animateTo(tabController.index + 1);
                        }
                      } else {
                        form.markAllAsTouched();
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
