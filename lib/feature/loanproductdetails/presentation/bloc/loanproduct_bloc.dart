/* 
@author    : karthick.d 05/06/2025
@desc      : LoanproductBloc - encapsulates business logic of loanproducts page
@param     : 
 */
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_products.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/query_builder.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/product_schema_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/products_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './loanproduct_event.dart';
part 'loanproduct_state.dart';

class LoanproductBloc extends Bloc<LoanproductEvent, LoanproductState> {
  LoanproductBloc() : super(LoanproductState.init()) {
    on<LoanproductInit>(onLoanProductInit);
    on<LoanProductDropdownChange>(onLoanProductDropdownChange);
    on<ResetShowBottomSheet>(onResetShowBottomSheet);
    on<SaveLoanProduct>(onSaveLoanProduct);
  }

  // set the initial data for Type Of loan Dropdown

  Future<void> onLoanProductInit(LoanproductInit event, Emitter emit) async {
    // initiate the dataset for typeofloan
    String leadId = event.loanproductState.leadId ?? '';
    Database db = await DBConfig().database;
    if (leadId.isEmpty) {
      List<ProductSchema> productSchemaList =
          await ProductSchemaCrudRepo(db).getAll();
      print('productSchemaList from DB => ${productSchemaList.length}');
      emit(state.copyWith(productSchemeList: productSchemaList));
    }
  }

  // event handler for drowdown change - main product and sub product
  // fetches respective data and return new LoanProductState

  Future<void> onLoanProductDropdownChange(
    LoanProductDropdownChange event,
    Emitter emit,
  ) async {
    Database db = await DBConfig().database;
    String productSchemeId = "";
    if (event.field is ProductSchema) {
      await onChangeProductScheme(event, productSchemeId, db, emit);
    } else if (event.field is Product) {
      Product selectedProduct = event.field as Product;
      String mainCatId = selectedProduct.lsfFacParentId;
      String subCatId = selectedProduct.lsfFacId;
      print('subCatId => $subCatId');
      await onChangeProduct(event, mainCatId, subCatId, db, emit);
    }
  }

  // this event is triggered for setting bottomsheet show status
  // on tap of bottomsheet list items ,

  Future<void> onResetShowBottomSheet(
    ResetShowBottomSheet event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        selectedProduct: event.selectedProduct,
        showBottomSheet: false,
      ),
    );
  }

  Future<void> onChangeProductScheme(
    LoanProductDropdownChange<dynamic> event,
    String productSchemeId,
    Database db,
    Emitter<dynamic> emit,
  ) async {
    ProductSchema loanschema = event.field as ProductSchema;
    productSchemeId = loanschema.optionId;
    print(
      'LoanproductBloc::onLoanProductDropdownChange => productSchemeId : $productSchemeId',
    );
    List<Lov> listOfLov = await LovCrudRepo(db).getByColumnNames(
      columnNames: ['Header', 'optvalue'],
      columnValues: ['AgriProductType', productSchemeId],
    );
    final optCode = listOfLov.first.optCode;
    print('listOfLov.first.optCode => $optCode');

    List<Product> mainCategoryList = await ProductsCrudRepo(
      db,
    ).getByColumnName(columnName: 'lsfFacType', columnValue: optCode);
    print('mainCategoryList => $mainCategoryList');
    if (state.status == SaveStatus.success) {
      emit(
        state.copyWith(
          mainCategoryList: mainCategoryList,
          selectedProduct: null,
          status: SaveStatus.update,
        ),
      );
    } else {
      emit(
        state.copyWith(
          mainCategoryList: mainCategoryList,
          selectedProduct: null,
        ),
      );
    }
  }

  Future<void> onChangeProduct(
    LoanProductDropdownChange<dynamic> event,
    String mainCategoryId,
    String subCategoryId,
    Database db,
    Emitter<dynamic> emit,
  ) async {
    Product product = event.field as Product;

    // if mainCategoryId is zero then maincategory is selected
    // subcategoryproducts will be fetched
    if (mainCategoryId == "0") {
      // get all subcategory list
      List<Product> subCategoryList = await ProductsCrudRepo(
        db,
      ).getByColumnName(
        columnName: 'lsfFacParentId',
        columnValue: subCategoryId,
      );
      print('subCategoryList => $subCategoryList');
      emit(
        state.copyWith(subCategoryList: subCategoryList, selectedProduct: null),
      );
    } else {
      // mainCategoryId != 0 and subCategoryId
      List<String> columnNames = ['prdMainCat', 'prdSubCat'];
      List<String> columsValues = [mainCategoryId, subCategoryId];

      List<ProductMaster> productMasterList = await ProductMasterCrudRepo(
        db,
      ).getByColumnNames(columnNames: columnNames, columnValues: columsValues);
      print('productMasterList => $productMasterList');
      LoanproductState.init();
      emit(
        state.copyWith(
          productmasterList: productMasterList,
          showBottomSheet: true,
        ),
      );
    }
  }

  Future<void> onSaveLoanProduct(SaveLoanProduct event, Emitter emit) async {
    // emit(state.copyWith(status: SaveStatus.loading));
    if (state.selectedProduct != null) {
      String typeOfLoan = event.choosenProduct['typeofloan'] as String;
      String mainCategory = event.choosenProduct['maincategory'] as String;
      String subCategory = event.choosenProduct['subcategory'] as String;

      ProductSchema productSchema = state.productSchemeList.firstWhere(
        (p) => p.optionValue == typeOfLoan,
      );
      Product mainProduct = state.mainCategoryList.firstWhere(
        (p) => p.lsfFacId == mainCategory,
      );
      Product subProduct = state.subCategoryList.firstWhere(
        (p) => p.lsfFacId == subCategory,
      );
      if (state.status == SaveStatus.init) {
        emit(
          state.copyWith(
            selectedProductScheme: productSchema,
            selectedMainCategory: mainProduct,
            selectedSubCategoryList: subProduct,
            selectedProduct: state.selectedProduct,
            status: SaveStatus.success,
          ),
        );
      } else if (state.status == SaveStatus.update) {
        emit(
          state.copyWith(
            selectedProductScheme: productSchema,
            selectedMainCategory: mainProduct,
            selectedSubCategoryList: subProduct,
            selectedProduct: state.selectedProduct,
            status: SaveStatus.success,
          ),
        );
      }
    }
  }
}
