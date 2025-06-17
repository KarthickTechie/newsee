import 'package:flutter/material.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/pages/guarantor_page.dart';

class PersonalDetailsPage extends StatelessWidget {
  final String title;

  PersonalDetailsPage(String s, {required this.title, super.key});

  final form = FormGroup({
    'customertype': FormControl<String>(validators: [Validators.required]),
    'constitution': FormControl<String>(validators: [Validators.required]),
    'leadcategory': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'emailid': FormControl<String>(validators: [Validators.email]),
    'address': FormControl<String>(validators: [Validators.required]),
    'addressline1': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
    'guarantorapplicable': FormControl<String>(
      validators: [Validators.required],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal Details")),
      body: ReactiveForm(
        formGroup: form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'customertype',
                  label: 'Customer Type',
                  items: ['Existing Customer', 'New Customer'],
                ),
                Dropdown(
                  controlName: 'constitution',
                  label: 'Constitution',
                  items: [
                    'HUF',
                    'Individual',
                    'LLP',
                    'Partnership',
                    'Private Ltd',
                    'Propiertorship',
                    'Public Ltd',
                    'Trust',
                  ],
                ),
                Dropdown(
                  controlName: 'leadcategory',
                  label: 'Lead Category',
                  items: ['Cold', 'Hot', 'Warm'],
                ),
                SearchableDropdown(
                  controlName: 'title',
                  label: 'Title',
                  items: [
                    'COLONEL',
                    'DR',
                    'LT.COL',
                    'M/S',
                    'MAJOR',
                    'MASTER(MINOR)',
                    'MESSERS',
                    'MIGRATION DEFAULT',
                    'MISS',
                    'MOHAMMAD',
                    'MR',
                    'MRS',
                    'MX',
                    'SHEIKH',
                    'SIR',
                  ],
                  selItem: () {},
                ),
                IntegerTextField(
                  controlName: 'mobilenumber',
                  label: 'Mobile Number',
                  mantatory: true,
                  maxlength: 10,
                ),
                CustomTextField(
                  controlName: 'emailid',
                  label: 'Email Id',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'address',
                  label: 'Address',
                  mantatory: true,
                ),
                CustomTextField(
                  controlName: 'addressline1',
                  label: 'Address Line 1',
                  mantatory: true,
                ),
                SearchableDropdown(
                  controlName: 'state',
                  label: 'State',
                  items: ['Tamil Nadu', 'Kerala', 'Karnataka'],
                  selItem: () {},
                ),
                SearchableDropdown(
                  controlName: 'city',
                  label: 'City',
                  items: ['Chennai', 'Madurai', 'Bangalore'],
                  selItem: () {},
                ),
                IntegerTextField(
                  controlName: 'pincode',
                  label: 'Pincode',
                  mantatory: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ReactiveDropdownField<String>(
                          formControlName: 'guarantorapplicable',
                          decoration: InputDecoration(
                            labelText: 'Whether Co-App/Guarantor Applicable?',
                            hintText: '--Select--',
                          ),
                          items:
                              ['Yes', 'No']
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      SizedBox(width: 12),
                      ReactiveValueListenableBuilder<String>(
                        formControlName: 'guarantorapplicable',
                        builder: (context, control, child) {
                          final isEnabled = control.value == 'Yes';
                          return ElevatedButton(
                            onPressed:
                                isEnabled
                                    ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => GuarantorPage(
                                                title: 'test',
                                                'test',
                                              ),
                                        ),
                                      );
                                    }
                                    : null,
                            child: Text("+"),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
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
