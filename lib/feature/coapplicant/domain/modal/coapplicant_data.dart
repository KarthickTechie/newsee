// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoapplicantData {
  final String? customertype;
  final String? cifNumber;
  final String? constitution;
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? dob;
  final String? relationshipFirm;
  final String? residentialStatus;
  final String? email;
  final String? primaryMobileNumber;
  final String? secondaryMobileNumber;
  final String? panNumber;
  final String? aadharRefNo;
  final String? address1;
  final String? address2;
  final String? address3;
  final String? state;
  final String? cityDistrict;
  final String? pincode;
  final String? loanLiabilityCount;
  final String? loanLiabilityAmount;
  final String? depositCount;
  final String? depositAmount;
  CoapplicantData({
    this.customertype,
    this.cifNumber,
    this.constitution,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.relationshipFirm,
    this.residentialStatus,
    this.email,
    this.primaryMobileNumber,
    this.secondaryMobileNumber,
    this.panNumber,
    this.aadharRefNo,
    this.address1,
    this.address2,
    this.address3,
    this.state,
    this.cityDistrict,
    this.pincode,
    this.loanLiabilityCount,
    this.loanLiabilityAmount,
    this.depositCount,
    this.depositAmount,
  });

  CoapplicantData copyWith({
    String? customertype,
    String? cifNumber,
    String? constitution,
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? dob,
    String? relationshipFirm,
    String? residentialStatus,
    String? email,
    String? primaryMobileNumber,
    String? secondaryMobileNumber,
    String? panNumber,
    String? aadharRefNo,
    String? address1,
    String? address2,
    String? address3,
    String? state,
    String? cityDistrict,
    String? pincode,
    String? loanLiabilityCount,
    String? loanLiabilityAmount,
    String? depositCount,
    String? depositAmount,
  }) {
    return CoapplicantData(
      customertype: customertype ?? this.customertype,
      cifNumber: cifNumber ?? this.cifNumber,
      constitution: constitution ?? this.constitution,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      relationshipFirm: relationshipFirm ?? this.relationshipFirm,
      residentialStatus: residentialStatus ?? this.residentialStatus,
      email: email ?? this.email,
      primaryMobileNumber: primaryMobileNumber ?? this.primaryMobileNumber,
      secondaryMobileNumber:
          secondaryMobileNumber ?? this.secondaryMobileNumber,
      panNumber: panNumber ?? this.panNumber,
      aadharRefNo: aadharRefNo ?? this.aadharRefNo,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      state: state ?? this.state,
      cityDistrict: cityDistrict ?? this.cityDistrict,
      pincode: pincode ?? this.pincode,
      loanLiabilityCount: loanLiabilityCount ?? this.loanLiabilityCount,
      loanLiabilityAmount: loanLiabilityAmount ?? this.loanLiabilityAmount,
      depositCount: depositCount ?? this.depositCount,
      depositAmount: depositAmount ?? this.depositAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customertype': customertype,
      'cifNumber': cifNumber,
      'constitution': constitution,
      'title': title,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob,
      'relationshipFirm': relationshipFirm,
      'residentialStatus': residentialStatus,
      'email': email,
      'primaryMobileNumber': primaryMobileNumber,
      'secondaryMobileNumber': secondaryMobileNumber,
      'panNumber': panNumber,
      'aadharRefNo': aadharRefNo,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'state': state,
      'cityDistrict': cityDistrict,
      'pincode': pincode,
      'loanLiabilityCount': loanLiabilityCount,
      'loanLiabilityAmount': loanLiabilityAmount,
      'depositCount': depositCount,
      'depositAmount': depositAmount,
    };
  }

  factory CoapplicantData.fromMap(Map<String, dynamic> map) {
    return CoapplicantData(
      customertype:
          map['customertype'] != null ? map['customertype'] as String : null,
      cifNumber: map['cifNumber'] != null ? map['cifNumber'] as String : null,
      constitution:
          map['constitution'] != null ? map['constitution'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      middleName:
          map['middleName'] != null ? map['middleName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      relationshipFirm:
          map['relationshipFirm'] != null
              ? map['relationshipFirm'] as String
              : null,
      residentialStatus:
          map['residentialStatus'] != null
              ? map['residentialStatus'] as String
              : null,
      email: map['email'] != null ? map['email'] as String : null,
      primaryMobileNumber:
          map['primaryMobileNumber'] != null
              ? map['primaryMobileNumber'] as String
              : null,
      secondaryMobileNumber:
          map['secondaryMobileNumber'] != null
              ? map['secondaryMobileNumber'] as String
              : null,
      panNumber: map['panNumber'] != null ? map['panNumber'] as String : null,
      aadharRefNo:
          map['aadharRefNo'] != null ? map['aadharRefNo'] as String : null,
      address1: map['address1'] != null ? map['address1'] as String : null,
      address2: map['address2'] != null ? map['address2'] as String : null,
      address3: map['address3'] != null ? map['address3'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      cityDistrict:
          map['cityDistrict'] != null ? map['cityDistrict'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      loanLiabilityCount:
          map['loanLiabilityCount'] != null
              ? map['loanLiabilityCount'] as String
              : null,
      loanLiabilityAmount:
          map['loanLiabilityAmount'] != null
              ? map['loanLiabilityAmount'] as String
              : null,
      depositCount:
          map['depositCount'] != null ? map['depositCount'] as String : null,
      depositAmount:
          map['depositAmount'] != null ? map['depositAmount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoapplicantData.fromJson(String source) =>
      CoapplicantData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoapplicantData(customertype: $customertype, cifNumber: $cifNumber, constitution: $constitution, title: $title, firstName: $firstName, middleName: $middleName, lastName: $lastName, dob: $dob, relationshipFirm: $relationshipFirm, residentialStatus: $residentialStatus, email: $email, primaryMobileNumber: $primaryMobileNumber, secondaryMobileNumber: $secondaryMobileNumber, panNumber: $panNumber, aadharRefNo: $aadharRefNo, address1: $address1, address2: $address2, address3: $address3, state: $state, cityDistrict: $cityDistrict, pincode: $pincode, loanLiabilityCount: $loanLiabilityCount, loanLiabilityAmount: $loanLiabilityAmount, depositCount: $depositCount, depositAmount: $depositAmount)';
  }

  @override
  bool operator ==(covariant CoapplicantData other) {
    if (identical(this, other)) return true;

    return other.customertype == customertype &&
        other.cifNumber == cifNumber &&
        other.constitution == constitution &&
        other.title == title &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.dob == dob &&
        other.relationshipFirm == relationshipFirm &&
        other.residentialStatus == residentialStatus &&
        other.email == email &&
        other.primaryMobileNumber == primaryMobileNumber &&
        other.secondaryMobileNumber == secondaryMobileNumber &&
        other.panNumber == panNumber &&
        other.aadharRefNo == aadharRefNo &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.address3 == address3 &&
        other.state == state &&
        other.cityDistrict == cityDistrict &&
        other.pincode == pincode &&
        other.loanLiabilityCount == loanLiabilityCount &&
        other.loanLiabilityAmount == loanLiabilityAmount &&
        other.depositCount == depositCount &&
        other.depositAmount == depositAmount;
  }

  @override
  int get hashCode {
    return customertype.hashCode ^
        cifNumber.hashCode ^
        constitution.hashCode ^
        title.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        dob.hashCode ^
        relationshipFirm.hashCode ^
        residentialStatus.hashCode ^
        email.hashCode ^
        primaryMobileNumber.hashCode ^
        secondaryMobileNumber.hashCode ^
        panNumber.hashCode ^
        aadharRefNo.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        address3.hashCode ^
        state.hashCode ^
        cityDistrict.hashCode ^
        pincode.hashCode ^
        loanLiabilityCount.hashCode ^
        loanLiabilityAmount.hashCode ^
        depositCount.hashCode ^
        depositAmount.hashCode;
  }
}
