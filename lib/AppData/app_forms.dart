import 'package:flutter/widgets.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppForms {
  static FormGroup SOURCING_DETAILS_FORM = FormGroup({
    'businessdescription': FormControl<String>(
      validators: [Validators.required],
    ),
    'sourcingchannel': FormControl<String>(validators: [Validators.required]),
    'sourcingid': FormControl<String>(validators: [Validators.required]),
    'sourcingname': FormControl<String>(validators: [Validators.required]),
    'preferredbranch': FormControl<String>(validators: [Validators.required]),
    'branchcode': FormControl<String>(validators: [Validators.required]),
    'leadgeneratedby': FormControl<String>(validators: [Validators.required]),
    'leadid': FormControl<String>(validators: [Validators.required]),
    'customername': FormControl<String>(validators: [Validators.required]),
    'dateofbirth': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(validators: [Validators.required]),
    'productinterest': FormControl<String>(validators: [Validators.required]),
  });

  static FormGroup buildFieldInvestigationDetailsForm() {
    return FormGroup({
      'personMeet': FormControl<String>(validators: [Validators.required]),
      'contactNumber': FormControl<String>(validators: [Validators.required, Validators.maxLength(10), Validators.minLength(10)]),
      'FIDoneat': FormControl<String>(validators: [Validators.required]),
      'relationshipOfPerson': FormControl<String>(validators: [Validators.required]),
      'addrSameAsApplicatntAddr': FormControl<String>(validators: [Validators.required]),
      'diffAddress': FormControl<String>(validators: [Validators.required]),
      'originalKYCSeen': FormControl<String>(validators: [Validators.required]),
      'typeOfHouse': FormControl<String>(validators: [Validators.required]),
      'feedbackAndBackground': FormControl<String>(validators: [Validators.required]),
      'otherDetails': FormControl<String>(validators: [Validators.required]),
      'approachRoattoFarm': FormControl<String>(validators: [Validators.required]),
      'cropObserved': FormControl<String>(validators: [Validators.required]),
      'name1': FormControl<String>(validators: [Validators.required]),
      "address1": FormControl<String>(validators: [Validators.required]),
      'pincode1': FormControl<String>(validators: [Validators.required, Validators.maxLength(6), Validators.minLength(6)]),
      'state1': FormControl<String>(validators: [Validators.required]),
      'contactnumber1': FormControl<String>(validators: [Validators.required, Validators.maxLength(10), Validators.minLength(10)]),
      'relationship1': FormControl<String>(validators: [Validators.required]),
      'name2': FormControl<String>(validators: [Validators.required]),
      "address2": FormControl<String>(validators: [Validators.required]),
      'pincode2': FormControl<String>(validators: [Validators.required, Validators.maxLength(6), Validators.minLength(6)]),
      'state2': FormControl<String>(validators: [Validators.required]),
      'contactnumber2': FormControl<String>(validators: [Validators.required, Validators.maxLength(10), Validators.minLength(10)]),
      'relationship2': FormControl<String>(validators: [Validators.required]),
    });
  }

 static FormGroup buildInvesmentDetailsForm() {
    return FormGroup({
      'activityType': FormControl<String>(validators: [Validators.required]),
      'noOfUnitsX': FormControl<String>(validators: [Validators.required]),
      'porposedCostY': FormControl<String>(validators: [Validators.required]),
      'costXY': FormControl<String>(),
     
    });
 }
  static FormGroup buildPurchaseDetailsForm() {
    return FormGroup({
    
      'breedType': FormControl<String>(validators: [Validators.required]),
      'noOfUnitsA': FormControl<String>(validators: [Validators.required]),
      'porposedCostB': FormControl<String>(validators: [Validators.required]),
      'costAB': FormControl<String>(),
      
    });
 }
  static FormGroup buildMaintenanceDetailsForm() {
    return FormGroup({
      'breedsType': FormControl<String>(validators: [Validators.required]),
      'noOfUnitsD': FormControl<String>(validators: [Validators.required]),
      'porposedCostE': FormControl<String>(validators: [Validators.required]),
      'costDE': FormControl<String>(),
    });
 }
 static FormGroup buildLiveStockEligibility(){
  return FormGroup({
     'animalType': FormControl<String>(validators: [Validators.required]),
    'noOfAnimals': FormControl<String>(validators: [Validators.required]),
    'noOfAnimalsBatch1': FormControl<String>(validators: [Validators.required]),
    'noOfAnimalsBatch2': FormControl<String>(validators: [Validators.required]),
    'costOfAnimal': FormControl<String>(validators: [Validators.required]),
    'costOfCalf': FormControl<String>(validators: [Validators.required]),
    'averageMilkYield': FormControl<String>(validators: [Validators.required]),
    'floorSpaceAdult': FormControl<String>(validators: [Validators.required]),
    'floorSpaceCalf': FormControl<String>(validators: [Validators.required]),
    'costOfConstruction': FormControl<String>(validators: [Validators.required]),
    'insurancePremium': FormControl<String>(validators: [Validators.required]),
    'veterinary': FormControl<String>(validators: [Validators.required]),
    'quantityConcertrateFeed': FormControl<String>(validators: [Validators.required]),
    'costConcentrateFeed': FormControl<String>(validators: [Validators.required]),
    'costDryFodder': FormControl<String>(validators: [Validators.required]),
    'costGreenFodder': FormControl<String>(validators: [Validators.required]),
    'rateOfInterest': FormControl<String>(validators: [Validators.required]),
    'repaymentPeriod': FormControl<String>(validators: [Validators.required]),
    'sellingPrice': FormControl<String>(validators: [Validators.required]),
    'salePrice': FormControl<String>(validators: [Validators.required]),
    'lactationDays': FormControl<String>(validators: [Validators.required]),
    'dryDays': FormControl<String>(validators: [Validators.required]),
    'value': FormControl<String>(validators: [Validators.required]),
    'purchase': FormControl<String>(validators: [Validators.required]),

  });
 }
 static FormGroup buildDairyEligibility(){
  return FormGroup({
    'costOfMilch': FormControl<String>(validators: [Validators.required]),
    'costShedAdult': FormControl<String>(validators: [Validators.required]),
    'costShedCalf': FormControl<String>(validators: [Validators.required]),
    'capitalCost': FormControl<String>(validators: [Validators.required]),
    'costOfFirstBatch': FormControl<String>(validators: [Validators.required]),
    'costOfInsurance': FormControl<String>(validators: [Validators.required]),
    'miscexpenses': FormControl<String>(validators: [Validators.required]),
    'reccuringCost': FormControl<String>(validators: [Validators.required]),
    'loanAmountA': FormControl<String>(validators: [Validators.required]),
    'totalCost': FormControl<String>(validators: [Validators.required]),
    'margin': FormControl<String>(validators: [Validators.required]),
    'loanAmountB': FormControl<String>(validators: [Validators.required]),
    'loanAmountC': FormControl<String>(validators: [Validators.required]),
    'eligibileLimit': FormControl<String>(validators: [Validators.required]),
    'sanctionLimit': FormControl<String>(validators: [Validators.required]),
    'installments': FormControl<String>(validators: [Validators.required]),
    'emi': FormControl<String>(validators: [Validators.required]),


    
  });
 }
  static FormGroup buildIncomeandExpenses(){
  return FormGroup({
    'lactation': FormControl<String>(validators: [Validators.required]),
    'milkYield': FormControl<String>(validators: [Validators.required]),
    'milkIncome': FormControl<String>(validators: [Validators.required]),
    'gunnnyIncome': FormControl<String>(validators: [Validators.required]),
    'calvesIncome': FormControl<String>(validators: [Validators.required]),
    'mannureIncome': FormControl<String>(validators: [Validators.required]),
    'totalIncome': FormControl<String>(validators: [Validators.required]),
    'feedingCost': FormControl<String>(validators: [Validators.required]),
    'MedicineCost': FormControl<String>(validators: [Validators.required]),
    'power': FormControl<String>(validators: [Validators.required]),
    'salary': FormControl<String>(validators: [Validators.required]),
    'admin': FormControl<String>(validators: [Validators.required]),
    'insurance': FormControl<String>(validators: [Validators.required]),
    'totalExpenses': FormControl<String>(validators: [Validators.required]),
    'incomeOverExpenditure': FormControl<String>(validators: [Validators.required]),

    
  });
  }
  static FormGroup DEDUPE_DETAILS_FORM = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(
      validators: [
        Validators.maxLength(10),
        Validators.minLength(10),
        Validators.required,
      ],
    ),
    'pan': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.required,
      ],
    ),
    'aadhaar': FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(12),
        Validators.minLength(12),
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
      ],
    ),
  });

  static FormGroup CIF_DETAILS_FORM = FormGroup({
    'cifid': FormControl<String>(validators: [Validators.required]),
  });

  static FormGroup CUSTOMER_TYPE_FORM = FormGroup({
    'constitution': FormControl<String>(validators: [Validators.required]),
    'isNewCustomer': FormControl<bool>(validators: [Validators.required]),
  });

  static FormGroup GET_PERSONAL_DETAILS_FORM() => FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: []),
    'lastName': FormControl<String>(validators: []),
    'dob': FormControl<String>(validators: [Validators.required]),
    'residentialStatus': FormControl<String>(validators: []),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(validators: []),
    'panNumber': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'aadharRefNo': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'loanAmountRequested': FormControl<String>(
      validators: [Validators.required],
      asyncValidators: [
        Validators.delegateAsync((control) async {
          String val = control.value as String;
          int loanAmountEntered = int.parse(
            val.replaceAll(RegExp(r'[^\d]'), ''),
          );
          if (loanAmountEntered > Globalconfig.loanAmountMaximum) {
            print(
              'loanAmountRequested::delegateAsync => ${Globalconfig.loanAmountMaximum}',
            );
            return {'max': '${Globalconfig.loanAmountMaximum}'};
          }
          return null;
        }),
      ],
    ),
    'natureOfActivity': FormControl<String>(validators: []),
    'occupationType': FormControl<String>(validators: []),
    'agriculturistType': FormControl<String>(validators: []),
    'farmerCategory': FormControl<String>(validators: []),
    'farmerType': FormControl<String>(validators: []),
    'religion': FormControl<String>(validators: []),
    'caste': FormControl<String>(validators: []),
    'gender': FormControl<String>(validators: []),
    'subActivity': FormControl<String>(validators: []),
  });

  static final FormGroup COAPPLICANT_DETAILS_FORM = FormGroup({
    'customertype': FormControl<String>(validators: []),
    'constitution': FormControl<String>(validators: []),
    'cifNumber': FormControl<String>(validators: []),
    'title': FormControl<String>(validators: []),
    'firstName': FormControl<String>(validators: []),
    'middleName': FormControl<String>(validators: []),
    'lastName': FormControl<String>(validators: []),
    'relationshipFirm': FormControl<String>(validators: []),
    'dob': FormControl<String>(validators: []),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(),
    'panNumber': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'aadharRefNo': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'address1': FormControl<String>(validators: []),
    'address2': FormControl<String>(validators: []),
    'address3': FormControl<String>(validators: []),
    'state': FormControl<String>(validators: []),
    'cityDistrict': FormControl<String>(validators: []),
    'pincode': FormControl<String>(validators: []),
    'loanLiabilityCount': FormControl<String>(
      validators: [],
    ),
    'loanLiabilityAmount': FormControl<String>(
      validators: [],
    ),
    'depositCount': FormControl<String>(validators: []),
    'depositAmount': FormControl<String>(validators: []),
  });

  // Land Holding Form
  static FormGroup buildLandHoldingDetailsForm() {
    return FormGroup({
      'lslLandRowid': FormControl<String>(validators: []),
      'applicantName': FormControl<String>(validators: [Validators.required]),
      'locationOfFarm': FormControl<String>(
        validators: [Validators.required],
        disabled: true,
      ),
      'state': FormControl<String>(validators: [Validators.required]),
      'taluk': FormControl<String>(validators: [Validators.required]),
      'firka': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'totalAcreage': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'irrigatedLand': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'compactBlocks': FormControl<bool>(validators: [Validators.required]),
      'landOwnedByApplicant': FormControl<bool>(
        validators: [Validators.required],
      ),
      'distanceFromBranch': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
        disabled: true,
      ),
      'district': FormControl<String>(validators: [Validators.required]),
      'village': FormControl<String>(validators: [Validators.required]),
      'surveyNo': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d+$')],
      ),
      'natureOfRight': FormControl<String>(validators: [Validators.required]),
      'irrigationFacilities': FormControl<String>(
        validators: [Validators.required],
      ),
      'affectedByCeiling': FormControl<bool>(validators: [Validators.required]),
      'landAgriActive': FormControl<bool>(validators: [Validators.required]),
      'villageOfficerCertified': FormControl<bool>(
        validators: [Validators.required],
      ),
      // 'latitude': FormControl<String>(validators: []),
      // 'longitude': FormControl<String>(validators: []),
    });
  }

  static FormGroup buildCropDetailsForm() {
    return FormGroup({
      'lasSeqno': FormControl<String>(validators: []),
      'lasSeason': FormControl<String>(validators: [Validators.required]),
      'lasCrop': FormControl<String>(validators: [Validators.required]),
      'lasAreaofculti': FormControl<String>(validators: [Validators.required]),
      'lasTypOfLand': FormControl<String>(validators: [Validators.required]),
      'lasScaloffin': FormControl<String>(validators: [Validators.required]),
      'lasReqScaloffin': FormControl<String>(validators: [Validators.required]),
      'notifiedCropFlag': FormControl<bool>(validators: [Validators.required]),
      'lasPrePerAcre': FormControl<String>(validators: [Validators.required]),
      'lasPreToCollect': FormControl<String>(validators: [Validators.required]),
    });
  }
}
