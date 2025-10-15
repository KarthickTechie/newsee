// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:newsee/feature/ocrservice/page/modal/deduction_details.dart';
import 'package:newsee/feature/ocrservice/page/modal/income_details.dart';

class SalaryslipDetails {
  final String salaryMonth;
  final IncomeDetails incomeDetails;
  final DeductionDetails deductionDetails;
  final String netPay;

  SalaryslipDetails({
    required this.salaryMonth,
    required this.incomeDetails,
    required this.deductionDetails,
    required this.netPay
  });

  SalaryslipDetails copyWith({
    String? salaryMonth,
    IncomeDetails? incomeDetails,
    DeductionDetails? deductionDetails,
    String? netPay,
  }) {
    return SalaryslipDetails(
      salaryMonth: salaryMonth ?? this.salaryMonth,
      incomeDetails: incomeDetails ?? this.incomeDetails,
      deductionDetails: deductionDetails ?? this.deductionDetails,
      netPay: netPay ?? this.netPay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salaryMonth': salaryMonth,
      'incomeDetails': incomeDetails.toMap(),
      'deductionDetails': deductionDetails.toMap(),
      'netPay': netPay,
    };
  }

  Map<String, dynamic> toMapForm() {
    return <String, dynamic>{
      'salaryMonth': salaryMonth,
      'basic': incomeDetails.basic,
      'hra': incomeDetails.hra,
      'otherAllowance': incomeDetails.otherAllowance,
      'grossPay': incomeDetails.grossPay,
      'pfDeduction': deductionDetails.pfDeduction,
      'otherDeduction': deductionDetails.otherDeduction,
      'medicalInsurance': deductionDetails.medicalInsurence,
      'totalDeduction': deductionDetails.totalDeduction,
      'netPay': netPay,
    };
  }

  factory SalaryslipDetails.fromMap(Map<String, dynamic> map) {
    return SalaryslipDetails(
      salaryMonth: map['salaryMonth'] as String,
      incomeDetails: IncomeDetails.fromMap(map['incomeDetails'] as Map<String,dynamic>),
      deductionDetails: DeductionDetails.fromMap(map['deductionDetails'] as Map<String,dynamic>),
      netPay: map['netPay'] as String,
    );
  }

  factory SalaryslipDetails.salaryMap(Map<String, dynamic> data) {
    return SalaryslipDetails(
      salaryMonth: data['salary_month'] != null ? data['salary_month'] as String : '',
      incomeDetails: IncomeDetails.salarymap(data['earnings'] as Map<String,dynamic>),
      deductionDetails: DeductionDetails.salaryMap(data['deductions'] as Map<String,dynamic>),
      netPay: data['net_amount'] != null ? data['net_amount'] as String : '0'
    );
  }

  String toJson() => json.encode(toMap());

  factory SalaryslipDetails.fromJson(String source) => SalaryslipDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalaryslipDetails(salaryMonth: $salaryMonth, incomeDetails: $incomeDetails, deductionDetails: $deductionDetails, netPay: $netPay)';
  }

  @override
  bool operator ==(covariant SalaryslipDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.salaryMonth == salaryMonth &&
      other.incomeDetails == incomeDetails &&
      other.deductionDetails == deductionDetails &&
      other.netPay == netPay;
  }

  @override
  int get hashCode {
    return salaryMonth.hashCode ^
      incomeDetails.hashCode ^
      deductionDetails.hashCode ^
      netPay.hashCode;
  }
}
