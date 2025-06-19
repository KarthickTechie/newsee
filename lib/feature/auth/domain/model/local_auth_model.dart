// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
// lov.g.dart is a generated file by jsonserializable which having helper methods
// for json seri deseri
part 'local_auth_model.g.dart';

@JsonSerializable()
class LocalAuthModel {
  final String? status;
  final String? key;
  final String? signature;
  LocalAuthModel({
    this.status,
    this.key,
    this.signature,
  });

  LocalAuthModel copyWith({
    String? status,
    String? key,
    String? signature,
  }) {
    return LocalAuthModel(
      status: status ?? this.status,
      key: key ?? this.key,
      signature: signature ?? this.signature,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'key': key,
      'signature': signature,
    };
  }

  factory LocalAuthModel.fromMap(Map<String, dynamic> map) {
    return LocalAuthModel(
      status: map['status'] != null ? map['status'] as String : null,
      key: map['key'] != null ? map['key'] as String : null,
      signature: map['signature'] != null ? map['signature'] as String : null,
    );
  }

  Map<String, dynamic> toJson() => _$LocalAuthModelToJson(this);

  factory LocalAuthModel.fromJson(Map<String, dynamic> source) => _$LocalAuthModelFromJson(source);

  @override
  String toString() => 'LocalAuthModel(status: $status, key: $key, signature: $signature)';

  @override
  bool operator ==(covariant LocalAuthModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.key == key &&
      other.signature == signature;
  }

  @override
  int get hashCode => status.hashCode ^ key.hashCode ^ signature.hashCode;
}
