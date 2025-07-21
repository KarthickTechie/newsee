// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonalData {
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? dob;
  final String? residentialStatus;
  final String? primaryMobileNumber;
  final String? secondaryMobileNumber;
  final String? email;
  final String? panNumber;
  final String? aadharRefNo;
  final String? passportNumber;
  final String? loanAmountRequested;
  final String? natureOfActivity;
  final String? occupationType;
  final String? agriculturistType;
  final String? farmerCategory;
  final String? farmerType;
  final String? religion;
  final String? caste;
  final String? gender;
  final String? sourceid;
  final String? sourcename;
  final String? subActivity;
  PersonalData({
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.residentialStatus,
    this.primaryMobileNumber,
    this.secondaryMobileNumber,
    this.email,
    this.panNumber,
    this.aadharRefNo,
    this.passportNumber,
    this.loanAmountRequested,
    this.natureOfActivity,
    this.occupationType,
    this.agriculturistType,
    this.farmerCategory,
    this.farmerType,
    this.religion,
    this.caste,
    this.gender,
    this.sourceid,
    this.sourcename,
    this.subActivity,
  });

  PersonalData copyWith({
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? dob,
    String? residentialStatus,
    String? primaryMobileNumber,
    String? secondaryMobileNumber,
    String? email,
    String? panNumber,
    String? aadharRefNo,
    String? passportNumber,
    String? loanAmountRequested,
    String? natureOfActivity,
    String? occupationType,
    String? agriculturistType,
    String? farmerCategory,
    String? farmerType,
    String? religion,
    String? caste,
    String? gender,
    String? cityDistrict,
    String? sourceid,
    String? sourcename,
    String? subActivity,
  }) {
    return PersonalData(
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      residentialStatus: residentialStatus ?? this.residentialStatus,
      primaryMobileNumber: primaryMobileNumber ?? this.primaryMobileNumber,
      secondaryMobileNumber:
          secondaryMobileNumber ?? this.secondaryMobileNumber,
      email: email ?? this.email,
      panNumber: panNumber ?? this.panNumber,
      aadharRefNo: aadharRefNo ?? this.aadharRefNo,
      passportNumber: passportNumber ?? this.passportNumber,
      loanAmountRequested: loanAmountRequested ?? this.loanAmountRequested,
      natureOfActivity: natureOfActivity ?? this.natureOfActivity,
      occupationType: occupationType ?? this.occupationType,
      agriculturistType: agriculturistType ?? this.agriculturistType,
      farmerCategory: farmerCategory ?? this.farmerCategory,
      farmerType: farmerType ?? this.farmerType,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      gender: gender ?? this.gender,
      sourceid: sourceid ?? this.sourceid,
      sourcename: sourcename ?? this.sourcename,
      subActivity: subActivity ?? this.subActivity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob,
      'residentialStatus': residentialStatus,
      'primaryMobileNumber': primaryMobileNumber,
      'secondaryMobileNumber': secondaryMobileNumber,
      'email': email,
      'panNumber': panNumber,
      'aadharRefNo': aadharRefNo,
      'passportNumber': passportNumber,
      'loanAmountRequested': loanAmountRequested,
      'natureOfActivity': natureOfActivity,
      'occupationType': occupationType,
      'agriculturistType': agriculturistType,
      'farmerCategory': farmerCategory,
      'farmerType': farmerType,
      'religion': religion,
      'caste': caste,
      'gender': gender,
      'sourceid': sourceid,
      'sourcename': sourcename,
      'subActivity': subActivity,
    };
  }

  factory PersonalData.fromMap(Map<String, dynamic> map) {
    return PersonalData(
      title: map['title'] != null ? map['title'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      middleName:
          map['middleName'] != null ? map['middleName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      residentialStatus:
          map['residentialStatus'] != null
              ? map['residentialStatus'] as String
              : null,
      primaryMobileNumber:
          map['primaryMobileNumber'] != null
              ? map['primaryMobileNumber'] as String
              : null,
      secondaryMobileNumber:
          map['secondaryMobileNumber'] != null
              ? map['secondaryMobileNumber'] as String
              : null,
      email: map['email'] != null ? map['email'] as String : null,
      panNumber: map['panNumber'] != null ? map['panNumber'] as String : null,
      aadharRefNo:
          map['aadharRefNo'] != null ? map['aadharRefNo'] as String : null,
      passportNumber:
          map['passportNumber'] != null
              ? map['passportNumber'] as String
              : null,
      loanAmountRequested:
          map['loanAmountRequested'] != null
              ? map['loanAmountRequested'] as String
              : null,
      natureOfActivity:
          map['natureOfActivity'] != null
              ? map['natureOfActivity'] as String
              : null,
      occupationType:
          map['occupationType'] != null
              ? map['occupationType'] as String
              : null,
      agriculturistType:
          map['agriculturistType'] != null
              ? map['agriculturistType'] as String
              : null,
      farmerCategory:
          map['farmerCategory'] != null
              ? map['farmerCategory'] as String
              : null,
      farmerType:
          map['farmerType'] != null ? map['farmerType'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      caste: map['caste'] != null ? map['caste'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      sourceid: map['sourceid'] != null ? map['sourceid'] as String : null,
      sourcename:
          map['sourcename'] != null ? map['sourcename'] as String : null,
      subActivity:
          map['subActivity'] != null ? map['subActivity'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalData.fromJson(String source) =>
      PersonalData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonalData(title: $title, firstName: $firstName, middleName: $middleName, lastName: $lastName, dob: $dob, residentialStatus: $residentialStatus, primaryMobileNumber: $primaryMobileNumber, secondaryMobileNumber: $secondaryMobileNumber, email: $email, panNumber: $panNumber, aadharRefNo: $aadharRefNo, passportNumber: $passportNumber, loanAmountRequested: $loanAmountRequested, natureOfActivity: $natureOfActivity, occupationType: $occupationType, agriculturistType: $agriculturistType, farmerCategory: $farmerCategory, farmerType: $farmerType, religion: $religion, caste: $caste, sourceid: $sourceid, sourcename: $sourcename, subActivity: $subActivity)';
  }

  @override
  bool operator ==(covariant PersonalData other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.dob == dob &&
        other.residentialStatus == residentialStatus &&
        other.primaryMobileNumber == primaryMobileNumber &&
        other.secondaryMobileNumber == secondaryMobileNumber &&
        other.email == email &&
        other.panNumber == panNumber &&
        other.aadharRefNo == aadharRefNo &&
        other.passportNumber == passportNumber &&
        other.loanAmountRequested == loanAmountRequested &&
        other.natureOfActivity == natureOfActivity &&
        other.occupationType == occupationType &&
        other.agriculturistType == agriculturistType &&
        other.farmerCategory == farmerCategory &&
        other.farmerType == farmerType &&
        other.religion == religion &&
        other.caste == caste &&
        other.gender == gender &&
        other.sourceid == sourceid &&
        other.sourcename == sourcename &&
        other.subActivity == subActivity;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        dob.hashCode ^
        residentialStatus.hashCode ^
        primaryMobileNumber.hashCode ^
        secondaryMobileNumber.hashCode ^
        email.hashCode ^
        panNumber.hashCode ^
        aadharRefNo.hashCode ^
        passportNumber.hashCode ^
        loanAmountRequested.hashCode ^
        natureOfActivity.hashCode ^
        occupationType.hashCode ^
        agriculturistType.hashCode ^
        farmerCategory.hashCode ^
        farmerType.hashCode ^
        religion.hashCode ^
        caste.hashCode ^
        gender.hashCode ^
        sourceid.hashCode ^
        sourcename.hashCode ^
        subActivity.hashCode;
  }
}
