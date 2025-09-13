import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';


class DairyCostCalculator {

  /// Attaches a listener to livestock form and updates dairy + income forms.
  static void attachListener({
    required FormGroup liveStockForm,
    required FormGroup dairyForm,
    required FormGroup incomeForm,
  }) {
    // Formatter for Indian-style numbers (e.g., 12,34,567).
    final digits = NumberFormat.decimalPattern('en_IN');

    /// Safely parse integers from dynamic values.
    int parseInt(dynamic value) {
      final str = value?.toString() ?? '0';
      final cleaned = str.replaceAll(RegExp(r'[^\d]'), '');
      return int.tryParse(cleaned.isEmpty ? '0' : cleaned) ?? 0;
    }

    // Whenever livestock form changes → recalculate all dependent values.
    liveStockForm.valueChanges.listen((formValues) {
      final values = formValues ?? {};

      //  livestock inputs
      final animals = parseInt(values['noOfAnimals']);
      final noOfAnimalsBatch1 = parseInt(values['noOfAnimalsBatch1']);
      final costOfAnimal = parseInt(values['costOfAnimal']);
      final costOfCalf = parseInt(values['costOfCalf']);
      final floorSpaceAdult = parseInt(values['floorSpaceAdult']);
      final floorSpaceCalf = parseInt(values['floorSpaceCalf']);
      final costOfConstruction = parseInt(values['costOfConstruction']);
      final averageMilkYield = parseInt(values['averageMilkYield']);
      final insurancePremium = parseInt(values['insurancePremium']);
      final veterinary = parseInt(values['veterinary']);
      final feed = parseInt(values['costConcentrateFeed']);
      final sellingPrice = parseInt(values['sellingPrice']);
      final salePrice = parseInt(values['salePrice']);
      final lactationDays = parseInt(values['lactationDays']);
      final value = parseInt(values['value']);

      // Other expense fields
      final power = parseInt(values['power']);
      final salary = parseInt(values['salary']);
      final admin = parseInt(values['admin']);
      final miscExpenses = parseInt(values['miscexpenses']);

      // COST CALCULATIONS

      final costOfMilch = animals * costOfAnimal;
      final costShedAdult = animals * floorSpaceAdult * costOfConstruction;
      final costShedCalf =
          noOfAnimalsBatch1 * floorSpaceCalf * costOfConstruction;

      final capitalCost = costOfMilch + costShedAdult + costShedCalf;
      final costOfFirstBatch = noOfAnimalsBatch1 * feed * 30;
      final costOfInsurance =
          (2 * costOfAnimal * 0.05 * insurancePremium).toInt();

      final reccuringCost = costOfFirstBatch + costOfInsurance;
      final totalCost = capitalCost + reccuringCost;
      final margin = (totalCost * 0.15).toInt();
      final loanAmountB = totalCost - margin;

      // Update dairy form with formatted values
      dairyForm.patchValue({
        'costOfMilch': digits.format(costOfMilch),
        'costShedAdult': digits.format(costShedAdult),
        'costShedCalf': digits.format(costShedCalf),
        'capitalCost': digits.format(capitalCost),
        'costOfFirstBatch': digits.format(costOfFirstBatch),
        'costOfInsurance': digits.format(costOfInsurance),
        'reccuringCost': digits.format(reccuringCost),
        'totalCost': digits.format(totalCost),
        'margin': digits.format(margin),
        'loanAmountB': digits.format(loanAmountB),
      });

      // INCOME CALCULATIONS
      final lactation = lactationDays;
      final milkYield = animals * averageMilkYield;
      final milkIncome = milkYield * sellingPrice;
      final gunnnyIncome = animals * salePrice;
      final calvesIncome = noOfAnimalsBatch1 * costOfCalf;
      final mannureIncome = animals * value;

      final totalIncome = lactation +
          milkYield +
          milkIncome +
          gunnnyIncome +
          calvesIncome +
          mannureIncome;

      // EXPENSE CALCULATIONS
      final feedingCost = animals * feed;
      final medicineCost = animals * veterinary;
      final insurance = animals * insurancePremium;

      final totalExpenses = feedingCost +
          medicineCost +
          power +
          salary +
          admin +
          miscExpenses +
          insurance;

      // Final net income
      final incomeOverExpenditure = totalIncome - totalExpenses;

      // Update income form with formatted values
      incomeForm.patchValue({
        'lactation': digits.format(lactation),
        'milkYield': digits.format(milkYield),
        'milkIncome': digits.format(milkIncome),
        'gunnnyIncome': digits.format(gunnnyIncome),
        'calvesIncome': digits.format(calvesIncome),
        'mannureIncome': digits.format(mannureIncome),
        'totalIncome': digits.format(totalIncome),
        'feedingCost': digits.format(feedingCost),
        'medicineCost': digits.format(medicineCost),
        'power': digits.format(power),
        'salary': digits.format(salary),
        'admin': digits.format(admin),
        'miscexpenses': digits.format(miscExpenses),
        'insurance': digits.format(insurance),
        'totalExpenses': digits.format(totalExpenses),
        'incomeOverExpenditure': digits.format(incomeOverExpenditure),
      });
    });
  }
}
