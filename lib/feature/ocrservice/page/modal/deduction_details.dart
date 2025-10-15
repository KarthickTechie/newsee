// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeductionDetails {
  final String pfDeduction;
  final String otherDeduction;
  final String medicalInsurence;
  final String totalDeduction;

  DeductionDetails({
    required this.pfDeduction,
    required this.otherDeduction,
    required this.medicalInsurence,
    required this.totalDeduction,
  });



  DeductionDetails copyWith({
    String? pfDeduction,
    String? otherDeduction,
    String? medicalInsurence,
    String? totalDeduction,
  }) {
    return DeductionDetails(
      pfDeduction: pfDeduction ?? this.pfDeduction,
      otherDeduction: otherDeduction ?? this.otherDeduction,
      medicalInsurence: medicalInsurence ?? this.medicalInsurence,
      totalDeduction: totalDeduction ?? this.totalDeduction,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pfDeduction': pfDeduction,
      'otherDeduction': otherDeduction,
      'medicalInsurence': medicalInsurence,
      'totalDeduction': totalDeduction,
    };
  }

  factory DeductionDetails.fromMap(Map<String, dynamic> map) {
    return DeductionDetails(
      pfDeduction: map['pfDeduction'] as String,
      otherDeduction: map['otherDeduction'] as String,
      medicalInsurence: map['medicalInsurence'] as String,
      totalDeduction: map['totalDeduction'] as String,
    );
  }

  factory DeductionDetails.salaryMap(Map<String, dynamic> map) {
    return DeductionDetails(
      pfDeduction: map['PF'] != null ? map['PF']! ?? '' : '0',
      otherDeduction: map['OtherDeduction'] != null ? map['OtherDeduction']! ?? '' : '0',
      medicalInsurence: map['medicalInsurence'] != null ? map['medicalInsurence']! ?? '' : '₹0.00',
      totalDeduction: map['Total Deductions'] != null ? map['Total Deductions']! ?? '' : '0',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeductionDetails.fromJson(String source) => DeductionDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeductionDetails(pfDeduction: $pfDeduction, otherDeduction: $otherDeduction, medicalInsurence: $medicalInsurence, totalDeduction: $totalDeduction)';
  }

  @override
  bool operator ==(covariant DeductionDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.pfDeduction == pfDeduction &&
      other.otherDeduction == otherDeduction &&
      other.medicalInsurence == medicalInsurence &&
      other.totalDeduction == totalDeduction;
  }

  @override
  int get hashCode {
    return pfDeduction.hashCode ^
      otherDeduction.hashCode ^
      medicalInsurence.hashCode ^
      totalDeduction.hashCode;
  }
}
