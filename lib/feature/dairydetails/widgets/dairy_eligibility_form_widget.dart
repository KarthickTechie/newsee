import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DairyEligibility extends StatelessWidget {
  const DairyEligibility({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        IntegerTextField(
          controlName: 'costOfMilch',
          label: 'Cost of Milch Animals including Transportation Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costShedAdult',
          label: 'Cost of Construction of Shed for Adult Animals',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costShedCalf',
          label: 'Cost of Construction of Shed for Calf',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'capitalCost',
          label: 'Capital Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costOfFirstBatch',
          label: 'Cost of Concentrate Feed for First Batch',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costOfInsurance',
          label: 'Cost of Insurance 2 Animals(@5% of the cost)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'miscexpenses',
          label: 'Misc Expenses',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'reccuringCost',
          label: 'Recurring Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'loanAmountA',
          label: 'Loan Amount based on Income A',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'totalCost',
          label: 'Total Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'margin',
          label: 'Margin (Min 15%)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'loanAmountB',
          label: 'Loan Amount based on Project Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'loanAmountC',
          label: 'Loan Amount Requested',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'eligibileLimit',
          label: 'Eligible Limit',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'sanctionLimit',
          label: 'Sanction Limit',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'installments',
          label: 'No of Installments',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'emi',
          label: 'EMI',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 2, 59, 105),
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            if (form.valid) {
              showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert.success(
                      message: 'DairyEligibility Saved Successfully',
                      onButtonPressed: () {
                        context.pop();
                        form.markAllAsTouched();
                      },
                    ),
              );
            } else {
              showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert.warning(
                      message: 'Please fill the entire form before proceeding',
                      onButtonPressed: () {
                        context.pop();
                        form.markAllAsTouched();
                      },
                    ),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
