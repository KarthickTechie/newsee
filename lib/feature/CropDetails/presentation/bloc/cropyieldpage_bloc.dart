import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

part 'cropyieldpage_event.dart';
part 'cropyieldpage_state.dart';

class CropyieldpageBloc extends Bloc<CropyieldpageEvent, CropyieldpageState> {
  CropyieldpageBloc(): super(CropyieldpageState.init()) {
    on<CropPageInitialEvent>(initCropYieldDetails);
    on<CropFormSaveEvent>(onSaveCropYieldPage);
    on<CropDetailsSetEvent>(onDataSet);
    on<CropDetailsResetEvent>(onResetForm);
  }

  Future<void> initCropYieldDetails(CropPageInitialEvent event, Emitter emit) async {
    try {
      Database _db = await DBConfig().database;
      List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
      print('listOfLov => $listOfLov');
      emit(
        state.copyWith(
          lovlist: listOfLov,
          status: CropPageStatus.init
        )
      );
    } catch(error) {
      print("onSaveCropYieldPage-error $error");
    }
  }

  Future<void> onSaveCropYieldPage(
      CropFormSaveEvent event,
      Emitter<CropyieldpageState> emit,
    ) async {
    final newList = [...?state.cropData, event.cropData];
    emit(
      state.copyWith(
        status: CropPageStatus.success,
        cropData: newList,
        selectedCropData: null,
      ),
    );
  }

   // Load data into form for editing
  void onDataSet(CropDetailsSetEvent event, Emitter<CropyieldpageState> emit) {
    emit(
      state.copyWith(
        selectedCropData: event.cropData,
        status: CropPageStatus.set
      )
    );
  }

  void onResetForm(CropDetailsResetEvent event, Emitter<CropyieldpageState> emit) {
    emit(
      state.copyWith(
        selectedCropData: null,
        status: CropPageStatus.reset
      )
    );
  }



}