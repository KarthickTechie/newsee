/*
@author     : akshayaa.p 28/05/2025
@desc       : A class that contains string constants representing the column names 
              used in the 'masterversion' table of the local SQLite database.
@params     : {String mastername} - The name of the master data.
              {String version} - The version number of the master data fetched from the server.
              {String status} - Indicates the download status of the master data.
                                 - 'success' : data downloaded and saved in db.
                                 - 'failure' : download failed.S
*/

import 'package:flutter/material.dart';

class TableKeyMasterversion {
  TableKeyMasterversion._();

  static const String tableName = 'masterversion';
  static const String idColumn = 'id';
  static const String mastername = 'mastername';
  static const String version = 'version';
  static const String status = 'status';

  static const String createTableQuery = '''
            CREATE TABLE IF NOT EXISTS $tableName(
            $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $mastername TEXT,
            $version TEXT,
            $status TEXT
            )
            ''';
}
