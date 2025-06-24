import 'package:newsee/AppData/DBConstants/table_key_masterversion.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

class MasterversionCrudRepo extends SimpleCrudRepo<MasterVersion> {
  final Database _db;

  MasterversionCrudRepo(this._db);

  @override
  Future<int> delete(MasterVersion o) {
    throw UnimplementedError();
  }

  @override
  Future<int> save(MasterVersion o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeyMasterversion.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> update(MasterVersion o) async {
    return await _db.transaction((txn) async {
      return await txn.update(
        TableKeyMasterversion.tableName,
        o.toMap(),
        where: 'mastername = ?',
        whereArgs: [o.mastername],
      );
    });
  }

  @override
  Future<List<MasterVersion>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeyMasterversion.tableName,
      orderBy: "id DESC",
    );
    return List.generate(
      data.length,
      (index) => MasterVersion.fromMap(data[index]),
    );
  }
}
