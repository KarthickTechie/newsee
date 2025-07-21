import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/CropDetails/data/repository/cropdetails_repository_impl.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_delete_request.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_get_response.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropmodel.dart';
import 'package:newsee/feature/CropDetails/domain/modal/croprequestmodel.dart';
import 'package:newsee/feature/CropDetails/domain/repository/cropdetails_repository.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';
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
    on<CropDetailsUpdateEvent>(onUpdateForm);
    on<CropDetailsSubmitEvent>(onSubmitCropDetails);
    on<CropDetailsDeleteEvent>(onDeleteCropDetails);
    on<CropDetailsRemoveEvent>(onRemoveCrop);
  }

  Future<void> onSubmitCropDetails(
    CropDetailsSubmitEvent event,
    Emitter emit
  ) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      final CropRequestModel cropReq = CropRequestModel(
        proposalNumber: event.proposalNumber,
        userid: event.userid,
        cropDetailModel: CropModal(
          taluk: "Saidapet",
          agriCultivated: "1",
          state: "38",
          firka: "Test",
          distanceFromBranch: "2",
          irrigated: event.irrigated,
          natureOfRight: "1",
          district: "0001",
          village: "sholinganallur",
          rainfed: event.rainfed,
          total: event.total,
          cropsCultivatedOrProposedCrops: "12",
          surveyNo: "34567",
          farmDistance: "Chennai"
        ),
        assessmentSOF: state.cropData,
        token: ApiConfig.AUTH_TOKEN
      );
      print("cropReq $cropReq");
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      var responseHandler = await cropRepository.saveCrop(
        cropReq,
      );  
      print("get responseHandler value is => $responseHandler");

      AsyncResponseHandler<Failure, CropGetResponse> cropGetResponse = await cropRepository.getCrop(
        event.proposalNumber
      );
      if (responseHandler.isRight() && cropGetResponse.isRight()) {
        // List<Map<String, dynamic>> listofAssessment = responseHandler.right.responseData?['AssessmentSOF'];
        // print("listofAssessment value is => $listofAssessment");
        // List<LandData> landData = listofAssessment.map((e) => LandData.fromMap(e)).toList();

        print("cropGetResponse.right.agriCropDetails ${cropGetResponse.right.agriCropDetails}");
        
        emit(
          state.copyWith(
            status: SaveStatus.success,
            cropData: cropGetResponse.right.agriCropDetails,
            showSubmit: false
          )
        );
      } else if(responseHandler.isRight()) {
         emit(
          state.copyWith(
            status: SaveStatus.success,
            showSubmit: false
          )
        );
      } else {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          errorMessage: responseHandler.left.message,
          showSubmit: true
        ),
      );
    }
    } catch(error) {
      print("onSubmitCropDetails $error");
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          errorMessage: error.toString()
        ),
      );
    }
  }

  Future<void> initCropYieldDetails(CropPageInitialEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      Database _db = await DBConfig().database;
      List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
      print('listOfLov => $listOfLov');

      //Get Crop Details
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      AsyncResponseHandler<Failure, CropGetResponse> cropResponse = await cropRepository.getCrop(
        event.proposalNumber
      );

      

      //Get Land Details
      // final LandHoldingRepository landHoldingRepository =
      //     LandHoldingRespositoryImpl();
      // final landresponse = await landHoldingRepository.getLandholding(event.proposalNumber);
      // print("get responseHandler value is => $cropResponse");

      //Emit init state
      // if (cropResponse.isRight() && landresponse.isRight()) {
      if (cropResponse.isRight()) {
        print("cropResponse.right.agriCropDetails-gettime ${cropResponse.right.agriCropDetails}");
        // List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: SaveStatus.init,
            cropData: cropResponse.right.agriCropDetails,
            landDetails: cropResponse.right.agriLandDetails,
            // landData: landData
          )
        );
      // } else if (landresponse.isRight()) {
      //   List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
      //   emit(
      //     state.copyWith(
      //       lovlist: listOfLov,
      //       status: SaveStatus.init,
      //       landData: landData
      //     )
      //   );
      } else {
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: SaveStatus.init,
          )
        );
      }
      
    } catch(error) {
      print("onSaveCropYieldPage-error $error");
      emit(state.copyWith(status: SaveStatus.failure));
    }
  }

  Future<void> onSaveCropYieldPage(
      CropFormSaveEvent event,
      Emitter<CropyieldpageState> emit,
    ) async {
    final newList = [...?state.cropData, event.cropData];
    emit(
      state.copyWith(
        status: SaveStatus.mastersucess,
        cropData: newList,
        selectedCropData: null,
        showSubmit: true
      ),
    );
  }

   // Load data into form for editing
  Future<void> onDataSet(CropDetailsSetEvent event, Emitter<CropyieldpageState> emit) async{
    emit(
      state.copyWith(
        selectedCropData: event.cropData,
        status: SaveStatus.update
      )
    );
    await Future.delayed(Duration(seconds: 2));
    emit(
      state.copyWith(
        status: SaveStatus.edit
      )
    );
  }

  void onResetForm(CropDetailsResetEvent event, Emitter<CropyieldpageState> emit) {
    emit(
      state.copyWith(
        selectedCropData: null,
        status: SaveStatus.reset
      )
    );
  }

  void onUpdateForm(CropDetailsUpdateEvent event, Emitter<CropyieldpageState> emit) {
    List<CropDetailsModal>? fullcropdata = state.cropData;
    fullcropdata?[event.index] = event.cropData;
    print("Updated crop data is there is $fullcropdata");
    emit(
      state.copyWith(
        cropData: fullcropdata,
        selectedCropData: null,
        status: SaveStatus.mastersucess,
        showSubmit: true
      )
    );
  }

  Future<void> onDeleteCropDetails(CropDetailsDeleteEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      CropDeleteRequest deleteReq = CropDeleteRequest(
        proposalNumber: event.proposalNumber, 
        rowId: event.rowId, 
        token: ApiConfig.AUTH_TOKEN
      );
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      var delResponseHandler = await cropRepository.deleteCrop(
        deleteReq,
      );  
      print("get responseHandler value is => $delResponseHandler");

      if (delResponseHandler.isRight()) {
        // AsyncResponseHandler<Failure, CropGetResponse> cropGetResponse = await cropRepository.getCrop(
        //   event.proposalNumber
        // );

        // if (cropGetResponse.isRight()) {
        //   emit(
        //     state.copyWith(
        //       status: SaveStatus.delete,
        //       cropData: cropGetResponse.right.agriCropDetails,
        //       errorMessage: delResponseHandler.right
        //     )
        //   );
        // } else {
          List<CropDetailsModal> cropDetailsList = state.cropData!;
          cropDetailsList.removeAt(event.index);
          final addedCrop = checkNewArray(cropDetailsList);
          final showSubmit = addedCrop ? true : false;
          print("final landDetailsList $cropDetailsList");
          emit(
            state.copyWith(
              status: SaveStatus.delete,
              cropData: cropDetailsList,
              errorMessage: delResponseHandler.right,
              showSubmit: showSubmit
            )
          );
        // }
      } else {
        emit(
          state.copyWith(
            status: SaveStatus.failure,
            cropData: state.cropData,
            errorMessage: delResponseHandler.left.message
          )
        );
      }
    } catch(error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          cropData: state.cropData,
          errorMessage: error.toString()
        )
      );
    }

  }

  Future<void> onRemoveCrop(CropDetailsRemoveEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: SaveStatus.loading));
      Future.delayed(Duration(seconds: 2));
      List<CropDetailsModal> cropDetailsList = state.cropData!;
      cropDetailsList.removeAt(event.index);
      print("final landDetailsList $cropDetailsList");
      final addedCrop = checkNewArray(cropDetailsList);
      final showSubmit = addedCrop ? true : false;
       emit(
        state.copyWith(
          status: SaveStatus.delete,
          cropData: cropDetailsList,
          errorMessage: '',
          showSubmit: showSubmit
        )
      );
    } catch(error) {
       emit(
        state.copyWith(
          status: SaveStatus.failure,
          cropData: state.cropData,
          errorMessage: error.toString()
        )
      );
    }
  }


  bool checkNewArray(List<CropDetailsModal> arraydata) {
    try {
      for (int i = 0; i < arraydata.length; i++) {
        if(arraydata[i].lasSeqno == '') {
          return true;
        }
      }
      return false;
    } catch(error) {
      print("final checkNewArray $error");
      return false;
    }
  }

}