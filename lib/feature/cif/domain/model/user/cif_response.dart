// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/* 
  @author     : GaneshKumar.B  13/05/2025
  @desc       : CIF Api Response Class
*/
import 'package:json_annotation/json_annotation.dart';
part 'cif_response.g.dart';

@JsonSerializable()
class CifResponse {
  final String? lleadtitle;
  final String? lleadfrstname;
  final String? lleadmidname;
  final String? lleadlastname;
  final String? lleademailid;
  final String? lleaddob;
  final String? lleadmobno;
  final String? lleadpanno;
  final String? lleadadharno;
  final String? lleadaddress;
  final String? lleadaddresslane1;
  final String? lleadaddresslane2;
  final String? lleadstate;
  final String? lleadcity;
  final String? lleadpinno;
  final String? lldCbsid;
  final String? lldGender;
  final String? lldFatherName;
  final String? lldMotherName;
  final String? lldReligion;
  final String? lldCaste;
  final String? lldMaritialStatus;
  final String? lleadResidentStatus;
  final String? depositCount;
  final String? depositAmount;
  final String? liabilityCount;
  final String? liabilityAmount;
  final String? cifFlag;
  final String? otheridno;
  CifResponse({
    this.lleadtitle,
    this.lleadfrstname,
    this.lleadmidname,
    this.lleadlastname,
    this.lleademailid,
    this.lleaddob,
    this.lleadmobno,
    this.lleadpanno,
    this.lleadadharno,
    this.lleadaddress,
    this.lleadaddresslane1,
    this.lleadaddresslane2,
    this.lleadstate,
    this.lleadcity,
    this.lleadpinno,
    this.lldCbsid,
    this.lldGender,
    this.lldFatherName,
    this.lldMotherName,
    this.lldReligion,
    this.lldCaste,
    this.lldMaritialStatus,
    this.lleadResidentStatus,
    this.depositCount,
    this.depositAmount,
    this.liabilityCount,
    this.liabilityAmount,
    this.cifFlag,
    this.otheridno,
  });

  CifResponse copyWith({
    String? lleadtitle,
    String? lleadfrstname,
    String? lleadmidname,
    String? lleadlastname,
    String? lleademailid,
    String? lleaddob,
    String? lleadmobno,
    String? lleadpanno,
    String? lleadadharno,
    String? lleadaddress,
    String? lleadaddresslane1,
    String? lleadaddresslane2,
    String? lleadstate,
    String? lleadcity,
    String? lleadpinno,
    String? lldCbsid,
    String? lldGender,
    String? lldFatherName,
    String? lldMotherName,
    String? lldReligion,
    String? lldCaste,
    String? lldMaritialStatus,
    String? lleadResidentStatus,
    String? depositCount,
    String? depositAmount,
    String? liabilityCount,
    String? liabilityAmount,
    String? cifFlag,
    String? otheridno,
  }) {
    return CifResponse(
      lleadtitle: lleadtitle ?? this.lleadtitle,
      lleadfrstname: lleadfrstname ?? this.lleadfrstname,
      lleadmidname: lleadmidname ?? this.lleadmidname,
      lleadlastname: lleadlastname ?? this.lleadlastname,
      lleademailid: lleademailid ?? this.lleademailid,
      lleaddob: lleaddob ?? this.lleaddob,
      lleadmobno: lleadmobno ?? this.lleadmobno,
      lleadpanno: lleadpanno ?? this.lleadpanno,
      lleadadharno: lleadadharno ?? this.lleadadharno,
      lleadaddress: lleadaddress ?? this.lleadaddress,
      lleadaddresslane1: lleadaddresslane1 ?? this.lleadaddresslane1,
      lleadaddresslane2: lleadaddresslane2 ?? this.lleadaddresslane2,
      lleadstate: lleadstate ?? this.lleadstate,
      lleadcity: lleadcity ?? this.lleadcity,
      lleadpinno: lleadpinno ?? this.lleadpinno,
      lldCbsid: lldCbsid ?? this.lldCbsid,
      lldGender: lldGender ?? this.lldGender,
      lldFatherName: lldFatherName ?? this.lldFatherName,
      lldMotherName: lldMotherName ?? this.lldMotherName,
      lldReligion: lldReligion ?? this.lldReligion,
      lldCaste: lldCaste ?? this.lldCaste,
      lldMaritialStatus: lldMaritialStatus ?? this.lldMaritialStatus,
      lleadResidentStatus: lleadResidentStatus ?? this.lleadResidentStatus,
      depositCount: depositCount ?? this.depositCount,
      depositAmount: depositAmount ?? this.depositAmount,
      liabilityCount: liabilityCount ?? this.liabilityCount,
      liabilityAmount: liabilityAmount ?? this.liabilityAmount,
      cifFlag: cifFlag ?? this.cifFlag,
      otheridno: otheridno ?? this.otheridno,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lleadtitle': lleadtitle,
      'lleadfrstname': lleadfrstname,
      'lleadmidname': lleadmidname,
      'lleadlastname': lleadlastname,
      'lleademailid': lleademailid,
      'lleaddob': lleaddob,
      'lleadmobno': lleadmobno,
      'lleadpanno': lleadpanno,
      'lleadadharno': lleadadharno,
      'lleadaddress': lleadaddress,
      'lleadaddresslane1': lleadaddresslane1,
      'lleadaddresslane2': lleadaddresslane2,
      'lleadstate': lleadstate,
      'lleadcity': lleadcity,
      'lleadpinno': lleadpinno,
      'lldCbsid': lldCbsid,
      'lldGender': lldGender,
      'lldFatherName': lldFatherName,
      'lldMotherName': lldMotherName,
      'lldReligion': lldReligion,
      'lldCaste': lldCaste,
      'lldMaritialStatus': lldMaritialStatus,
      'lleadResidentStatus': lleadResidentStatus,
      'depositCount': depositCount,
      'depositAmount': depositAmount,
      'liabilityCount': liabilityCount,
      'liabilityAmount': liabilityAmount,
      'cifFlag': cifFlag,
      'otheridno': otheridno,
    };
  }

  factory CifResponse.fromMap(Map<String, dynamic> map) {
    return CifResponse(
      lleadtitle:
          map['lleadtitle'] != null ? map['lleadtitle'] as String : null,
      lleadfrstname:
          map['lleadfrstname'] != null ? map['lleadfrstname'] as String : null,
      lleadmidname:
          map['lleadmidname'] != null ? map['lleadmidname'] as String : null,
      lleadlastname:
          map['lleadlastname'] != null ? map['lleadlastname'] as String : null,
      lleademailid:
          map['lleademailid'] != null ? map['lleademailid'] as String : null,
      lleaddob: map['lleaddob'] != null ? map['lleaddob'] as String : null,
      lleadmobno:
          map['lleadmobno'] != null ? map['lleadmobno'] as String : null,
      lleadpanno:
          map['lleadpanno'] != null ? map['lleadpanno'] as String : null,
      lleadadharno:
          map['lleadadharno'] != null ? map['lleadadharno'] as String : null,
      lleadaddress:
          map['lleadaddress'] != null ? map['lleadaddress'] as String : null,
      lleadaddresslane1:
          map['lleadaddresslane1'] != null
              ? map['lleadaddresslane1'] as String
              : null,
      lleadaddresslane2:
          map['lleadaddresslane2'] != null
              ? map['lleadaddresslane2'] as String
              : null,
      lleadstate:
          map['lleadstate'] != null ? map['lleadstate'] as String : null,
      lleadcity: map['lleadcity'] != null ? map['lleadcity'] as String : null,
      lleadpinno:
          map['lleadpinno'] != null ? map['lleadpinno'] as String : null,
      lldCbsid: map['lldCbsid'] != null ? map['lldCbsid'] as String : null,
      lldGender: map['lldGender'] != null ? map['lldGender'] as String : null,
      lldFatherName:
          map['lldFatherName'] != null ? map['lldFatherName'] as String : null,
      lldMotherName:
          map['lldMotherName'] != null ? map['lldMotherName'] as String : null,
      lldReligion:
          map['lldReligion'] != null ? map['lldReligion'] as String : null,
      lldCaste: map['lldCaste'] != null ? map['lldCaste'] as String : null,
      lldMaritialStatus:
          map['lldMaritialStatus'] != null
              ? map['lldMaritialStatus'] as String
              : null,
      lleadResidentStatus:
          map['lleadResidentStatus'] != null
              ? map['lleadResidentStatus'] as String
              : null,
      depositCount:
          map['depositCount'] != null ? map['depositCount'] as String : null,
      depositAmount:
          map['depositAmount'] != null ? map['depositAmount'] as String : null,
      liabilityCount:
          map['liabilityCount'] != null
              ? map['liabilityCount'] as String
              : null,
      liabilityAmount:
          map['liabilityAmount'] != null
              ? map['liabilityAmount'] as String
              : null,
      cifFlag: map['cifFlag'] != null ? map['cifFlag'] as String : null,
      otheridno: map['otheridno'] != null ? map['otheridno'] as String : null,
    );
  }

  Map<String, dynamic> toJson() => _$CifResponseToJson(this);

  factory CifResponse.fromJson(Map<String, dynamic> source) =>
      _$CifResponseFromJson(source);
  @override
  String toString() {
    return 'CifResponse(lleadtitle: $lleadtitle, lleadfrstname: $lleadfrstname, lleadmidname: $lleadmidname, lleadlastname: $lleadlastname, lleademailid: $lleademailid, lleaddob: $lleaddob, lleadmobno: $lleadmobno, lleadpanno: $lleadpanno, lleadadharno: $lleadadharno, lleadaddress: $lleadaddress, lleadaddresslane1: $lleadaddresslane1, lleadaddresslane2: $lleadaddresslane2, lleadstate: $lleadstate, lleadcity: $lleadcity, lleadpinno: $lleadpinno, lldCbsid: $lldCbsid, lldGender: $lldGender, lldFatherName: $lldFatherName, lldMotherName: $lldMotherName, lldReligion: $lldReligion, lldCaste: $lldCaste, lldMaritialStatus: $lldMaritialStatus, lleadResidentStatus: $lleadResidentStatus, depositCount: $depositCount, depositAmount: $depositAmount, liabilityCount: $liabilityCount, liabilityAmount: $liabilityAmount, cifFlag: $cifFlag, otheridno: $otheridno)';
  }

  @override
  bool operator ==(covariant CifResponse other) {
    if (identical(this, other)) return true;

    return other.lleadtitle == lleadtitle &&
        other.lleadfrstname == lleadfrstname &&
        other.lleadmidname == lleadmidname &&
        other.lleadlastname == lleadlastname &&
        other.lleademailid == lleademailid &&
        other.lleaddob == lleaddob &&
        other.lleadmobno == lleadmobno &&
        other.lleadpanno == lleadpanno &&
        other.lleadadharno == lleadadharno &&
        other.lleadaddress == lleadaddress &&
        other.lleadaddresslane1 == lleadaddresslane1 &&
        other.lleadaddresslane2 == lleadaddresslane2 &&
        other.lleadstate == lleadstate &&
        other.lleadcity == lleadcity &&
        other.lleadpinno == lleadpinno &&
        other.lldCbsid == lldCbsid &&
        other.lldGender == lldGender &&
        other.lldFatherName == lldFatherName &&
        other.lldMotherName == lldMotherName &&
        other.lldReligion == lldReligion &&
        other.lldCaste == lldCaste &&
        other.lldMaritialStatus == lldMaritialStatus &&
        other.lleadResidentStatus == lleadResidentStatus &&
        other.depositCount == depositCount &&
        other.depositAmount == depositAmount &&
        other.liabilityCount == liabilityCount &&
        other.liabilityAmount == liabilityAmount &&
        other.cifFlag == cifFlag &&
        other.otheridno == otheridno;
  }

  @override
  int get hashCode {
    return lleadtitle.hashCode ^
        lleadfrstname.hashCode ^
        lleadmidname.hashCode ^
        lleadlastname.hashCode ^
        lleademailid.hashCode ^
        lleaddob.hashCode ^
        lleadmobno.hashCode ^
        lleadpanno.hashCode ^
        lleadadharno.hashCode ^
        lleadaddress.hashCode ^
        lleadaddresslane1.hashCode ^
        lleadaddresslane2.hashCode ^
        lleadstate.hashCode ^
        lleadcity.hashCode ^
        lleadpinno.hashCode ^
        lldCbsid.hashCode ^
        lldGender.hashCode ^
        lldFatherName.hashCode ^
        lldMotherName.hashCode ^
        lldReligion.hashCode ^
        lldCaste.hashCode ^
        lldMaritialStatus.hashCode ^
        lleadResidentStatus.hashCode ^
        depositCount.hashCode ^
        depositAmount.hashCode ^
        liabilityCount.hashCode ^
        liabilityAmount.hashCode ^
        cifFlag.hashCode ^
        otheridno.hashCode;
  }
}
