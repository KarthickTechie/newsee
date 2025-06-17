// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/dedupe.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_product.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_type.dart';

class LeadSubmitRequest {
  final String userid;
  final String vertical;
  final String orgScode; // OrganizationMaster -> OrgID
  final String orgName; // OrganizationMaster -> OrgName
  final String orgLevel; // OrganizationMaster -> OrgLevel
  final String token;
  final LoanType leadDetails; // ProductScheme -> optionValue
  final LoanProduct chooseProduct;
  final Dedupe dedupeSearch;
  final PersonalData? individualNonIndividualDetails;
  final AddressData addressDetails;
  LeadSubmitRequest({
    required this.userid,
    required this.vertical,
    required this.orgScode,
    required this.orgName,
    required this.orgLevel,
    required this.token,
    required this.leadDetails,
    required this.chooseProduct,
    required this.dedupeSearch,
    this.individualNonIndividualDetails,
    required this.addressDetails,
  });

  LeadSubmitRequest copyWith({
    String? userid,
    String? vertical,
    String? orgScode,
    String? orgName,
    String? orgLevel,
    String? token,
    LoanType? leadDetails,
    LoanProduct? chooseProduct,
    Dedupe? dedupeSearch,
    PersonalData? individualNonIndividualDetails,
    AddressData? addressDetails,
  }) {
    return LeadSubmitRequest(
      userid: userid ?? this.userid,
      vertical: vertical ?? this.vertical,
      orgScode: orgScode ?? this.orgScode,
      orgName: orgName ?? this.orgName,
      orgLevel: orgLevel ?? this.orgLevel,
      token: token ?? this.token,
      leadDetails: leadDetails ?? this.leadDetails,
      chooseProduct: chooseProduct ?? this.chooseProduct,
      dedupeSearch: dedupeSearch ?? this.dedupeSearch,
      individualNonIndividualDetails:
          individualNonIndividualDetails ?? this.individualNonIndividualDetails,
      addressDetails: addressDetails ?? this.addressDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userid': userid,
      'vertical': vertical,
      'orgScode': orgScode,
      'orgName': orgName,
      'orgLevel': orgLevel,
      'token': token,
      'leadDetails': leadDetails.toMap(),
      'chooseProduct': chooseProduct.toMap(),
      'dedupeSearch': dedupeSearch.toMap(),
      'individualNonIndividualDetails': individualNonIndividualDetails?.toMap(),
      'addressDetails': addressDetails.toMap(),
    };
  }

  factory LeadSubmitRequest.fromMap(Map<String, dynamic> map) {
    return LeadSubmitRequest(
      userid: map['userid'] as String,
      vertical: map['vertical'] as String,
      orgScode: map['orgScode'] as String,
      orgName: map['orgName'] as String,
      orgLevel: map['orgLevel'] as String,
      token: map['token'] as String,
      leadDetails: LoanType.fromMap(map['leadDetails'] as Map<String, dynamic>),
      chooseProduct: LoanProduct.fromMap(
        map['chooseProduct'] as Map<String, dynamic>,
      ),
      dedupeSearch: Dedupe.fromMap(map['dedupeSearch'] as Map<String, dynamic>),
      individualNonIndividualDetails:
          map['individualNonIndividualDetails'] != null
              ? PersonalData.fromMap(
                map['individualNonIndividualDetails'] as Map<String, dynamic>,
              )
              : null,
      addressDetails: AddressData.fromMap(
        map['addressDetails'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadSubmitRequest.fromJson(String source) =>
      LeadSubmitRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LeadSubmitRequest(userid: $userid, vertical: $vertical, orgScode: $orgScode, orgName: $orgName, orgLevel: $orgLevel, token: $token, leadDetails: $leadDetails, chooseProduct: $chooseProduct, dedupeSearch: $dedupeSearch, individualNonIndividualDetails: $individualNonIndividualDetails, addressDetails: $addressDetails)';
  }

  @override
  bool operator ==(covariant LeadSubmitRequest other) {
    if (identical(this, other)) return true;

    return other.userid == userid &&
        other.vertical == vertical &&
        other.orgScode == orgScode &&
        other.orgName == orgName &&
        other.orgLevel == orgLevel &&
        other.token == token &&
        other.leadDetails == leadDetails &&
        other.chooseProduct == chooseProduct &&
        other.dedupeSearch == dedupeSearch &&
        other.individualNonIndividualDetails ==
            individualNonIndividualDetails &&
        other.addressDetails == addressDetails;
  }

  @override
  int get hashCode {
    return userid.hashCode ^
        vertical.hashCode ^
        orgScode.hashCode ^
        orgName.hashCode ^
        orgLevel.hashCode ^
        token.hashCode ^
        leadDetails.hashCode ^
        chooseProduct.hashCode ^
        dedupeSearch.hashCode ^
        individualNonIndividualDetails.hashCode ^
        addressDetails.hashCode;
  }
}
