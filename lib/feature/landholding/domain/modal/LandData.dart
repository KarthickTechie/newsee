// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LandData extends Equatable {
  final int? lslLandRowid;
  final int? lslPropNo;
  final String? lslLandApplicantName;
  final String? lslLandApplicant;
  final String? lslLandFarmLoc;
  final int? lslLandFarmDistance;
  final String? lslLandState;
  final String? lslLandDistrict;
  final String? lslLandTaluk;
  final String? lslLandVillage;
  final String? lslLandFirka;
  final String? lslLandSurveyNo;
  final int? lslLandTotAcre;
  final String? lslLandNature;
  final int? lslLandIrriLand;
  final String? lslLandIrriFaci;
  final String? lslLandCompact;
  final String? lslLandCeilingEnact;
  final String? lslLandOfficeCerti;
  final String? lslAgriActive;

  const LandData({
    this.lslLandRowid,
    this.lslPropNo,
    required this.lslLandApplicantName,
    required this.lslLandApplicant,
    required this.lslLandFarmLoc,
    required this.lslLandFarmDistance,
    required this.lslLandState,
    required this.lslLandDistrict,
    required this.lslLandTaluk,
    required this.lslLandVillage,
    required this.lslLandFirka,
    required this.lslLandSurveyNo,
    required this.lslLandTotAcre,
    this.lslLandNature,
    required this.lslLandIrriLand,
    this.lslLandIrriFaci,
    required this.lslLandCompact,
    this.lslLandCeilingEnact,
    this.lslLandOfficeCerti,
    this.lslAgriActive,
  });

  @override
  List<Object?> get props {
    return [
      lslLandRowid,
      lslPropNo,
      lslLandApplicantName,
      lslLandApplicant,
      lslLandFarmLoc,
      lslLandFarmDistance,
      lslLandState,
      lslLandDistrict,
      lslLandTaluk,
      lslLandVillage,
      lslLandFirka,
      lslLandSurveyNo,
      lslLandTotAcre,
      lslLandNature,
      lslLandIrriLand,
      lslLandIrriFaci,
      lslLandCompact,
      lslLandCeilingEnact,
      lslLandOfficeCerti,
      lslAgriActive,
    ];
  }

  LandData copyWith({
    int? lslLandRowid,
    int? lslPropNo,
    String? lslLandApplicantName,
    String? lslLandApplicant,
    String? lslLandFarmLoc,
    int? lslLandFarmDistance,
    String? lslLandState,
    String? lslLandDistrict,
    String? lslLandTaluk,
    String? lslLandVillage,
    String? lslLandFirka,
    String? lslLandSurveyNo,
    int? lslLandTotAcre,
    String? lslLandNature,
    int? lslLandIrriLand,
    String? lslLandIrriFaci,
    String? lslLandCompact,
    String? lslLandCeilingEnact,
    String? lslLandOfficeCerti,
    String? lslAgriActive,
  }) {
    return LandData(
      lslLandRowid: lslLandRowid ?? this.lslLandRowid,
      lslPropNo: lslPropNo ?? this.lslPropNo,
      lslLandApplicantName: lslLandApplicantName ?? this.lslLandApplicantName,
      lslLandApplicant: lslLandApplicant ?? this.lslLandApplicant,
      lslLandFarmLoc: lslLandFarmLoc ?? this.lslLandFarmLoc,
      lslLandFarmDistance: lslLandFarmDistance ?? this.lslLandFarmDistance,
      lslLandState: lslLandState ?? this.lslLandState,
      lslLandDistrict: lslLandDistrict ?? this.lslLandDistrict,
      lslLandTaluk: lslLandTaluk ?? this.lslLandTaluk,
      lslLandVillage: lslLandVillage ?? this.lslLandVillage,
      lslLandFirka: lslLandFirka ?? this.lslLandFirka,
      lslLandSurveyNo: lslLandSurveyNo ?? this.lslLandSurveyNo,
      lslLandTotAcre: lslLandTotAcre ?? this.lslLandTotAcre,
      lslLandNature: lslLandNature ?? this.lslLandNature,
      lslLandIrriLand: lslLandIrriLand ?? this.lslLandIrriLand,
      lslLandIrriFaci: lslLandIrriFaci ?? this.lslLandIrriFaci,
      lslLandCompact: lslLandCompact ?? this.lslLandCompact,
      lslLandCeilingEnact: lslLandCeilingEnact ?? this.lslLandCeilingEnact,
      lslLandOfficeCerti: lslLandOfficeCerti ?? this.lslLandOfficeCerti,
      lslAgriActive: lslAgriActive ?? this.lslAgriActive,
    );
  }

  Map<String, dynamic> mapForm() {
    return {
      'applicantName': lslLandApplicantName,
      'locationOfFarm': lslLandFarmLoc,
      'state': lslLandState,
      'taluk': lslLandTaluk,
      'firka': lslLandFirka,
      'totalAcreage': lslLandTotAcre,
      'irrigatedLand': lslLandIrriLand,
      'compactBlocks': lslLandCompact,
      'landOwnedByApplicant': lslLandApplicant,
      'distanceFromBranch': lslLandFarmDistance,
      'district': lslLandDistrict,
      'village': lslLandVillage,
      'surveyNo': lslLandSurveyNo,
      'natureOfRight': lslLandNature,
      'irrigationFacilities': lslLandIrriFaci,
      'affectedByCeiling': lslLandCeilingEnact,
      'landAgriActive': lslAgriActive,
      'villageOfficerCertified': lslLandOfficeCerti,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lslLandRowid': lslLandRowid,
      'lslPropNo': lslPropNo,
      'lslLandApplicantName': lslLandApplicantName,
      'lslLandApplicant': lslLandApplicant,
      'lslLandFarmLoc': lslLandFarmLoc,
      'lslLandFarmDistance': lslLandFarmDistance,
      'lslLandState': lslLandState,
      'lslLandDistrict': lslLandDistrict,
      'lslLandTaluk': lslLandTaluk,
      'lslLandVillage': lslLandVillage,
      'lslLandFirka': lslLandFirka,
      'lslLandSurveyNo': lslLandSurveyNo,
      'lslLandTotAcre': lslLandTotAcre,
      'lslLandNature': lslLandNature,
      'lslLandIrriLand': lslLandIrriLand,
      'lslLandIrriFaci': lslLandIrriFaci,
      'lslLandCompact': lslLandCompact,
      'lslLandCeilingEnact': lslLandCeilingEnact,
      'lslLandOfficeCerti': lslLandOfficeCerti,
      'lslAgriActive': lslAgriActive,
    };
  }

  factory LandData.fromMap(Map<String, dynamic> map) {
    return LandData(
      lslLandRowid:
          map['lslLandRowid'] != null ? map['lslLandRowid'] as int : null,
      lslPropNo: map['lslPropNo'] != null ? map['lslPropNo'] as int : null,
      lslLandApplicantName:
          map['lslLandApplicantName'] != null
              ? map['lslLandApplicantName'] as String
              : null,
      lslLandApplicant:
          map['lslLandApplicant'] != null
              ? map['lslLandApplicant'] as String
              : null,
      lslLandFarmLoc:
          map['lslLandFarmLoc'] != null
              ? map['lslLandFarmLoc'] as String
              : null,
      lslLandFarmDistance:
          map['lslLandFarmDistance'] != null
              ? map['lslLandFarmDistance'] as int
              : null,
      lslLandState:
          map['lslLandState'] != null ? map['lslLandState'] as String : null,
      lslLandDistrict:
          map['lslLandDistrict'] != null
              ? map['lslLandDistrict'] as String
              : null,
      lslLandTaluk:
          map['lslLandTaluk'] != null ? map['lslLandTaluk'] as String : null,
      lslLandVillage:
          map['lslLandVillage'] != null
              ? map['lslLandVillage'] as String
              : null,
      lslLandFirka:
          map['lslLandFirka'] != null ? map['lslLandFirka'] as String : null,
      lslLandSurveyNo:
          map['lslLandSurveyNo'] != null
              ? map['lslLandSurveyNo'] as String
              : null,
      lslLandTotAcre:
          map['lslLandTotAcre'] != null ? map['lslLandTotAcre'] as int : null,
      lslLandNature:
          map['lslLandNature'] != null ? map['lslLandNature'] as String : null,
      lslLandIrriLand:
          map['lslLandIrriLand'] != null ? map['lslLandIrriLand'] as int : null,
      lslLandIrriFaci:
          map['lslLandIrriFaci'] != null
              ? map['lslLandIrriFaci'] as String
              : null,
      lslLandCompact:
          map['lslLandCompact'] != null
              ? map['lslLandCompact'] as String
              : null,
      lslLandCeilingEnact:
          map['lslLandCeilingEnact'] != null
              ? map['lslLandCeilingEnact'] as String
              : null,
      lslLandOfficeCerti:
          map['lslLandOfficeCerti'] != null
              ? map['lslLandOfficeCerti'] as String
              : null,
      lslAgriActive:
          map['lslAgriActive'] != null ? map['lslAgriActive'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandData.fromJson(String source) =>
      LandData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
