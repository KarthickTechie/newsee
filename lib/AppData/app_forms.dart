import 'package:newsee/AppData/app_constants.dart';
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

  static FormGroup DEDUPE_DETAILS_FORM = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstname': FormControl<String>(validators: [Validators.required]),
    'lastname': FormControl<String>(validators: [Validators.required]),
    'mobilenumber': FormControl<String>(
      validators: [Validators.maxLength(10), Validators.minLength(10)],
    ),
    'pan': FormControl<String>(
      validators: [Validators.pattern(AppConstants.PAN_PATTERN)],
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

  static final FormGroup PERSONAL_DETAILS_FORM = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
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
    ),
    'natureOfActivity': FormControl<String>(validators: [Validators.required]),
    'occupationType': FormControl<String>(validators: [Validators.required]),
    'agriculturistType': FormControl<String>(validators: [Validators.required]),
    'farmerCategory': FormControl<String>(validators: [Validators.required]),
    'farmerType': FormControl<String>(validators: [Validators.required]),
    'religion': FormControl<String>(validators: [Validators.required]),
    'caste': FormControl<String>(validators: [Validators.required]),
    'residentialStatus': FormControl<String>(validators: [Validators.required]),
  });

  static final FormGroup COAPPLICANT_DETAILS_FORM = FormGroup({
    'customertype': FormControl<String>(validators: [Validators.required]),
    'constitution': FormControl<String>(validators: [Validators.required]),
    'cifNumber': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'relationshipFirm': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
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
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'cityDistrict': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
    'loanLiabilityCount': FormControl<String>(
      validators: [Validators.required],
    ),
    'loanLiabilityAmount': FormControl<String>(
      validators: [Validators.required],
    ),
    'depositCount': FormControl<String>(validators: [Validators.required]),
    'depositAmount': FormControl<String>(validators: [Validators.required]),
  });

  // Land Holding Form
  static final FormGroup LAND_HOLDING_FORM = FormGroup({
    'applicantName': FormControl<String>(validators: [Validators.required]),
    'locationOfFarm': FormControl<String>(validators: [Validators.required]),
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
  });

  static FormGroup CROP_DETAILS_FORM = FormGroup({
    'season': FormControl<String>(validators: [Validators.required]),
    'nameOfCrop': FormControl<String>(validators: [Validators.required]),
    'acrescultivated': FormControl<String>(validators: [Validators.required]),
    'typeofland': FormControl<String>(validators: [Validators.required]),
    'scaleoffincance': FormControl<String>(validators: [Validators.required]),
    'reqasperscaleoffinace': FormControl<String>(
      validators: [Validators.required],
    ),
    'notifiedcrop': FormControl<bool>(validators: [Validators.required]),
    'premiumperacre': FormControl<String>(validators: [Validators.required]),
    'premiumcollected': FormControl<String>(validators: [Validators.required]),
  });
}
