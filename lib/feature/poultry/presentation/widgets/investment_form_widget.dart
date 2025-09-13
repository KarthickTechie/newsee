import 'package:flutter/material.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:go_router/go_router.dart';

class InvestmentFormWidget extends StatelessWidget {
  const InvestmentFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        Dropdown(
          controlName: 'activityType',
          label: 'Type of Activity',
          items: const ['Poultry', 'Dairy'],
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfUnitsX',
          label: 'Number of Units(X)',
          mantatory: true,
          maxlength: 5,

        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'porposedCostY',
          label: 'Proposed Cost/Unit(Y)',
          mantatory: true,
          maxlength: 5,
                    isRupeeFormat: true,

        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costXY',
          label: 'Cost(X*Y)',
          mantatory: true,
          isRupeeFormat: true,

        ),
        const SizedBox(height: 20),
         const SizedBox(height: 20),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 2, 59, 105)),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            if (form.valid) {
              showDialog(
                context: context,
                builder: (_) => SysmoAlert.success(
                  message: 'InvestmentForm Saved Successfully',
                  onButtonPressed: () {
                    context.pop();
                    form.markAllAsTouched();
                  },
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) => SysmoAlert.warning(
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
