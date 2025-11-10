import 'dart:typed_data';
import 'package:newsee/AppData/DBConstants/table_key_auditlog.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/feature/audit_log/domain/modal/auditlog.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/simplecursor_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class AuditLogCrudRepo extends SimpleCrudRepo<AuditLog>
    with SimplecursorCrudRepo<AuditLog> {
  final Database _db;
  AuditLogCrudRepo(this._db);

  @override
  Future<int> save(AuditLog log) async {
    final data = log.toJson();
    if (data['requset'] != null) {
      final reqStr = data['requset'].toString();
      if (reqStr.isNotEmpty) {
        data['requset'] = reqStr;
      } else {
        data.remove('requset');
      }
    }

    return _db.insert(
      AuditLogSchema.tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> delete(AuditLog item) => throw UnimplementedError();
  @override
  Future<int> update(AuditLog item) => throw UnimplementedError();

  @override
  Future<List<AuditLog>> getById({required int id}) =>
      getByColumnName(
        columnName: AuditLogSchema.userid,
        columnValue: id.toString(),
      );

 

  @override
  Future<List<AuditLog>> getAll() async {
    final getData = await _db.query(
      AuditLogSchema.tableName,
      orderBy: '${AuditLogSchema.timestamp} DESC',
    );
    return getData.map(AuditLog.fromJson).toList();
  }

  @override
  Future<List<AuditLog>> getByColumnName({
    required String columnName,
    required String columnValue,
  }) async {
    final getRowData = await _db.query(
      AuditLogSchema.tableName,
      where: '$columnName = ?',
      whereArgs: [columnValue],
      orderBy: '${AuditLogSchema.timestamp} DESC',
    );
    return getRowData.map(AuditLog.fromJson).toList();
  }

  @override
  Future<List<AuditLog>> getByColumnNames({
    required List<String> columnNames,
    required List<String> columnValues,
  }) async {
    final where = queryBuilder(columnNames);
    final getData = await _db.query(
      AuditLogSchema.tableName,
      where: where,
      whereArgs: columnValues,
      orderBy: '${AuditLogSchema.timestamp} DESC',
    );
    return getData.map(AuditLog.fromJson).toList();
  }

  @override
  Future<int> deleteAll() {
    throw UnimplementedError();
  }
 
}
