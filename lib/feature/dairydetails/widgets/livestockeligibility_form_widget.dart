import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LiveStockEligibility extends StatelessWidget {
  const LiveStockEligibility({super.key});

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context) as FormGroup;

    return Column(
      children: [
        Dropdown(
          controlName: 'animalType',
          label: 'Type of Animal',
          items: const ['Catla', 'Guinea Fowl', 'Quails'],
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfAnimals',
          label: 'Number of Animals',
          mantatory: true,
          maxlength: 5,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfAnimalsBatch1',
          label: 'Number of Animals in Batch 1',
          mantatory: true,
          maxlength: 5,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'noOfAnimalsBatch2',
          label: 'Number of Animals in Batch 2',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costOfAnimal',
          label: 'Cost of Animal(Rs./animal)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costOfCalf',
          label: 'Cost of Calf',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'averageMilkYield',
          label: 'Average Milk Yield(litre/day)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'floorSpaceAdult',
          label: 'Floor Space(sqft) per Adult Animal',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'floorSpaceCalf',
          label: 'Floor Space(sqft) per Calf',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costOfConstruction',
          label: 'Cost of Construction per sq ft',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'insurancePremium',
          label: 'Insurance Premium(Rs./per animal)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'veterinary',
          label: 'Veterinary Aid/Animal/Year(Rs.)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'quantityConcertrateFeed',
          label: 'Quantity of Concentrate Feed in one bag(kgs)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costConcentrateFeed',
          label: 'Cost of Concentrate Feed(Rs./kg)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costDryFodder',
          label: 'Cost of Dry Fodder(Rs./kg)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'costGreenFodder',
          label: 'Cost of Green Fodder(Rs./kg)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'rateOfInterest',
          label: 'Rate Of Interest(%)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'repaymentPeriod',
          label: 'Repayment Period(years)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'sellingPrice',
          label: 'Selling Price of Milk/Litre(Rs./kg)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'salePrice',
          label: 'Sale Price of Gunny Bag(Rs./bag)',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'lactationDays',
          label: 'Lactation Days',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'dryDays',
          label: 'Dry Days',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'value',
          label: 'Value of Manure/Cow/Year',
          mantatory: true,
          isRupeeFormat: true,
        ),
        const SizedBox(height: 12),
        IntegerTextField(
          controlName: 'purchase',
          label: 'Purchase of Dairy Equipments',
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
                      message: 'LiveStockEligibility Saved Successfully',
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
