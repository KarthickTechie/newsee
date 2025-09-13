import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IncomeandExpenses extends StatelessWidget {
  const IncomeandExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        const Text(
          'INCOME DETAILS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'lactation',
          label: 'Lactation Days',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'milkYield',
          label: 'Milk Yield in Litres',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'milkIncome',
          label: 'Income of Milk',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'gunnnyIncome',
          label: 'Income on Gunny Bags',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'calvesIncome',
          label: 'Income on Sale of Calves',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'mannureIncome',
          label: 'Income-Mannure',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'totalIncome',
          label: 'Total Income',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        const Text(
          'EXPENSE DETAILS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'feedingCost',
          label: 'Feeding Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'MedicineCost',
          label: 'Medicine Cost',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'power',
          label: 'Power',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'salary',
          label: 'Salary & Wages',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'admin',
          label: 'Admin Costs',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'insurance',
          label: 'Insurance',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'totalExpenses',
          label: 'Total Expenses',
          mantatory: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'incomeOverExpenditure',
          label: 'Income over Expenditure',
          mantatory: true,
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
                      message: 'Income and Expenses Saved Successfully',
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
