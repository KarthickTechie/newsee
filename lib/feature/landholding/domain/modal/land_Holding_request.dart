// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Model class representing the Land Holding request sent to API.
class LandHoldingRequest {
  String? proposalNumber;
  String? applicantName;
  String? LandOwnedByApplicant;
  String? LocationOfFarm;
  String? DistanceFromBranch;
  String? State;
  String? District;
  String? Taluk;
  String? Village;
  String? Firka;
  String? SurveyNo;
  String? TotalAcreage;
  String? NatureOfRight;
  String? OutOfTotalAcreage;
  String? NatureOfIrrigation;
  String? LandsSituatedCompactBlocks;
  String? landCeilingEnactments;
  String? villageOfficersCertificate;
  String? LandAgriculturellyActive;
  String? token;

  LandHoldingRequest({
    required this.proposalNumber,
    this.applicantName,
    this.LandOwnedByApplicant,
    this.LocationOfFarm,
    this.DistanceFromBranch,
    this.State,
    this.District,
    this.Taluk,
    this.Village,
    this.Firka,
    this.SurveyNo,
    this.TotalAcreage,
    this.NatureOfRight,
    this.OutOfTotalAcreage,
    this.NatureOfIrrigation,
    this.LandsSituatedCompactBlocks,
    this.landCeilingEnactments,
    this.villageOfficersCertificate,
    this.LandAgriculturellyActive,
    this.token,
  });

  // Convert the object into a map for API serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proposalNumber': proposalNumber,
      'applicantName': applicantName,
      'LandOwnedByApplicant': LandOwnedByApplicant,
      'LocationOfFarm': LocationOfFarm,
      'DistanceFromBranch': DistanceFromBranch,
      'State': State,
      'District': District,
      'Taluk': Taluk,
      'Village': Village,
      'Firka': Firka,
      'SurveyNo': SurveyNo,
      'TotalAcreage': TotalAcreage,
      'NatureOfRight': NatureOfRight,
      'OutOfTotalAcreage': OutOfTotalAcreage,
      'NatureOfIrrigation': NatureOfIrrigation,
      'LandsSituatedCompactBlocks': LandsSituatedCompactBlocks,
      'landCeilingEnactments': landCeilingEnactments,
      'villageOfficersCertificate': villageOfficersCertificate,
      'LandAgriculturellyActive': LandAgriculturellyActive,
      'token': token,
    };
  }

  /// Create an instance from a map (useful for decoding API response).
  factory LandHoldingRequest.fromMap(Map<String, dynamic> map) {
    return LandHoldingRequest(
      proposalNumber:
          map['proposalNumber'] != null
              ? map['proposalNumber'] as String
              : null,
      applicantName:
          map['applicantName'] != null ? map['applicantName'] as String : null,
      LandOwnedByApplicant:
          map['LandOwnedByApplicant'] != null
              ? map['LandOwnedByApplicant'] as String
              : null,
      LocationOfFarm:
          map['LocationOfFarm'] != null
              ? map['LocationOfFarm'] as String
              : null,
      DistanceFromBranch:
          map['DistanceFromBranch'] != null
              ? map['DistanceFromBranch'] as String
              : null,
      State: map['State'] != null ? map['State'] as String : null,
      District: map['District'] != null ? map['District'] as String : null,
      Taluk: map['Taluk'] != null ? map['Taluk'] as String : null,
      Village: map['Village'] != null ? map['Village'] as String : null,
      Firka: map['Firka'] != null ? map['Firka'] as String : null,
      SurveyNo: map['SurveyNo'] != null ? map['SurveyNo'] as String : null,
      TotalAcreage:
          map['TotalAcreage'] != null ? map['TotalAcreage'] as String : null,
      NatureOfRight:
          map['NatureOfRight'] != null ? map['NatureOfRight'] as String : null,
      OutOfTotalAcreage:
          map['OutOfTotalAcreage'] != null
              ? map['OutOfTotalAcreage'] as String
              : null,
      NatureOfIrrigation:
          map['NatureOfIrrigation'] != null
              ? map['NatureOfIrrigation'] as String
              : null,
      LandsSituatedCompactBlocks:
          map['LandsSituatedCompactBlocks'] != null
              ? map['LandsSituatedCompactBlocks'] as String
              : null,
      landCeilingEnactments:
          map['landCeilingEnactments'] != null
              ? map['landCeilingEnactments'] as String
              : null,
      villageOfficersCertificate:
          map['villageOfficersCertificate'] != null
              ? map['villageOfficersCertificate'] as String
              : null,
      LandAgriculturellyActive:
          map['LandAgriculturellyActive'] != null
              ? map['LandAgriculturellyActive'] as String
              : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingRequest.fromJson(String source) =>
      LandHoldingRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  LandHoldingRequest copyWith({
    String? proposalNumber,
    String? applicantName,
    String? LandOwnedByApplicant,
    String? LocationOfFarm,
    String? DistanceFromBranch,
    String? State,
    String? District,
    String? Taluk,
    String? Village,
    String? Firka,
    String? SurveyNo,
    String? TotalAcreage,
    String? NatureOfRight,
    String? OutOfTotalAcreage,
    String? NatureOfIrrigation,
    String? LandsSituatedCompactBlocks,
    String? landCeilingEnactments,
    String? villageOfficersCertificate,
    String? LandAgriculturellyActive,
    String? token,
  }) {
    return LandHoldingRequest(
      proposalNumber: proposalNumber ?? this.proposalNumber,
      applicantName: applicantName ?? this.applicantName,
      LandOwnedByApplicant: LandOwnedByApplicant ?? this.LandOwnedByApplicant,
      LocationOfFarm: LocationOfFarm ?? this.LocationOfFarm,
      DistanceFromBranch: DistanceFromBranch ?? this.DistanceFromBranch,
      State: State ?? this.State,
      District: District ?? this.District,
      Taluk: Taluk ?? this.Taluk,
      Village: Village ?? this.Village,
      Firka: Firka ?? this.Firka,
      SurveyNo: SurveyNo ?? this.SurveyNo,
      TotalAcreage: TotalAcreage ?? this.TotalAcreage,
      NatureOfRight: NatureOfRight ?? this.NatureOfRight,
      OutOfTotalAcreage: OutOfTotalAcreage ?? this.OutOfTotalAcreage,
      NatureOfIrrigation: NatureOfIrrigation ?? this.NatureOfIrrigation,
      LandsSituatedCompactBlocks:
          LandsSituatedCompactBlocks ?? this.LandsSituatedCompactBlocks,
      landCeilingEnactments:
          landCeilingEnactments ?? this.landCeilingEnactments,
      villageOfficersCertificate:
          villageOfficersCertificate ?? this.villageOfficersCertificate,
      LandAgriculturellyActive:
          LandAgriculturellyActive ?? this.LandAgriculturellyActive,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'LandHoldingRequest(proposalNumber: $proposalNumber, applicantName: $applicantName, LandOwnedByApplicant: $LandOwnedByApplicant, LocationOfFarm: $LocationOfFarm, DistanceFromBranch: $DistanceFromBranch, State: $State, District: $District, Taluk: $Taluk, Village: $Village, Firka: $Firka, SurveyNo: $SurveyNo, TotalAcreage: $TotalAcreage, NatureOfRight: $NatureOfRight, OutOfTotalAcreage: $OutOfTotalAcreage, NatureOfIrrigation: $NatureOfIrrigation, LandsSituatedCompactBlocks: $LandsSituatedCompactBlocks, landCeilingEnactments: $landCeilingEnactments, villageOfficersCertificate: $villageOfficersCertificate, LandAgriculturellyActive: $LandAgriculturellyActive, token: $token)';
  }

  @override
  bool operator ==(covariant LandHoldingRequest other) {
    if (identical(this, other)) return true;

    return other.proposalNumber == proposalNumber &&
        other.applicantName == applicantName &&
        other.LandOwnedByApplicant == LandOwnedByApplicant &&
        other.LocationOfFarm == LocationOfFarm &&
        other.DistanceFromBranch == DistanceFromBranch &&
        other.State == State &&
        other.District == District &&
        other.Taluk == Taluk &&
        other.Village == Village &&
        other.Firka == Firka &&
        other.SurveyNo == SurveyNo &&
        other.TotalAcreage == TotalAcreage &&
        other.NatureOfRight == NatureOfRight &&
        other.OutOfTotalAcreage == OutOfTotalAcreage &&
        other.NatureOfIrrigation == NatureOfIrrigation &&
        other.LandsSituatedCompactBlocks == LandsSituatedCompactBlocks &&
        other.landCeilingEnactments == landCeilingEnactments &&
        other.villageOfficersCertificate == villageOfficersCertificate &&
        other.LandAgriculturellyActive == LandAgriculturellyActive &&
        other.token == token;
  }

  @override
  int get hashCode {
    return proposalNumber.hashCode ^
        applicantName.hashCode ^
        LandOwnedByApplicant.hashCode ^
        LocationOfFarm.hashCode ^
        DistanceFromBranch.hashCode ^
        State.hashCode ^
        District.hashCode ^
        Taluk.hashCode ^
        Village.hashCode ^
        Firka.hashCode ^
        SurveyNo.hashCode ^
        TotalAcreage.hashCode ^
        NatureOfRight.hashCode ^
        OutOfTotalAcreage.hashCode ^
        NatureOfIrrigation.hashCode ^
        LandsSituatedCompactBlocks.hashCode ^
        landCeilingEnactments.hashCode ^
        villageOfficersCertificate.hashCode ^
        LandAgriculturellyActive.hashCode ^
        token.hashCode;
  }
}
