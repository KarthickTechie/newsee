import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/geographymaster_response_mapper.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
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
    on<RBIHDetailsLoadEvent>(loadRBIHData);
  }

  Future initLandHoldingDetails(
    LandHoldingInitEvent event,
    Emitter emit,
  ) async {
    Database db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(db).getAll();
    List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
      db,
    ).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );

    final LandHoldingRepository landHoldingRepository =
        LandHoldingRespositoryImpl();

    final response = await landHoldingRepository.getLandholding({
      'proposalNumber': event.proposalNumber,
      'custId': event.custId,
    });

    if (response.isRight()) {
      List<LandData> landData = response.right.agriLandHoldingsList;
      // .map((e) => LandData.fromMap(e))
      // .toList();
      print("LandData from response at get=> $landData");

      List<GeographyMaster>? cityMaster = [];

      for (var i = 0; i < landData.length; i++) {
        List<GeographyMaster>? coappCityList = await getCityMaster(
          landData[i].lslLandState,
          null,
        );
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

  // Save new land data
  Future<void> _onSubmit(
    LandDetailsSaveEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      // final newList = [...?state.landData, event.landData as LandData];
      print("event.landData not a map => ${event.landData}");

      // LandHoldingRequest req = LandHoldingRequest(
      //   proposalNumber: event.proposalNumber,
      //   state: event.landData['state'] ?? '',
      //   district: event.landData['district'] ?? '',
      //   taluk: event.landData['taluk'] ?? '',
      //   village: event.landData['village'] ?? '',
      //   surveyNo: event.landData['surveyNo'] ?? '',
      //   khasraNo: event.landData['khasraNo'] ?? '',
      //   uccCode: event.landData['uccCode'] ?? '',
      //   totAcre: event.landData['totAcre'] ?? '',
      //   landType: event.landData['landType'] ?? '',
      //   particulars: event.landData['particulars'] ?? '',
      //   sourceofIrrigation: event.landData['sourceofIrrig'] ?? '',
      //   farmDistance: event.landData['farmDistance'] ?? '',
      //   otherbanks: event.landData['otherbanks'] ? 'Y' : 'N',
      //   farmercategory: event.landData['farmercategory'] ?? '',
      //   primaryoccupation: event.landData['primaryoccupation'] ?? '',
      //   sumOfTotalAcreage: event.landData['sumOfTotalAcreage'] ?? '',
      //   rowId: event.landData['rowId'],
      //   // event.landData['rowId'] != null
      //   //     ? int.parse(event.landData['rowId'])
      //   //     : null,
      //   token: ApiConstants.api_qa_token,
      // );

      LandHoldingRequest req = LandHoldingRequest(
        proposalNumber: event.proposalNumber,
        applicantName: event.custId,
        LandOwnedByApplicant:
            event.landData['landOwnedByApplicant'] ? 'Y' : 'N',
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
        villageOfficersCertificate:
            event.landData['villageOfficerCertified'] ? '1' : '2',
        LandAgriculturellyActive: event.landData['landAgriActive'] ? '1' : '2',
        rowId: int.tryParse(event.landData['lslLandRowid']?.toString() ?? ''),
        polygonDetails: event.polygonData,
        // rowId:
        //     event.landData['lslLandRowid'] != null
        //         ? int.parse(event.landData['lslLandRowid'])
        //         : null,
        token: ApiConstants.api_qa_token,
      );

      final landReq = req;
      print('final request for land holding => $landReq');

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.submitLandHolding(landReq);

      if (response.isRight()) {
        List<LandData> landData = response.right.agriLandHoldingsList;
        // .map((e) => LandData.fromMap(e))
        // .toList();

        print("LandData from response => $landData");
        emit(
          state.copyWith(
            status: SaveStatus.success,
            landData: landData,
            selectedLandData: null,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            errorMessage: response.left.message,
          ),
        );
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
        errorMessage: null,
      ),
    );
  }

  Future<void> _onDelete(LandDetailsDeleteEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      final LandHoldingDeleteRequest landDeleteReq = LandHoldingDeleteRequest(
        proposalNumber: event.landData.lslPropNo.toString(),
        custId: event.custId,
        rowId: event.landData.lslLandRowid.toString(),
        token: ApiConstants.api_qa_token,
      );

      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final response = await landHoldingRepository.deleteLandHoldingData(
        landDeleteReq,
      );
      if (response.isRight()) {
        List<LandData> landDetailsList = state.landData!;
        landDetailsList.removeAt(event.index);
        print("final landDetailsList $landDetailsList");
        emit(
          state.copyWith(
            status: SaveStatus.delete,
            errorMessage: response.right,
            landData: landDetailsList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            errorMessage: response.left.message,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          errorMessage: error.toString(),
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
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
        stateCode: event.stateCode,
        cityCode: event.cityCode,
      );
      Cityrepository cityrepository = CitylistRepoImpl();
      AsyncResponseHandler response = await cityrepository.fetchCityList(
        citydistrictrequest,
      );
      print('responsecity: $response');
      GeographymasterResponseMapper landHoldingState =
          GeographymasterResponseMapper(state).mapResponse(response);
      LandHoldingState landHoldingState0 =
          landHoldingState.state as LandHoldingState;
      emit(
        state.copyWith(
          status: landHoldingState0.status,
          cityMaster: landHoldingState0.cityMaster,
          districtMaster: landHoldingState0.districtMaster,
        ),
      );
    } catch (e) {
      print('getcitymasterLans: $e');
      emit(state.copyWith(status: SaveStatus.failure));
    }
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

      Map<String, dynamic> resp = response.right as Map<String, dynamic>;

      List<GeographyMaster> cityMaster =
          resp['cityMaster'] != null && resp['cityMaster'].isNotEmpty
              ? resp['cityMaster'] as List<GeographyMaster>
              : [];
      List<GeographyMaster> districtMaster =
          resp['districtMaster'] != null && resp['districtMaster'].isNotEmpty
              ? resp['districtMaster'] as List<GeographyMaster>
              : [];

      if (cityCode == null) {
        return cityMaster;
      } else {
        return districtMaster;
      }
    } catch (error) {
      print("mapGaurantor-error => $error");
      return null;
    }
  }

  Future<void> loadRBIHData(RBIHDetailsLoadEvent event, Emitter emit) async {
    try {
      final response = await offlineDataProvider(
        path: AppConstants.rhIHLandCropResponse,
      );
      final jsonData = response.data;
      final data = jsonData['data']['data'] as Map<String, dynamic>;

      print("_loadData response $response");
      // Assuming the JSON structure has these keys

      final List<dynamic> landOwnerDetails =
          response.data['data']['data']['landOwnerDetails'];

      final ownerData =
          (landOwnerDetails as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
      List<LandData> landDataList =
          ownerData!.map((ownerDetail) {
            int tot = parseToInt(ownerDetail['landParcel']['totarea']);
            String formerCat;
            if (tot < 5) {
              formerCat = '1';
            } else if (tot > 5 && tot < 10) {
              formerCat = '2';
            } else {
              formerCat = '3';
            }

            print("totarea raw value: ${ownerDetail['landParcel']['totarea']}");
            return LandData(
              lslLandFirka: ownerDetail['landParcel']['khasrano'].toString(),
              lslLandSurveyNo:
                  ownerDetail['landParcel']['surveynoarea']
                          .toString()
                          .isNotEmpty
                      ? ownerDetail['landParcel']['surveynoarea'].toString()
                      : '223',
              lslLandTaluk:
                  ownerDetail['landParcel']['talukcode'].toString().isNotEmpty
                      ? ownerDetail['landParcel']['talukcode'].toString()
                      : '1294',
              // lslLandTotAcre: ownerDetail['landParcel']['totarea'],
              lslLandTotAcre: 4,
              lslLandIrriLand: 3,
              lslLandVillage: 'Kolathur',

              // lslLandApplicantName: ownerDetail['owner']['fullname'],
              lslLandApplicantName: event.rbihFormData?['applicant'],
              // lslLandFarmLoc: ownerDetail['landParcel']['geocoordinates'],
              // lslLandFarmLoc: "80.2546, 12.9483",
              // lslLandFarmDistance: 1,
              // lklParticulars: '1',
              // lklUccCode: landOwnerDetails.length.toString(),
              lslLandNature: '1',
              lslLandIrriFaci: '1',
              lslLandDistrict: '0001',
              lslLandState: '38',
              // lklfarmercategory: formerCat,
              // lklsumOfTotalAcreage: ownerDetail['landParcel']['totarea'],
            );
          }).toList();
      print(landOwnerDetails);

      final List<dynamic> cryieldDetails =
          response.data['data']['data']['cropYieldDetails']['cropDetail'];

      final cropYieldDetailsList =
          (cryieldDetails as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
      Globalconfig.RBIHCropDataList = cropYieldDetailsList;

      emit(state.copyWith(status: SaveStatus.init, landData: landDataList));
    } catch (e) {
      print('Error loading data: $e');
      emit(
        state.copyWith(status: SaveStatus.failure, errorMessage: e.toString()),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error loading data: $e')),
      // );
    }
  }
}
