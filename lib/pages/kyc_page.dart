import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class KycPage extends StatelessWidget {
  final String title;

  KycPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'applicanttype': FormControl<String>(validators: [Validators.required]),
    'panno': FormControl<String>(validators: [Validators.required]),
    'aadhaarno': FormControl<String>(validators: [Validators.required]),
    'otheridproof': FormControl<String>(validators: [Validators.required]),
    'otheridno': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KYC")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'applicanttype',
                  label: 'Applicant Type',
                  items: ['', ''],
                ),
                CustomTextField(
                  controlName: 'panno',
                  label: 'PAN No',
                  mantatory: true,
                ),
                IntegerTextField(
                  controlName: 'aadhaarno',
                  label: 'Aadhaar No',
                  mantatory: true,
                ),
                Dropdown(
                  controlName: 'otheridproof',
                  label: 'Other ID Proof',
                  items: ['Driving License', 'Nrega Card'],
                ),
                ReactiveValueListenableBuilder<String>(
                  formControlName: 'otheridproof',
                  builder: (context, control, child) {
                    return control.value != null && control.value!.isNotEmpty
                        ? IntegerTextField(
                          controlName: 'otheridno',
                          label: 'Other ID No',
                          mantatory: true,
                        )
                        : SizedBox.shrink();
                  },
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
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
