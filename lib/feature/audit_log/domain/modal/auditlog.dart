// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'auditlog.g.dart';



@JsonSerializable()
class AuditLog {
  final String userid;
  final String timestamp;        
  final String deviceId;
  final String request;

  AuditLog({
    required this.userid,
    required this.timestamp,
    required this.deviceId,
    required this.request,

  });
 

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuditLogToJson(this);

  @override
  String toString() {
    return 'AuditLog(userid: $userid, timestamp: $timestamp, deviceId: $deviceId, request: $request)';
  }

  @override
  bool operator ==(covariant AuditLog other) {
    if (identical(this, other)) return true;
  
    return 
      other.userid == userid &&
      other.timestamp == timestamp &&
      other.deviceId == deviceId &&
      other.request == request;
  }

  @override
  int get hashCode {
    return userid.hashCode ^
      timestamp.hashCode ^
      deviceId.hashCode ^
      request.hashCode;
  }
}
