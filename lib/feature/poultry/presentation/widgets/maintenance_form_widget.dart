import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MaintananceFormWidget extends StatelessWidget {
  const MaintananceFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        Dropdown(
          controlName: 'breedsType',
          label: 'Type of Breed',
          items: const ['Catla', 'Guinea Fowl', 'Quails'],
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfUnitsD',
          label: 'Number of Units for Maintenance(D)',
          mantatory: true,
          maxlength: 5,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'porposedCostE',
          label: 'Proposed Cost of Maintenance(E)',
          mantatory: true,
          maxlength: 5,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costDE',
          label: 'Cost(D*E) for Maintenance (F)',
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
                      message: 'MaintananceForm Saved Successfully',
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
