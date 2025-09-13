import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PurchaseFormWidget extends StatelessWidget {
  const PurchaseFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        Dropdown(
          controlName: 'breedType',
          label: 'Type of Breed',
          items: const ['Catla', 'Guinea Fowl', 'Quails'],
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfUnitsA',
          label: 'Number of Units for Purchase(A)',
          maxlength: 5,
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'porposedCostB',
          label: 'Proposed Cost of Purchase(B)',
          mantatory: true,
          maxlength: 5,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costAB',
          label: 'Cost(A*B) for Purchase (C)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 20),
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
                      message: 'PurchaseForm Saved Successfully',
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
