import 'package:newsee/AppData/DBConstants/table_key_localbiometric.dart';
import 'package:newsee/feature/auth/domain/model/local_auth_model.dart';
import 'package:newsee/feature/masters/domain/repository/simple_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalAuthMasterRepo extends SimpleCrudRepo<LocalAuthModel> {
  final Database _db;
  LocalAuthMasterRepo(this._db);

  @override
  Future<int> save(LocalAuthModel o) async {
    return _db.transaction((txn) async {
      return await txn.insert(
        TableKeyLocalBiometric.tableName,
        o.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> delete(LocalAuthModel o) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<int> update(LocalAuthModel o) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<List<LocalAuthModel>> getAll() async {
    final List<Map<String, dynamic>> data = await _db.query(
      TableKeyLocalBiometric.tableName,
      orderBy: "id DESC",
    );
    return List.generate(data.length, (index) => LocalAuthModel.fromJson(data[index]));
  }

}