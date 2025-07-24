// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApplicationStatusResponse {
  final bool documentDetails;
  final bool ProposedCropDetails;
  final bool cibilDetails;
  final bool landHoldingDetails;
  ApplicationStatusResponse({ 
    required this.documentDetails,
    required this.ProposedCropDetails,
    required this.cibilDetails,
    required this.landHoldingDetails
  });

  ApplicationStatusResponse copyWith({
    bool? documentDetails,
    bool? ProposedCropDetails,
    bool? cibilDetails,
    bool? landHoldingDetails,
  }) {
    return ApplicationStatusResponse(
      documentDetails: documentDetails ?? this.documentDetails,
      ProposedCropDetails: ProposedCropDetails ?? this.ProposedCropDetails,
      cibilDetails: cibilDetails ?? this.cibilDetails,
      landHoldingDetails: landHoldingDetails ?? this.landHoldingDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentDetails': documentDetails,
      'ProposedCropDetails': ProposedCropDetails,
      'cibilDetails': cibilDetails,
      'landHoldingDetails': landHoldingDetails,
    };
  }

  factory ApplicationStatusResponse.fromMap(Map<String, dynamic> map) {
    return ApplicationStatusResponse(
      documentDetails: map['documentDetails'] as bool,
      ProposedCropDetails: map['ProposedCropDetails'] as bool,
      cibilDetails: map['cibilDetails'] as bool,
      landHoldingDetails: map['landHoldingDetails'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicationStatusResponse.fromJson(String source) => ApplicationStatusResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApplicationStatusResponse(documentDetails: $documentDetails, ProposedCropDetails: $ProposedCropDetails, cibilDetails: $cibilDetails, landHoldingDetails: $landHoldingDetails)';
  }

  @override
  bool operator ==(covariant ApplicationStatusResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.documentDetails == documentDetails &&
      other.ProposedCropDetails == ProposedCropDetails &&
      other.cibilDetails == cibilDetails &&
      other.landHoldingDetails == landHoldingDetails;
  }

  @override
  int get hashCode {
    return documentDetails.hashCode ^
      ProposedCropDetails.hashCode ^
      cibilDetails.hashCode ^
      landHoldingDetails.hashCode;
  }
}
