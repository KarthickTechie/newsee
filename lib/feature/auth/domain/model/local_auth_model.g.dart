// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalAuthModel _$LocalAuthModelFromJson(Map<String, dynamic> json) =>
    LocalAuthModel(
      status: json['status'] as String?,
      key: json['key'] as String?,
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$LocalAuthModelToJson(LocalAuthModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'key': instance.key,
      'signature': instance.signature,
    };
