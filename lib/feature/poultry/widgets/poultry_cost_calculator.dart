import 'package:newsee/Utils/utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PoultryCostCalculator {
  static void attachListener({
    required FormGroup investment,
    required FormGroup purchase,
    required FormGroup maintenance,
  }) {
    
    // Investment form calculation
    investment.valueChanges.listen((values) {
      print("print investment values  $values");
      final formValues = values ?? {};

      String? noOfUnitsXStr = formValues['noOfUnitsX']?.toString();
      String? noOfunits = noOfUnitsXStr?.replaceAll(RegExp(r'[^\d]'),'');
      int noOfUnitsX = int.tryParse(noOfunits ?? '0') ?? 0;

      String? proposeCostYStr = formValues['porposedCostY']?.toString();
      String? proposedCostY = proposeCostYStr?.replaceAll(RegExp(r'[^\d]'),'');
      int porposedCostY = int.tryParse(proposedCostY.toString() ?? '0') ?? 0;

      final costXY = noOfUnitsX * porposedCostY;
      String finalCostXY = formatAmount(costXY.toString());

      investment.control('costXY')
          .updateValue(finalCostXY.toString());
    });

    // Purchase form calculation
    purchase.valueChanges.listen((values) {
      final formValues = values ?? {};

      String? formNoOfUnitsStr = formValues['noOfUnitsA']?.toString();
      String? noOfunits = formNoOfUnitsStr?.replaceAll(RegExp(r'[^\d]'),'');
      int noOfUnitsA = int.tryParse(noOfunits ?? '0') ?? 0;

      String? proposeCostStr = formValues['porposedCostB']?.toString();
      String? proposedCost = proposeCostStr?.replaceAll(RegExp(r'[^\d]'),'');
      int porposedCostB = int.tryParse(proposedCost.toString() ?? '0') ?? 0;

      final costAB = noOfUnitsA * porposedCostB;
      String finalcostAB = formatAmount(costAB.toString());

      purchase.control('costAB')
          .updateValue(finalcostAB.toString());
    });

    // Maintenance form calculation
    maintenance.valueChanges.listen((values) {
      final formValues = values ?? {};

      String? formNoOfUnitsDStr = formValues['noOfUnitsD']?.toString();
      String? noOfunits = formNoOfUnitsDStr?.replaceAll(RegExp(r'[^\d]'),'');
      int noOfUnitsD = int.tryParse(noOfunits ?? '0') ?? 0;

      String? proposeCostEStr = formValues['porposedCostE']?.toString();
      String? proposedCost = proposeCostEStr?.replaceAll(RegExp(r'[^\d]'),'');
      int porposedCostE = int.tryParse(proposedCost.toString() ?? '0') ?? 0;

      final costDE = noOfUnitsD * porposedCostE;
      String finalcostAB = formatAmount(costDE.toString());

      maintenance.control('costDE')
          .updateValue(finalcostAB.toString());
    });
  }
}