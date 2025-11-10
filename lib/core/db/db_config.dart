/* 
@author     : karthick.d  26/05/2025
@desc       : configure sqlite database 
              create database return db instance
              dbinstance 
 */

import 'package:newsee/AppData/DBConstants/table_key_auditlog.dart';
import 'package:newsee/AppData/DBConstants/dbconstants.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/DBConstants/table_key_products.dart';
import 'package:newsee/AppData/DBConstants/table_key_productschema.dart';
import 'package:newsee/AppData/DBConstants/table_key_statecitymaster.dart';
import 'package:newsee/AppData/DBConstants/table_keys_productmaster.dart';
import 'package:newsee/AppData/DBConstants/table_key_masterversion.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConfig {
  static final DBConfig _instance = DBConfig._();
  factory DBConfig() => _instance;
  static Database? _database;

  DBConfig._() {
    _initDB();
  }

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbKeys.dbName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    try {
      // create table sequentially

      /* 
      @modified  :  karthick.d  11/06/2025
      @desc      :  statecitymastertable create query deleted 
                    (due to ease of processing , statecitymaster respons is changed)
                    so statecitymaster.dart become obsolete

      */
      await db.execute(TableKeysLov.createTableQuery);
      printTableCreateSuccess(TableKeysLov.tableName);
      await db.execute(TableKeysProductSchema.createTableQuery);
      printTableCreateSuccess(TableKeysProductSchema.tableName);
      await db.execute(TableKeysProducts.createTableQuery);
      printTableCreateSuccess(TableKeysProducts.tableName);
      await db.execute(TableKeysProductMaster.createTableQuery);
      printTableCreateSuccess(TableKeysProductMaster.tableName);
      await db.execute(TableKeyMasterversion.createTableQuery);
      printTableCreateSuccess(TableKeyMasterversion.tableName);
      await db.execute(TableKeysGeographyMaster.createTableQuery);
      printTableCreateSuccess(TableKeysGeographyMaster.tableName);
      await db.execute(AuditLogSchema.createTableQuery);
      printTableCreateSuccess(AuditLogSchema.tableName);
    } catch (e) {
      // db creation failure - > log u r exception

      print('create table error => ${e.toString()} ');
    }
  }

  void printTableCreateSuccess(String tableName) {
    print('create table success => $tableName ');
  }
}
