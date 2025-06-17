// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoanProduct {
  final String? mainCategory;
  final String? subCategory;
  final String? producrId;
  LoanProduct({
    required this.mainCategory,
    required this.subCategory,
    required this.producrId,
  });

  LoanProduct copyWith({
    String? mainCategory,
    String? subCategory,
    String? producrId,
  }) {
    return LoanProduct(
      mainCategory: mainCategory ?? this.mainCategory,
      subCategory: subCategory ?? this.subCategory,
      producrId: producrId ?? this.producrId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'producrId': producrId,
    };
  }

  factory LoanProduct.fromMap(Map<String, dynamic> map) {
    return LoanProduct(
      mainCategory: map['mainCategory'] as String,
      subCategory: map['subCategory'] as String,
      producrId: map['producrId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanProduct.fromJson(String source) =>
      LoanProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoanProduct(mainCategory: $mainCategory, subCategory: $subCategory, producrId: $producrId)';

  @override
  bool operator ==(covariant LoanProduct other) {
    if (identical(this, other)) return true;

    return other.mainCategory == mainCategory &&
        other.subCategory == subCategory &&
        other.producrId == producrId;
  }

  @override
  int get hashCode =>
      mainCategory.hashCode ^ subCategory.hashCode ^ producrId.hashCode;
}
