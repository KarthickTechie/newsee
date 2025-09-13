import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/geographymaster_response_mapper.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/domain/modal/Land_Holding_delete_request.dart';
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
    on<LandDetailsDeleteEvent>(_onDelete);
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

    if (Globalconfig.isOffline) {
      emit(
        state.copyWith(
          lovlist: listOfLov,
          status: SaveStatus.init,
          stateCityMaster: stateCityMaster,
        ),
      );
    } else {
      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();

    final response = await landHoldingRepository.getLandholding(event.proposalNumber);
    
    if(response.isRight()) {
      List<LandData> landData =
          response.right.agriLandHoldingsList
              .map((e) => LandData.fromMap(e))
              .toList();
      print("LandData from response at get=> $landData");

      List<GeographyMaster>? cityMaster = [];

      for(var i=0; i < landData.length; i++) {
        List<GeographyMaster>? coappCityList = await getCityMaster(landData[i].lslLandState, null);
        cityMaster.addAll(coappCityList ?? []);
      }

      

      emit(
        state.copyWith(
          lovlist: listOfLov,
          status: SaveStatus.init,
          stateCityMaster: stateCityMaster,
          cityMaster: cityMaster,
          landData: landData,
        ),
      );
    } else {
      emit(
        state.copyWith(
          lovlist: listOfLov,
          status: SaveStatus.init,
          stateCityMaster: stateCityMaster,
        ),
      );
    }
    }
  }

  // Save new land data
  Future<void> _onSubmit(
    LandDetailsSaveEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      // final newList = [...?state.landData, event.landData as LandData];
      print("event.landData not a map => ${event.landData}");
      final landdata = event.landData;
      final proposalNo = event.proposalNumber;
      print("event.landData => $landdata");

      if (Globalconfig.isOffline) {
        final updatedList = List<LandData>.from(state.landData ?? []);
        LandData landData = LandData(
          lslPropNo: int.parse(event.proposalNumber),
          lslLandApplicantName: event.landData['applicantName'] ?? '',
          lslLandApplicant: event.landData['landOwnedByApplicant'].toString(),
          lslLandFarmLoc: event.landData['locationOfFarm'] ?? '', 
          lslLandFarmDistance: int.parse(event.landData['distanceFromBranch']) ?? 0, 
          lslLandState: event.landData['state'] ?? '',
          lslLandDistrict: event.landData['district'] ?? '',
          lslLandTaluk: event.landData['taluk'] ?? '',
          lslLandVillage: event.landData['village'] ?? '',
          lslLandFirka: event.landData['firka'] ?? '',   
          lslLandSurveyNo: event.landData['surveyNo'] ?? '',
          lslLandTotAcre: int.parse(event.landData['totalAcreage']) ?? 0,
          lslLandNature: event.landData['natureOfRight'] ?? '',
          lslLandIrriFaci: event.landData['irrigationFacilities'] ?? '',
          lslLandIrriLand: int.parse(event.landData['irrigatedLand']) ?? 0,
          lslLandCompact: event.landData['compactBlocks'].toString(),
          lslLandCeilingEnact: event.landData['affectedByCeiling'].toString(),
          lslLandOfficeCerti: event.landData['villageOfficerCertified'].toString(),
          lslAgriActive: event.landData['landAgriActive'].toString()
        );
        updatedList.add(landData);
        emit(
            state.copyWith(
              status: SaveStatus.success,
              landData: updatedList,
              selectedLandData: null,
              errorMessage: null
            ),
          );
      } else {
        LandHoldingRequest req = LandHoldingRequest(
          proposalNumber: event.proposalNumber,
          applicantName: event.landData['applicantName'] ?? '',
          LandOwnedByApplicant: event.landData['landOwnedByApplicant'] ? 'Y' : 'N',
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
          LandsSituatedCompactBlocks: event.landData['compactBlocks'] ? '1' : '2',
          landCeilingEnactments: event.landData['affectedByCeiling'] ? '1' : '2',
          villageOfficersCertificate: event.landData['villageOfficerCertified'] ? '1' : '2',
          LandAgriculturellyActive: event.landData['landAgriActive'] ? '1' : '2',
          rowId: event.landData['lslLandRowid'] != null ? int.parse(event.landData['lslLandRowid']) : null,
          token: ApiConstants.api_qa_token,
        );

        final landReq = req;
        print('final request for land holding => $landReq');

        final LandHoldingRepository landHoldingRepository =
            LandHoldingRespositoryImpl();
        final response = await landHoldingRepository.submitLandHolding(landReq);

        if (response.isRight()) {
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
              errorMessage: null
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: SaveStatus.failure,
              errorMessage: response.left.message
            ),
          );
        }
      }

      
      
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
        errorMessage: null
      ),
    );
  }

  Future<void> _onDelete(LandDetailsDeleteEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      final LandHoldingDeleteRequest landDeleteReq = LandHoldingDeleteRequest(
        proposalNumber: event.landData.lslPropNo.toString(),
        rowId: event.landData.lslLandRowid.toString(), 
        token: ApiConstants.api_qa_token,
      );

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.deleteLandHoldingData(landDeleteReq);
      if (response.isRight()) {
        List<LandData> landDetailsList = state.landData!;
        landDetailsList.removeAt(event.index);
        print("final landDetailsList $landDetailsList");
        emit(
          state.copyWith(
            status: SaveStatus.delete, 
            errorMessage: response.right,
            landData: landDetailsList
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure, 
            errorMessage: response.left.message
          ),
        );
      }

    } catch(error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure, 
          errorMessage: error.toString()
        ),
      );
      print("LandDetailsDeleteEvent-error $error");
    }
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

  Future<List<GeographyMaster>?> getCityMaster(stateCode, cityCode) async {
    try {
      final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
        stateCode: stateCode,
        cityCode: cityCode,
      );
      Cityrepository cityrepository = CitylistRepoImpl();
      AsyncResponseHandler response = await cityrepository.fetchCityList(
        citydistrictrequest,
      );

      Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

      List<GeographyMaster> cityMaster =
        _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
            ? _resp['cityMaster'] as List<GeographyMaster>
            : [];
    List<GeographyMaster> districtMaster =
        _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
            ? _resp['districtMaster'] as List<GeographyMaster>
            : [];
      
      if(cityCode == null) {
        return cityMaster;
      } else {
        return districtMaster;
      }
    } catch (error) {
      print("mapGaurantor-error => $error");
      return null;
    }
  }
}