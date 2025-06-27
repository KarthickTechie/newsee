import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppSamples/ReactiveForms/config/appconfig.dart';
import 'package:newsee/Utils/geographymaster_response_mapper.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:newsee/AppData/app_constants.dart';

part 'land_holding_event.dart';
part 'land_holding_state.dart';

final class LandHoldingBloc extends Bloc<LandHoldingEvent, LandHoldingState> {
  LandHoldingBloc() : super(LandHoldingState.init()) {
    on<LandHoldingInitEvent>(initLandHoldingDetails);
    on<LandDetailsSaveEvent>(_onSubmit);
    on<LandDetailsLoadEvent>(_onLoad);
    on<OnStateCityChangeEvent>(getCityListBasedOnState);
  }

  Future initLandHoldingDetails(
    LandHoldingInitEvent event,
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

  // Save new land data
  Future<void> _onSubmit(
    LandDetailsSaveEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    try {
      // final newList = [...?state.landData, event.landData as LandData];
      print("event.landData not a map => ${event.landData}");
      final landdata = event.landData;
      print("event.landData => $landdata");

      LandHoldingRequest req = LandHoldingRequest(
        proposalNumber: '143560000000633',
        applicantName: event.landData['applicantName'] ?? '',
        LandOwnedByApplicant:
            event.landData['landOwnedByApplicant'].toString() == 'true'
                ? 'Y'
                : 'N',
        LocationOfFarm: event.landData['locationOfFarm'] ?? '',
        DistanceFromBranch: event.landData['distanceFromBranch'] ?? '',
        State: event.landData['state'] ?? '',
        District: event.landData['district'] ?? '',
        Taluk: event.landData['taluk'] ?? '',
        Village: event.landData['village'] ?? '',
        Firka: event.landData['firka'] ?? '',
        SurveyNo: event.landData['surveyNo'] ?? '',
        TotalAcreage: event.landData['totalAcreage'] ?? '',
        NatureOfRight: event.landData['natureOfRight'] ?? '',
        OutOfTotalAcreage: event.landData['irrigatedLand'] ?? '',
        NatureOfIrrigation: event.landData['irrigationFacilities'] ?? '',
        LandsSituatedCompactBlocks:
            event.landData['landsSituatedCompactBlocks'].toString() == 'true'
                ? '1'
                : '2',
        landCeilingEnactments:
            event.landData['landCeilingEnactments'].toString() == 'true'
                ? '1'
                : '2',
        villageOfficersCertificate:
            event.landData['villageOfficersCertificate'].toString() == 'true'
                ? '1'
                : '2',
        LandAgriculturellyActive:
            event.landData['landAgricultureActive'].toString() == 'true'
                ? '1'
                : '2',
        token: ApiConstants.api_qa_token,
      );

      final landReq = req;
      print('final request for land holding => $landReq');

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.submitLandHolding(landReq);
      List<LandData> landData =
          response.right.agriLandHoldingsList
              .map((e) => LandData.fromMap(e))
              .toList();

      print("LandData from response => $landData");
      emit(
        state.copyWith(
          status: SaveStatus.success,
          landData: landData,
          selectedLandData: null,
        ),
      );
    } catch (e) {
      print("Error in LandDetailsSaveEvent: $e");
      emit(
        state.copyWith(status: SaveStatus.failure, errorMessage: e.toString()),
      );
      return;
    }
  }

  // Load data into form for editing
  void _onLoad(LandDetailsLoadEvent event, Emitter<LandHoldingState> emit) {
    emit(
      state.copyWith(
        status: SaveStatus.update,
        selectedLandData: event.landData,
      ),
    );
  }

  Future<void> getCityListBasedOnState(
    OnStateCityChangeEvent event,
    Emitter emit,
  ) async {
    /** 
     * @modified    : karthick.d 22/06/2025
     * 
     * @reson       : geograhy master parsing logic should be kept as function 
     *                so it the logic can be reused across various bLoC
     * 
     * @desc        : so geograpgy master fetching logic is reusable 
                      encapsulate geography master datafetching in citylist_repo_impl 
                      the desired statement definition as simple as calling the funtion 
                      and set the state
                      emit(state.copyWith(status:SaveStatus.loading));
                      await cityrepository.fetchCityList(
                              citydistrictrequest,
                          );
    */

    emit(state.copyWith(status: SaveStatus.loading));
    final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
      stateCode: event.stateCode,
      cityCode: event.cityCode,
    );
    Cityrepository cityrepository = CitylistRepoImpl();
    AsyncResponseHandler response = await cityrepository.fetchCityList(
      citydistrictrequest,
    );
    GeographymasterResponseMapper landHoldingState =
        GeographymasterResponseMapper(state).mapResponse(response);
    LandHoldingState _landHoldingState =
        landHoldingState.state as LandHoldingState;
    emit(
      state.copyWith(
        status: _landHoldingState.status,
        cityMaster: _landHoldingState.cityMaster,
        districtMaster: _landHoldingState.districtMaster,
      ),
    );
  }
}
