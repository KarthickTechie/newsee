/* 
@author   : karthick.d  11/06/2025
@desc     : class to keep string contants for geographymaster table 


 */
import 'package:flutter/material.dart';

@immutable
class TableKeyLocalBiometric {
  TableKeyLocalBiometric._();

  static const String tableName = 'localbiometric';
  static const String _idColumn = 'id';
  static const String _status = 'status';
  static const String _authKey = 'key';
  static const String _authSignature = 'signature';

  static const String createTableQuery = '''
                CREATE TABLE IF NOT EXISTS ${TableKeyLocalBiometric.tableName}(
            ${TableKeyLocalBiometric._idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${TableKeyLocalBiometric._status} TEXT,
            ${TableKeyLocalBiometric._authKey} TEXT,
            ${TableKeyLocalBiometric._authSignature} TEXT
                      )

     ''';

  static String get status => _status;
  static String get authKey => _authKey;
  static String get authSignature => _authSignature;
}
