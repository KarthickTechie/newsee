// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CropDetailsModal {
  final String lasSeqno;
  final String? lasSeason;
  final String? lasCrop;
  final String? lasAreaofculti;
  final int? lasEligibleamt;
  final String? lasTypOfLand;
  final String? lasScaloffin;
  final int? lasReqScaloffin;
  final bool? notifiedCropFlag;
  final String? lasPrePerAcre;
  final String? lasPreToCollect;
  CropDetailsModal({
    this.lasSeqno = '0',
    this.lasSeason,
    this.lasCrop,
    this.lasAreaofculti,
    this.lasEligibleamt,
    this.lasTypOfLand,
    this.lasScaloffin,
    this.lasReqScaloffin,
    this.notifiedCropFlag,
    this.lasPrePerAcre,
    this.lasPreToCollect,
  });

  CropDetailsModal copyWith({
    String? lasSeqno,
    String? lasSeason,
    String? lasCrop,
    String? lasAreaofculti,
    int? lasEligibleamt,
    String? lasTypOfLand,
    String? lasScaloffin,
    int? lasReqScaloffin,
    bool? notifiedCropFlag,
    String? lasPrePerAcre,
    String? lasPreToCollect,
  }) {
    return CropDetailsModal(
      lasSeqno: lasSeqno ?? this.lasSeqno,
      lasSeason: lasSeason ?? this.lasSeason,
      lasCrop: lasCrop ?? this.lasCrop,
      lasAreaofculti: lasAreaofculti ?? this.lasAreaofculti,
      lasEligibleamt: lasEligibleamt ?? this.lasEligibleamt,
      lasTypOfLand: lasTypOfLand ?? this.lasTypOfLand,
      lasScaloffin: lasScaloffin ?? this.lasScaloffin,
      lasReqScaloffin: lasReqScaloffin ?? this.lasReqScaloffin,
      notifiedCropFlag: notifiedCropFlag ?? this.notifiedCropFlag,
      lasPrePerAcre: lasPrePerAcre ?? this.lasPrePerAcre,
      lasPreToCollect: lasPreToCollect ?? this.lasPreToCollect,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lasSeqno': lasSeqno,
      'lasSeason': lasSeason,
      'lasCrop': lasCrop,
      'lasAreaofculti': lasAreaofculti,
      'lasEligibleamt': lasEligibleamt,
      'lasTypOfLand': lasTypOfLand,
      'lasScaloffin': lasScaloffin,
      'lasReqScaloffin': lasReqScaloffin,
      'notifiedCropFlag': notifiedCropFlag,
      'lasPrePerAcre': lasPrePerAcre,
      'lasPreToCollect': lasPreToCollect,
    };
  }

  Map<String, dynamic> toForm() {
    return <String, dynamic>{
      'lasSeqno': lasSeqno.toString(),
      'lasSeason': lasSeason,
      'lasCrop': lasCrop,
      'lasAreaofculti': lasAreaofculti,
      'lasEligibleamt': lasEligibleamt,
      'lasTypOfLand': lasTypOfLand,
      'lasScaloffin': lasScaloffin,
      'lasReqScaloffin': lasReqScaloffin.toString(),
      'notifiedCropFlag': notifiedCropFlag,
      'lasPrePerAcre': lasPrePerAcre,
      'lasPreToCollect': lasPreToCollect,
    };
  }

  factory CropDetailsModal.fromMap(Map<String, dynamic> map) {
    return CropDetailsModal(
      lasSeqno: map['lasSeqno'],
      lasSeason: map['lasSeason'] != null ? map['lasSeason'] as String : null,
      lasCrop: map['lasCrop'] != null ? map['lasCrop'] as String : null,
      lasAreaofculti: map['lasAreaofculti'] != null ? map['lasAreaofculti'] as String : null,
      lasEligibleamt: map['lasReqScaloffin'] != null ? map['lasReqScaloffin'] as int : null,
      lasTypOfLand: map['lasTypOfLand'] != null ? map['lasTypOfLand'] as String : null,
      lasScaloffin: map['lasScaloffin'] != null ? map['lasScaloffin'] as String : null,
      lasReqScaloffin: map['lasReqScaloffin'] != null ? map['lasReqScaloffin'] as int : null,
      notifiedCropFlag: map['notifiedCropFlag'] != null ? map['notifiedCropFlag'] as bool : null,
      lasPrePerAcre: map['lasPrePerAcre'] != null ? map['lasPrePerAcre'] as String : null,
      lasPreToCollect: map['lasPreToCollect'] != null ? map['lasPreToCollect'] as String : null,
    );
  }

  factory CropDetailsModal.fromForm(Map<String, dynamic> form) {
    return CropDetailsModal(
      lasSeqno: form['lasSeqno'] ?? '0',
      lasSeason: form['lasSeason'] ?? '',
      lasCrop: form['lasCrop'] ?? '',
      lasAreaofculti: form['lasAreaofculti'] ?? '',
      lasEligibleamt: int.parse(form['lasReqScaloffin']),
      lasTypOfLand: form['lasTypOfLand'] ?? '',
      lasScaloffin: form['lasScaloffin'] ?? '',
      lasReqScaloffin: int.parse(form['lasReqScaloffin']),
      notifiedCropFlag: form['notifiedCropFlag'] ?? false,
      lasPrePerAcre: form['lasPrePerAcre'] ?? '',
      lasPreToCollect: form['lasPreToCollect'] ?? '',
    );
  }

  factory CropDetailsModal.fromGetApi(Map<String, dynamic> map) {
    return CropDetailsModal(
      lasSeqno: map['lasSeqno']?.toString() ?? '0',
      lasSeason: map['lasSeason']?.toString() ?? '',
      lasCrop: map['lasCrop']?.toString() ?? '',
      lasAreaofculti: map['lasAreaofculti']?.toString() ?? '',
      lasEligibleamt: map['lasReqScaloffin'] != null ? map['lasReqScaloffin'] as int : null,
      lasTypOfLand: map['lasTypOfLand'] != null ? map['lasTypOfLand'] as String : null,
      lasScaloffin: map['lasScaloffin']?.toString() ?? '',
      lasReqScaloffin: map['lasReqScaloffin'] != null ? map['lasReqScaloffin'] as int : null,
      notifiedCropFlag: 
        map['notifiedCropFlag'] != null ? 
        (map['notifiedCropFlag'] == 'true' ? true : false) : null,
      lasPrePerAcre: map['lasPrePerAcre']?.toString() ?? '',
      lasPreToCollect: map['lasPreToCollect']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CropDetailsModal.fromJson(String source) => CropDetailsModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CropDetailsModal(lasSeason: $lasSeason, lasCrop: $lasCrop, lasAreaofculti: $lasAreaofculti, lasEligibleamt: $lasEligibleamt, lasTypOfLand: $lasTypOfLand, lasScaloffin: $lasScaloffin, lasReqScaloffin: $lasReqScaloffin, notifiedCropFlag: $notifiedCropFlag, lasPrePerAcre: $lasPrePerAcre, lasPreToCollect: $lasPreToCollect)';
  }

  @override
  bool operator ==(covariant CropDetailsModal other) {
    if (identical(this, other)) return true;
  
    return 
      other.lasSeason == lasSeason &&
      other.lasCrop == lasCrop &&
      other.lasAreaofculti == lasAreaofculti &&
      other.lasEligibleamt == lasEligibleamt &&
      other.lasTypOfLand == lasTypOfLand &&
      other.lasScaloffin == lasScaloffin &&
      other.lasReqScaloffin == lasReqScaloffin &&
      other.notifiedCropFlag == notifiedCropFlag &&
      other.lasPrePerAcre == lasPrePerAcre &&
      other.lasPreToCollect == lasPreToCollect;
  }

  @override
  int get hashCode {
    return lasSeason.hashCode ^
      lasCrop.hashCode ^
      lasAreaofculti.hashCode ^
      lasEligibleamt.hashCode ^
      lasTypOfLand.hashCode ^
      lasScaloffin.hashCode ^
      lasReqScaloffin.hashCode ^
      notifiedCropFlag.hashCode ^
      lasPrePerAcre.hashCode ^
      lasPreToCollect.hashCode;
  }
}
