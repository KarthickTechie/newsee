/* 
@author   : karthick.d  26/05/2025
@desc     : class to keep string contants for products table 
@param    :                 
                "prdCode": "232",
                "prdDesc": "Krishi Saral Term Loan",
                "prdamtFromRange": "1",
                "prdamtToRange": "100000000",
                "prdMainCat": "347",
                "prdTenorFrom": "0",
                "prdTenorTo": "60",
                "prdMoratoriumMax": "12",
                "prdSubCat": "348",


 */
import 'package:flutter/material.dart';

@immutable
class TableKeysProductMaster {
  TableKeysProductMaster._();

  static const String tableName = 'productmaster';
  static const String idColumn = 'id';
  static const String productCode = 'prdCode';
  static const String productDescription = 'prdDesc';
  static const String amountFromRange = 'prdamtFromRange';
  static const String amountToRange = 'prdamtToRange';
  static const String mainCatId = 'prdMainCat';
  static const String subCatId = 'prdSubCat';
  static const String tenorFrom = 'prdTenorFrom';
  static const String tenorTo = 'prdTenorTo';
  static const String moratoriam = "prdMoratoriumMax";
  static const String version = 'version';

  static const String createTableQuery = '''
                    CREATE TABLE IF NOT EXISTS $tableName(
            $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $productCode TEXT,
            $productDescription TEXT,
            $amountFromRange TEXT,
            $amountToRange TEXT,
            $mainCatId TEXT,
            $subCatId TEXT,
            $tenorFrom TEXT,
            $tenorTo TEXT,
            $moratoriam TEXT,
            $version TEXT
)
  ''';
}
