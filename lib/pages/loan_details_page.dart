import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoanDetailsPage extends StatelessWidget {
  final String title;
  final ValueNotifier<bool> isFormDirty = ValueNotifier<bool>(true);
  LoanDetailsPage(String s, {super.key, required this.title});

  final form = FormGroup({
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
    'loanproduct': FormControl<String>(validators: [Validators.required]),
    'loanamount': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFormDirty.value) {
          final shouldLeave = await showExitConfirmationDialog(context);
          return shouldLeave ?? false;
        }
        return true;
      },
      child: Scaffold(
      appBar: AppBar(title: Text("Loan Details")),
      body: ReactiveForm(
        formGroup: form,
        //  onChanged: () {
        //     isFormDirty.value = form.dirty;
        //   },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Dropdown(
                  controlName: 'subcategory',
                  label: 'Sub Category',
                  items: ['', ''],
                ),
                Dropdown(
                  controlName: 'loanproduct',
                  label: 'Loan Product',
                  items: ['', ''],
                ),
                IntegerTextField(
                  controlName: 'loanamount',
                  label: 'Loan Amount Requested(₹)',
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
    )
    );
  }

   Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('You have unsaved changes. Do you really want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Leave'),
            ),
          ],
        );
      },
    );
  }
}
