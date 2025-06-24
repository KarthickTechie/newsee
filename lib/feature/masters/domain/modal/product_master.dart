// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

/* 
@author    : karthick.d  
@desc     : data class model for Product Master - Main category and Subcategory
@param    : {String lsfFacId} - this is the id for the product 
            {String lsfFacParentId} - this is the id of the parent product , for
                                      main category it is 0 for 
                                      sub category it has non zero value
            {String lsfFacDesc} - Product name string
            {String lsfBizVertical} - number that define product type
                                      Agri - 7 , Retail - 11 
 */

part 'product_master.g.dart';

@JsonSerializable()
class ProductMaster {
  final String prdCode;
  final String prdDesc;
  final String prdamtFromRange;
  final String prdamtToRange;
  final String prdMainCat;
  final String prdSubCat;
  final String prdTenorFrom;
  final String prdTenorTo;
  // final String? prdMoratoriumMax;

  ProductMaster({
    required this.prdCode,
    required this.prdDesc,
    required this.prdamtFromRange,
    required this.prdamtToRange,
    required this.prdMainCat,
    required this.prdSubCat,
    required this.prdTenorFrom,
    required this.prdTenorTo,
  });

  ProductMaster copyWith({
    String? prdCode,
    String? prdDesc,
    String? prdamtFromRange,
    String? prdamtToRange,
    String? prdMainCat,
    String? prdSubCat,
    String? prdTenorFrom,
    String? prdTenorTo,
  }) {
    return ProductMaster(
      prdCode: prdCode ?? this.prdCode,
      prdDesc: prdDesc ?? this.prdDesc,
      prdamtFromRange: prdamtFromRange ?? this.prdamtFromRange,
      prdamtToRange: prdamtToRange ?? this.prdamtToRange,
      prdMainCat: prdMainCat ?? this.prdMainCat,
      prdSubCat: prdSubCat ?? this.prdSubCat,
      prdTenorFrom: prdTenorFrom ?? this.prdTenorFrom,
      prdTenorTo: prdTenorTo ?? this.prdTenorTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prdCode': prdCode,
      'prdDesc': prdDesc,
      'prdamtFromRange': prdamtFromRange,
      'prdamtToRange': prdamtToRange,
      'prdMainCat': prdMainCat,
      'prdSubCat': prdSubCat,
      'prdTenorFrom': prdTenorFrom,
      'prdTenorTo': prdTenorTo,
    };
  }

  factory ProductMaster.fromMap(Map<String, dynamic> map) {
    return ProductMaster(
      prdCode: map['prdCode'] as String,
      prdDesc: map['prdDesc'] as String,
      prdamtFromRange: map['prdamtFromRange'] as String,
      prdamtToRange: map['prdamtToRange'] as String,
      prdMainCat: map['prdMainCat'] as String,
      prdSubCat: map['prdSubCat'] as String,
      prdTenorFrom: map['prdTenorFrom'] as String,
      prdTenorTo: map['prdTenorTo'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$ProductMasterToJson(this);

  factory ProductMaster.fromJson(Map<String, dynamic> json) =>
      _$ProductMasterFromJson(json);

  @override
  String toString() {
    return 'ProductMaster(prdCode: $prdCode, prdDesc: $prdDesc, prdamtFromRange: $prdamtFromRange, prdamtToRange: $prdamtToRange, prdMainCat: $prdMainCat, prdSubCat: $prdSubCat, prdTenorFrom: $prdTenorFrom, prdTenorTo: $prdTenorTo)';
  }

  @override
  bool operator ==(covariant ProductMaster other) {
    if (identical(this, other)) return true;

    return other.prdCode == prdCode &&
        other.prdDesc == prdDesc &&
        other.prdamtFromRange == prdamtFromRange &&
        other.prdamtToRange == prdamtToRange &&
        other.prdMainCat == prdMainCat &&
        other.prdSubCat == prdSubCat &&
        other.prdTenorFrom == prdTenorFrom &&
        other.prdTenorTo == prdTenorTo;
  }

  @override
  int get hashCode {
    return prdCode.hashCode ^
        prdDesc.hashCode ^
        prdamtFromRange.hashCode ^
        prdamtToRange.hashCode ^
        prdMainCat.hashCode ^
        prdSubCat.hashCode ^
        prdTenorFrom.hashCode ^
        prdTenorTo.hashCode;
  }
}
