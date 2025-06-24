import 'package:equatable/equatable.dart';

class LandData extends Equatable {
  final String applicantName;
  final String locationOfFarm;
  final String state;
  final String taluk;
  final String firka;
  final String totalAcreage;
  final String irrigatedLand;
  final bool compactBlocks;
  final bool landOwnedByApplicant;
  final String distanceFromBranch;
  final String district;
  final String village;
  final String surveyNo;
  final String natureOfRight;
  final String irrigationFacilities;
  final bool affectedByCeiling;
  final bool landAgriActive;
  final bool villageOfficerCertified;

  const LandData({
    required this.applicantName,
    required this.locationOfFarm,
    required this.state,
    required this.taluk,
    required this.firka,
    required this.totalAcreage,
    required this.irrigatedLand,
    required this.compactBlocks,
    required this.landOwnedByApplicant,
    required this.distanceFromBranch,
    required this.district,
    required this.village,
    required this.surveyNo,
    required this.natureOfRight,
    required this.irrigationFacilities,
    required this.affectedByCeiling,
    required this.landAgriActive,
    required this.villageOfficerCertified,
  });

  factory LandData.fromForm(Map<String, dynamic> form) {
    return LandData(
      applicantName: form['applicantName'] ?? '',
      locationOfFarm: form['locationOfFarm'] ?? '',
      state: form['state'] ?? '',
      taluk: form['taluk'] ?? '',
      firka: form['firka'] ?? '',
      totalAcreage: form['totalAcreage'] ?? '',
      irrigatedLand: form['irrigatedLand'] ?? '',
      compactBlocks: form['compactBlocks'] ?? false,
      landOwnedByApplicant: form['landOwnedByApplicant'] ?? false,
      distanceFromBranch: form['distanceFromBranch'] ?? '',
      district: form['district'] ?? '',
      village: form['village'] ?? '',
      surveyNo: form['surveyNo'] ?? '',
      natureOfRight: form['natureOfRight'] ?? '',
      irrigationFacilities: form['irrigationFacilities'] ?? '',
      affectedByCeiling: form['affectedByCeiling'] ?? false,
      landAgriActive: form['landAgriActive'] ?? false,
      villageOfficerCertified: form['villageOfficerCertified'] ?? false,
    );
  }

  factory LandData.fromMap(Map<String, dynamic> map) {
    return LandData(
      applicantName: map['applicantName'] ?? '',
      locationOfFarm: map['locationOfFarm'] ?? '',
      state: map['state'] ?? '',
      taluk: map['taluk'] ?? '',
      firka: map['firka'] ?? '',
      totalAcreage: map['totalAcreage'] ?? '',
      irrigatedLand: map['irrigatedLand'] ?? '',
      compactBlocks: map['compactBlocks'] == true || map['compactBlocks'] == 1,
      landOwnedByApplicant:
          map['landOwnedByApplicant'] == true ||
          map['landOwnedByApplicant'] == 1,
      distanceFromBranch: map['distanceFromBranch'] ?? '',
      district: map['district'] ?? '',
      village: map['village'] ?? '',
      surveyNo: map['surveyNo'] ?? '',
      natureOfRight: map['natureOfRight'] ?? '',
      irrigationFacilities: map['irrigationFacilities'] ?? '',
      affectedByCeiling:
          map['affectedByCeiling'] == true || map['affectedByCeiling'] == 1,
      landAgriActive:
          map['landAgriActive'] == true || map['landAgriActive'] == 1,
      villageOfficerCertified:
          map['villageOfficerCertified'] == true ||
          map['villageOfficerCertified'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicantName': applicantName,
      'locationOfFarm': locationOfFarm,
      'state': state,
      'taluk': taluk,
      'firka': firka,
      'totalAcreage': totalAcreage,
      'irrigatedLand': irrigatedLand,
      'compactBlocks': compactBlocks,
      'landOwnedByApplicant': landOwnedByApplicant,
      'distanceFromBranch': distanceFromBranch,
      'district': district,
      'village': village,
      'surveyNo': surveyNo,
      'natureOfRight': natureOfRight,
      'irrigationFacilities': irrigationFacilities,
      'affectedByCeiling': affectedByCeiling,
      'landAgriActive': landAgriActive,
      'villageOfficerCertified': villageOfficerCertified,
    };
  }

  @override
  List<Object?> get props => [
    applicantName,
    locationOfFarm,
    state,
    taluk,
    firka,
    totalAcreage,
    irrigatedLand,
    compactBlocks,
    landOwnedByApplicant,
    distanceFromBranch,
    district,
    village,
    surveyNo,
    natureOfRight,
    irrigationFacilities,
    affectedByCeiling,
    landAgriActive,
    villageOfficerCertified,
  ];
}
