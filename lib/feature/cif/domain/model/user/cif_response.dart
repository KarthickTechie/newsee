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
  CifResponse({
    required this.lleadtitle,
    required this.lleadfrstname,
    required this.lleadmidname,
    required this.lleadlastname,
    required this.lleademailid,
    required this.lleaddob,
    required this.lleadmobno,
    required this.lleadpanno,
    required this.lleadadharno,
    required this.lleadaddress,
    required this.lleadaddresslane1,
    required this.lleadaddresslane2,
    required this.lleadstate,
    required this.lleadcity,
    required this.lleadpinno,
    required this.lldCbsid,
    required this.lldGender,
    required this.lldFatherName,
    required this.lldMotherName,
    required this.lldReligion,
    required this.lldCaste,
    required this.lldMaritialStatus,
    required this.lleadResidentStatus,
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
    };
  }

  factory CifResponse.fromMap(Map<String, dynamic> map) {
    return CifResponse(
      lleadtitle: map['lleadtitle'] as String,
      lleadfrstname: map['lleadfrstname'] as String,
      lleadmidname: map['lleadmidname'] as String,
      lleadlastname: map['lleadlastname'] as String,
      lleademailid: map['lleademailid'] as String,
      lleaddob: map['lleaddob'] as String,
      lleadmobno: map['lleadmobno'] as String,
      lleadpanno: map['lleadpanno'] as String,
      lleadadharno: map['lleadadharno'] as String,
      lleadaddress: map['lleadaddress'] as String,
      lleadaddresslane1: map['lleadaddresslane1'] as String,
      lleadaddresslane2: map['lleadaddresslane2'] as String,
      lleadstate: map['lleadstate'] as String,
      lleadcity: map['lleadcity'] as String,
      lleadpinno: map['lleadpinno'] as String,
      lldCbsid: map['lldCbsid'] as String,
      lldGender: map['lldGender'] as String,
      lldFatherName: map['lldFatherName'] as String,
      lldMotherName: map['lldMotherName'] as String,
      lldReligion: map['lldReligion'] as String,
      lldCaste: map['lldCaste'] as String,
      lldMaritialStatus: map['lldMaritialStatus'] as String,
      lleadResidentStatus: map['lleadResidentStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$CifResponseToJson(this);

  factory CifResponse.fromJson(Map<String, dynamic> source) =>
      _$CifResponseFromJson(source);

  @override
  String toString() {
    return 'CifResponseModel(lleadtitle: $lleadtitle, lleadfrstname: $lleadfrstname, lleadmidname: $lleadmidname, lleadlastname: $lleadlastname, lleademailid: $lleademailid, lleaddob: $lleaddob, lleadmobno: $lleadmobno, lleadpanno: $lleadpanno, lleadadharno: $lleadadharno, lleadaddress: $lleadaddress, lleadaddresslane1: $lleadaddresslane1, lleadaddresslane2: $lleadaddresslane2, lleadstate: $lleadstate, lleadcity: $lleadcity, lleadpinno: $lleadpinno, lldCbsid: $lldCbsid, lldGender: $lldGender, lldFatherName: $lldFatherName, lldMotherName: $lldMotherName, lldReligion: $lldReligion, lldCaste: $lldCaste, lldMaritialStatus: $lldMaritialStatus, lleadResidentStatus: $lleadResidentStatus)';
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
        other.lleadResidentStatus == lleadResidentStatus;
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
        lleadResidentStatus.hashCode;
  }
}
