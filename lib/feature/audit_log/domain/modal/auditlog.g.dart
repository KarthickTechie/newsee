// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditlog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
  userid: json['userid'] as String,
  timestamp: json['timestamp'] as String,
  deviceId: json['deviceId'] as String,
  request: json['requset'] as String,
);

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
  'userid': instance.userid,
  'timestamp': instance.timestamp,
  'deviceId': instance.deviceId,
  'requset':instance.request
};
