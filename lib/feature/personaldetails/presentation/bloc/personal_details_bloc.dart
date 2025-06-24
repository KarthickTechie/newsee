import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/aadharvalidation/data/repository/aadhar_validate_impl.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/aadharvalidation/domain/repository/aadharvalidate_repo.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './personal_details_event.dart';
part './personal_details_state.dart';

/* 

@author   : karthick.d  10/06/2025
@desc     : bloc for Personaldetials forward workflow and reverse workflow

 */
final class PersonalDetailsBloc
    extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  PersonalDetailsBloc() : super(PersonalDetailsState.init()) {
    on<PersonalDetailsInitEvent>(initPersonalDetails);
    on<PersonalDetailsSaveEvent>(savePersonalDetails);
    on<AadhaarValidateEvent>(validateAadaar);
  }

  /*
  PersonalDetailsState.lovmaster state will be supplied with LovMasters from db
   */
  Future<void> initPersonalDetails(
    PersonalDetailsInitEvent event,
    Emitter emit,
  ) async {
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    print('listOfLov => $listOfLov');
    emit(
      PersonalDetailsState(
        lovList: listOfLov,
        personalData: null,
        status: SaveStatus.init,
      ),
    );
  }

  /* 
    saving personaldetails entered and storing in personalData
   */
  Future<void> savePersonalDetails(
    PersonalDetailsSaveEvent event,
    Emitter emit,
  ) async {
    print('PersonalData => ${event.personalData}');
    var loanamaount = event.personalData!.loanAmountRequested!.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    emit(
      state.copyWith(
        personalData: event.personalData,
        status: SaveStatus.success,
      ),
    );
    state.copyWith(
      personalData: PersonalData(loanAmountRequested: loanamaount),
    );
  }

  Future<void> validateAadaar(AadhaarValidateEvent event, Emitter emit) async {
    emit(state.copyWith(status: SaveStatus.loading));
    final AadharvalidateRequest aadharvalidateRequest = event.request;
    AadharvalidateRepo aadharvalidateRepo = AadharValidateImpl();
    var responseHandler = await aadharvalidateRepo.validateAadhar(
      request: aadharvalidateRequest,
    );
    if (responseHandler.isRight()) {
      emit(
        state.copyWith(
          status: SaveStatus.init,
          aadhaarData: responseHandler.right,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          // e: responseHandler.left.message,
        ),
      );
    }
  }
}
