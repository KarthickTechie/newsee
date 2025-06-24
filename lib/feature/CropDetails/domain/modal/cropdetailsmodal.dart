// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CropDetailsModal {
  final String? season;
  final String? nameOfCrop;
  final String? acrescultivated;
  final String? typeofland;
  final String? scaleoffincance;
  final String? reqasperscaleoffinace;
  final bool? notifiedcrop;
  final String? premiumperacre;
  final String? premiumcollected;
  CropDetailsModal({
    this.season,
    this.nameOfCrop,
    this.acrescultivated,
    this.typeofland,
    this.scaleoffincance,
    this.reqasperscaleoffinace,
    this.notifiedcrop,
    this.premiumperacre,
    this.premiumcollected,
  });

  CropDetailsModal copyWith({
    String? season,
    String? nameOfCrop,
    String? acrescultivated,
    String? typeofland,
    String? scaleoffincance,
    String? reqasperscaleoffinace,
    bool? notifiedcrop,
    String? premiumperacre,
    String? premiumcollected,
  }) {
    return CropDetailsModal(
      season: season ?? this.season,
      nameOfCrop: nameOfCrop ?? this.nameOfCrop,
      acrescultivated: acrescultivated ?? this.acrescultivated,
      typeofland: typeofland ?? this.typeofland,
      scaleoffincance: scaleoffincance ?? this.scaleoffincance,
      reqasperscaleoffinace: reqasperscaleoffinace ?? this.reqasperscaleoffinace,
      notifiedcrop: notifiedcrop ?? this.notifiedcrop,
      premiumperacre: premiumperacre ?? this.premiumperacre,
      premiumcollected: premiumcollected ?? this.premiumcollected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'season': season,
      'nameOfCrop': nameOfCrop,
      'acrescultivated': acrescultivated,
      'typeofland': typeofland,
      'scaleoffincance': scaleoffincance,
      'reqasperscaleoffinace': reqasperscaleoffinace,
      'notifiedcrop': notifiedcrop,
      'premiumperacre': premiumperacre,
      'premiumcollected': premiumcollected,
    };
  }

  factory CropDetailsModal.fromMap(Map<String, dynamic> map) {
    return CropDetailsModal(
      season: map['season'] != null ? map['season'] as String : null,
      nameOfCrop: map['nameOfCrop'] != null ? map['nameOfCrop'] as String : null,
      acrescultivated: map['acrescultivated'] != null ? map['acrescultivated'] as String : null,
      typeofland: map['typeofland'] != null ? map['typeofland'] as String : null,
      scaleoffincance: map['scaleoffincance'] != null ? map['scaleoffincance'] as String : null,
      reqasperscaleoffinace: map['reqasperscaleoffinace'] != null ? map['reqasperscaleoffinace'] as String : null,
      notifiedcrop: map['notifiedcrop'] != null ? map['notifiedcrop'] as bool : null,
      premiumperacre: map['premiumperacre'] != null ? map['premiumperacre'] as String : null,
      premiumcollected: map['premiumcollected'] != null ? map['premiumcollected'] as String : null,
    );
  }

  factory CropDetailsModal.fromForm(Map<String, dynamic> form) {
    return CropDetailsModal(
      season: form['season'] ?? '',
      nameOfCrop: form['nameOfCrop'] ?? '',
      acrescultivated: form['acrescultivated'] ?? '',
      typeofland: form['typeofland'] ?? '',
      scaleoffincance: form['scaleoffincance'] ?? '',
      reqasperscaleoffinace: form['reqasperscaleoffinace'] ?? '',
      notifiedcrop: form['notifiedcrop'] ?? false,
      premiumperacre: form['premiumperacre'] ?? '',
      premiumcollected: form['premiumcollected'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CropDetailsModal.fromJson(String source) => CropDetailsModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CropDetailsModal(season: $season, cropname: $nameOfCrop, acrescultivated: $acrescultivated, typeofland: $typeofland, scaleoffincance: $scaleoffincance, reqasperscaleoffinace: $reqasperscaleoffinace, notifiedcrop: $notifiedcrop, premiumperacre: $premiumperacre, premiumcollected: $premiumcollected)';
  }

  @override
  bool operator ==(covariant CropDetailsModal other) {
    if (identical(this, other)) return true;
  
    return 
      other.season == season &&
      other.nameOfCrop == nameOfCrop &&
      other.acrescultivated == acrescultivated &&
      other.typeofland == typeofland &&
      other.scaleoffincance == scaleoffincance &&
      other.reqasperscaleoffinace == reqasperscaleoffinace &&
      other.notifiedcrop == notifiedcrop &&
      other.premiumperacre == premiumperacre &&
      other.premiumcollected == premiumcollected;
  }

  @override
  int get hashCode {
    return season.hashCode ^
      nameOfCrop.hashCode ^
      acrescultivated.hashCode ^
      typeofland.hashCode ^
      scaleoffincance.hashCode ^
      reqasperscaleoffinace.hashCode ^
      notifiedcrop.hashCode ^
      premiumperacre.hashCode ^
      premiumcollected.hashCode;
  }
}
