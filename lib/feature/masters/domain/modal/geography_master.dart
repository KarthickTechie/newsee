// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

/* 
@author   : karthick.d 11/06/2025
@desc     : state city disctric master datamodel 
            (due to ease of processing , statecitymaster respons is changed)
            so statecitymaster.dart become obsolete
@param    : {String stateParentId} - will be "0" for states only , non zero for city & district
            {String cityParentId}  - will be "0" for city only , non zero for district
            {String code}          - code for state , city , district
            {String value}         - value for state , city , district name
 */

part 'geography_master.g.dart';

@JsonSerializable()
class GeographyMaster {
  final String stateParentId;
  final String cityParentId;
  final String code;
  final String value;
  GeographyMaster({
    required this.stateParentId,
    required this.cityParentId,
    required this.code,
    required this.value,
  });

  GeographyMaster copyWith({
    String? stateParentId,
    String? cityParentId,
    String? code,
    String? value,
  }) {
    return GeographyMaster(
      stateParentId: stateParentId ?? this.stateParentId,
      cityParentId: cityParentId ?? this.cityParentId,
      code: code ?? this.code,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stateParentId': stateParentId,
      'cityParentId': cityParentId,
      'code': code,
      'value': value,
    };
  }

  factory GeographyMaster.fromMap(Map<String, dynamic> map) {
    return GeographyMaster(
      stateParentId: map['stateParentId'] as String,
      cityParentId: map['cityParentId'] as String,
      code: map['code'] as String,
      value: map['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$GeographyMasterToJson(this);

  factory GeographyMaster.fromJson(Map<String, dynamic> json) =>
      _$GeographyMasterFromJson(json);

  @override
  String toString() {
    return 'GeographyMaster(stateParentId: $stateParentId, cityParentId: $cityParentId, code: $code, value: $value)';
  }

  // @override
  // bool operator ==(covariant GeographyMaster other) {
  //   if (identical(this, other)) return true;

  //   return other.stateParentId == stateParentId &&
  //       other.cityParentId == cityParentId &&
  //       other.code == code &&
  //       other.value == value;
  // }

  @override
  int get hashCode {
    return stateParentId.hashCode ^
        cityParentId.hashCode ^
        code.hashCode ^
        value.hashCode;
  }
}
