import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'dart:convert';

import 'package:sqflite/sqlite_api.dart';

part 'field_investigation_event.dart';
part 'field_investigation_state.dart';

final class FieldInvestigationBloc extends Bloc<FieldInvestigationEvent, FieldInvestigationState> {
  FieldInvestigationBloc() : super(FieldInvestigationState.init()) {
    on<FieldInvestigationInitEvent>(initFieldInvestigationDetails);
  }

  Future initFieldInvestigationDetails(
    FieldInvestigationInitEvent event,
    Emitter emit,
  ) async {
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
      _db,
    ).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );

    emit(
      state.copyWith(
        lovlist: listOfLov,
        status: SaveStatus.init,
        stateCityMaster: stateCityMaster,
      ),
    );
  }
}