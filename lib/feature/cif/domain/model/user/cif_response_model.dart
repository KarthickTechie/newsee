// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

/* 
@author     : Gayathri.B  04/05/2025
@desc       : Data class for CIF Rest API response json serialization
              json serialization fromJSON and deserialization toJson
              will be delegated to auth_respose_model.g.dart 
              which is a generated file by running 
              dart run build_runner run command
 */
import 'package:json_annotation/json_annotation.dart';
part 'cif_response_model.g.dart';

@JsonSerializable()
class CifResponseModel {
  final String staffFlag;
  final String cifFlag;
  final bool CBS;
  final String resitype;
  final Map<String, dynamic> lpretLeadDetails;
  final String remarks;
  final bool shgFlag;

  CifResponseModel({
    required this.staffFlag,
    required this.cifFlag,
    required this.CBS,
    required this.resitype,
    required this.lpretLeadDetails,
    required this.remarks,
    required this.shgFlag,
  });

  CifResponseModel copyWith({
    String? staffFlag,
    String? cifFlag,
    bool? CBS,
    String? resitype,
    Map<String, dynamic>? lpretLeadDetails,
    String? remarks,
    bool? shgFlag,
  }) {
    return CifResponseModel(
      staffFlag: staffFlag ?? this.staffFlag,
      cifFlag: cifFlag ?? this.cifFlag,
      CBS: CBS ?? this.CBS,
      resitype: resitype ?? this.resitype,
      lpretLeadDetails: lpretLeadDetails ?? this.lpretLeadDetails,
      remarks: remarks ?? this.remarks,
      shgFlag: shgFlag ?? this.shgFlag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staffFlag': staffFlag,
      'cifFlga': cifFlag,
      'CBS': CBS,
      'resitype': resitype,
      'lpretLeadDetails': lpretLeadDetails,
      'remarks': remarks,
      'shgFlag': shgFlag,
    };
  }

  factory CifResponseModel.fromMap(Map<String, dynamic> map) {
    return CifResponseModel(
      staffFlag: map['staffFlag'] as String,
      cifFlag: map['cifFlga'] as String,
      CBS: map['CBS'] as bool,
      resitype: map['resitype'] as String,
      lpretLeadDetails: Map<String, dynamic>.from(
        (map['lpretLeadDetails'] as Map<String, dynamic>),
      ),
      remarks: map['remarks'] as String,
      shgFlag: map['shgFlag'] as bool,
    );
  }

  Map<String, dynamic> toJson() => _$CifResponseModelToJson(this);

  factory CifResponseModel.fromJson(Map<String, dynamic> source) =>
      _$CifResponseModelFromJson(source);

  @override
  String toString() {
    return 'CifResponseModel(staffFlag: $staffFlag, cifFlga: $cifFlag, CBS: $CBS, resitype: $resitype, lpretLeadDetails: $lpretLeadDetails, remarks: $remarks, shgFlag: $shgFlag)';
  }

  @override
  bool operator ==(covariant CifResponseModel other) {
    if (identical(this, other)) return true;

    return other.staffFlag == staffFlag &&
        other.cifFlag == cifFlag &&
        other.CBS == CBS &&
        other.resitype == resitype &&
        mapEquals(other.lpretLeadDetails, lpretLeadDetails) &&
        other.remarks == remarks &&
        other.shgFlag == shgFlag;
  }

  @override
  int get hashCode {
    return staffFlag.hashCode ^
        cifFlag.hashCode ^
        CBS.hashCode ^
        resitype.hashCode ^
        lpretLeadDetails.hashCode ^
        remarks.hashCode ^
        shgFlag.hashCode;
  }
}
