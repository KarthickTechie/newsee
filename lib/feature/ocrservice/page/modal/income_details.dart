// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IncomeDetails {
  final String basic ;
  final String hra;
  final String otherAllowance;
  final String grossPay;

  IncomeDetails({
    required this.basic,
    required this.hra,
    required this.otherAllowance,
    required this.grossPay,
  });

  IncomeDetails copyWith({
    String ?basic,
    String? hra,
    String? otherAllowance,
    String? grossPay,
  }) {
    return IncomeDetails(
     basic : basic ?? this.basic,
      hra: hra ?? this.hra,
      otherAllowance: otherAllowance ?? this.otherAllowance,
      grossPay: grossPay ?? this.grossPay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'basic':basic,
      'hra': hra,
      'otherAllowance': otherAllowance,
      'grossPay': grossPay,
    };
  }

  factory IncomeDetails.fromMap(Map<String, dynamic> map) {
    return IncomeDetails(
      basic: map['basic'] as String,

      hra: map['hra'] as String,
      otherAllowance: map['otherAllowance'] as String,
      grossPay: map['grossPay'] as String,
    );
  }

  factory IncomeDetails.salarymap(Map<String, dynamic> map) {
    return IncomeDetails(
      basic: map['Basic Pay'] != null ? map['Basic Pay']! ?? '' : '0',
      hra: map['HRA'] != null ? map['HRA']! ?? '' : '0',
      otherAllowance: map['OtherAllowances'] != null ? map['OtherAllowances']! ?? '' : '0',
      grossPay: map['Total Earnings'] != null ? map['Total Earnings']! ?? '' : '0',
    );
  }

  String toJson() => json.encode(toMap());

  factory IncomeDetails.fromJson(String source) => IncomeDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IncomeDetails(basic : $basic, hra: $hra, otherAllowance: $otherAllowance, grossPay: $grossPay)';
  }

  @override
  bool operator ==(covariant IncomeDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.basic ==  basic &&
      other.hra == hra &&
      other.otherAllowance == otherAllowance &&
      other.grossPay == grossPay;
  }

  @override
  int get hashCode {
    return basic.hashCode ^
      hra.hashCode ^
      otherAllowance.hashCode ^
      grossPay.hashCode;
  }
}
