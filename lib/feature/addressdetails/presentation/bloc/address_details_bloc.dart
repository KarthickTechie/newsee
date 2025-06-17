/* 
@author   : karthick.d  10/06/2025
@desc     : bloc for saving updating address details page
@param    : 
 */
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/statecity_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './address_details_event.dart';
part './address_details_state.dart';

final class AddressDetailsBloc
    extends Bloc<AddressDetailsEvent, AddressDetailsState> {
  AddressDetailsBloc() : super(AddressDetailsState.init()) {
    on<AddressDetailsInitEvent>(initAddressDetails);
    on<AddressDetailsSaveEvent>(saveAddressDetails);
    on<OnStateCityChangeEvent>(getCityListBasedOnState);
    // on<OnStateCityChangeEvent>(getDisctrictListBasedOnCity);
  }

  Future<void> initAddressDetails(
    AddressDetailsInitEvent event,
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
        lovList: listOfLov,
        stateCityMaster: stateCityMaster,
        status: SaveStatus.init,
      ),
    );
  }

  Future<void> saveAddressDetails(
    AddressDetailsSaveEvent event,
    Emitter emit,
  ) async {
    print('Address Data => ${event.addressData}');
    emit(
      state.copyWith(
        addressData: event.addressData,
        status: SaveStatus.success,
      ),
    );
  }

  /* 
@author   : Rajesh. S  12/06/2025
@Desc     :Handles fetching the city list and district list based on the state and optionally the city code.
First, it attempts to fetch the data from the local database.If no matching data is found locally,
 it fetches data from the server. The fetched data is then stored in the local database.
 */
  Future<void> getCityListBasedOnState(
    OnStateCityChangeEvent event,
    Emitter emit,
  ) async {
    Database db = await DBConfig().database;
    List<String> columnNames = [
      TableKeysGeographyMaster.stateId,
      TableKeysGeographyMaster.cityId,
    ];
    List<String> columnValues;
    if (event.cityCode != null) {
      columnValues = [event.stateCode, event.cityCode ?? '0'];
    } else {
      columnValues = [event.stateCode, '0'];
    }

    emit(state.copyWith(status: SaveStatus.loading));
    List<GeographyMaster> cityDistrictMaster = await GeographymasterCrudRepo(
      db,
    ).getByColumnNames(columnNames: columnNames, columnValues: columnValues);
    if (event.cityCode == null && cityDistrictMaster.isNotEmpty) {
      await Future.delayed(Duration(seconds: 3));
      emit(
        state.copyWith(
          cityMaster: cityDistrictMaster,
          status: SaveStatus.mastersucess,
        ),
      );
    } else if (event.cityCode != null && cityDistrictMaster.isNotEmpty) {
      await Future.delayed(Duration(seconds: 3));
      emit(
        state.copyWith(
          districtMaster: cityDistrictMaster,
          status: SaveStatus.mastersucess,
        ),
      );
    } else {
      emit(state.copyWith(status: SaveStatus.loading));
      final CityDistrictRequest citydistrictrequest;
      Cityrepository cityrepository = CitylistRepoImpl();
      AsyncResponseHandler<Failure, dynamic> responseHandler;
      if (event.cityCode != null) {
        citydistrictrequest = CityDistrictRequest(
          stateCode: event.stateCode,
          cityCode: event.cityCode,
        );
        responseHandler = await cityrepository.fetchCityList(
          citydistrictrequest,
        );
      } else {
        citydistrictrequest = CityDistrictRequest(stateCode: event.stateCode);
        responseHandler = await cityrepository.fetchCityList(
          citydistrictrequest,
        );
      }
      if (responseHandler.isRight()) {
        List<GeographyMaster> cityList = responseHandler.right;
        if (cityList.isNotEmpty) {
          Iterator<GeographyMaster> it = cityList.iterator;
          GeographymasterCrudRepo statecityMasterCrudRepo =
              GeographymasterCrudRepo(db);
          while (it.moveNext()) {
            statecityMasterCrudRepo.save(it.current);
          }
          if (event.cityCode != null) {
            await Future.delayed(Duration(seconds: 3));
            emit(
              state.copyWith(
                districtMaster: cityList,
                status: SaveStatus.mastersucess,
              ),
            );
          } else {
            await Future.delayed(Duration(seconds: 3));
            emit(
              state.copyWith(
                cityMaster: cityList,
                status: SaveStatus.mastersucess,
              ),
            );
          }
        } else {
          if (event.cityCode != null) {
            await Future.delayed(Duration(seconds: 3));
            emit(
              state.copyWith(
                districtMaster: <GeographyMaster>[],
                status: SaveStatus.failure,
              ),
            );
          } else {
            await Future.delayed(Duration(seconds: 3));
            emit(
              state.copyWith(
                cityMaster: <GeographyMaster>[],
                status: SaveStatus.mastersucess,
              ),
            );
          }
        }
      } else {
        emit(state.copyWith(status: SaveStatus.failure));
      }
    }
  }

  // Future<void> getDisctrictListBasedOnCity(
  //   OnStateCityChangeEvent event,
  //   Emitter emit,
  // ) async {
  //   Database _db = await DBConfig().database;
  //   List<GeographyMaster> districtMaster = await GeographymasterCrudRepo(
  //     _db,
  //   ).getByColumnNames(
  //     columnNames: [
  //       TableKeysGeographyMaster.stateId,
  //       TableKeysGeographyMaster.cityId,
  //     ],
  //     columnValues: [event.stateCode, event.cityCode],
  //   );
  //   if (districtMaster.isNotEmpty) {
  //     emit(state.copyWith(districtMaster: districtMaster));
  //   } else {
  //     emit(state.copyWith(status: SaveStatus.loading));
  //     final Cityrequest districtrequest = Cityrequest(
  //       stateCode: event.stateCode,
  //       cityCode: event.cityCode,
  //     );
  //     Cityrepository cityrepository = CitylistRepoImpl();
  //     var responseHandler = await cityrepository.fetchCityList(districtrequest);
  //     if (responseHandler.isRight()) {
  //       List<GeographyMaster> cityList = responseHandler.right;
  //       if (cityList.isNotEmpty) {
  //         Iterator<GeographyMaster> it = cityList.iterator;
  //         GeographymasterCrudRepo statecityMasterCrudRepo =
  //             GeographymasterCrudRepo(_db);
  //         while (it.moveNext()) {
  //           statecityMasterCrudRepo.save(it.current);
  //         }
  //         emit(state.copyWith(districtMaster: cityList));
  //       }
  //     } else {
  //       emit(state.copyWith(status: SaveStatus.failure));
  //     }
  //   }
  // }
}
