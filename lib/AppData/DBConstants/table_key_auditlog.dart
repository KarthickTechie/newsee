/* 
@author   : gayathri.b  22/10/2025
@desc     : class to keep string contants for audit log table 

 */

class AuditLogSchema {
  AuditLogSchema._();
  static String tableName = 'auditlog';
  static String _idColumn = 'id';
  static String userid = 'userid';
  static String timestamp = 'timestamp';
  static String deviceId = 'deviceId';
  static String requset = 'requset';

  static final String createTableQuery = '''
CREATE TABLE IF NOT EXISTS $tableName(
            ${AuditLogSchema._idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${AuditLogSchema.userid} TEXT,
            ${AuditLogSchema.timestamp} TEXT,
            ${AuditLogSchema.deviceId} TEXT,
            ${AuditLogSchema.requset} TEXT
)
  ''';
}
