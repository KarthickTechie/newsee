import 'package:dio/dio.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/addressdetails/data/datasource/city_datasource.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

/*
@author   : Rajesh. S  12/06/2025 
@Desc     : Implementation of the Cityrepository interface for fetching city or district lists.
This class interacts with the data source to fetch city and district data based on the input request.
 */
class CitylistRepoImpl implements Cityrepository {
  /* 
  @modified   : karthick.d  22/06/2025
  @desc       : refactored to make resuable and moved common code here from 
                BLoC
   */
  @override
  Future<AsyncResponseHandler<Failure, dynamic>> fetchCityList(
    CityDistrictRequest cityDistrictRequest,
  ) async {
    AsyncResponseHandler<Failure, dynamic>? geographyMasterResponse =
        AsyncResponseHandler.right({});
    try {
      AsyncResponseHandler<Failure, dynamic> dbResponse = await _checkDataInDB(
        cityDistrictRequest,
      );

      // checking the data in db

      if (dbResponse.isRight()) {
        return dbResponse;
      } else {
        // fetch data from geography master
        if (cityDistrictRequest.cityCode != null) {
          // district data will be fetched
          final response = await CityDatasource(
            dio: ApiClient().getDio(),
          ).fecthDistrictList(cityDistrictRequest);
          geographyMasterResponse = await _getDistrict(
            response: response,
            cityDistrictRequest: cityDistrictRequest,
          );
        } else {
          final response = await CityDatasource(
            dio: ApiClient().getDio(),
          ).fecthCityList(cityDistrictRequest.stateCode);
          geographyMasterResponse = await _getCity(
            response: response,
            cityDistrictRequest: cityDistrictRequest,
          );
        }
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    }

    return geographyMasterResponse;
  }
}

Future<AsyncResponseHandler<Failure, dynamic>> _getDistrict({
  required Response response,
  required CityDistrictRequest cityDistrictRequest,
}) async {
  if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
    List<dynamic> cityResponse =
        response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY][ApiConfig
            .API_RESPONSE_RESPONSE_KEY] ??
        [];
    if (cityResponse.isNotEmpty) {
      List<GeographyMaster> cityList = [];
      // fetching district
      cityList =
          cityResponse.map((e) {
            e['stateParentId'] = cityDistrictRequest.stateCode;
            e['cityParentId'] = cityDistrictRequest.cityCode;
            return GeographyMaster.fromMap(e);
          }).toList();
      await saveGeographyMasterInDB(cityList);
      return _checkDataInDB(cityDistrictRequest);
    } else {
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: 'No Response from District Master'),
      );
    }
  } else {
    var errorMessage = response.data['ErrorMessage'];
    print('on Error request.data["ErrorMessage"] => $errorMessage');
    return AsyncResponseHandler.left(
      HttpConnectionFailure(message: errorMessage),
    );
  }
}

Future<AsyncResponseHandler<Failure, dynamic>> _getCity({
  required Response response,
  required CityDistrictRequest cityDistrictRequest,
}) async {
  if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
    List<dynamic> cityResponse = [];
    if (response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY][ApiConfig
            .API_RESPONSE_RESPONSE_KEY] !=
        null) {
      cityResponse =
          response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY][ApiConfig
              .API_RESPONSE_RESPONSE_KEY];
      if (cityResponse.isNotEmpty) {
        List<GeographyMaster> cityList = [];
        // fetching district
        cityList =
            cityResponse.map((e) {
              e['stateParentId'] = cityDistrictRequest.stateCode;
              e['cityParentId'] = '0';
              return GeographyMaster.fromMap(e);
            }).toList();

        // response must be written in GeographyMaster table
        await saveGeographyMasterInDB(cityList);
        return _checkDataInDB(cityDistrictRequest);
      } else {
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: 'No Response from City Master'),
        );
      }
    } else {
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: 'No Data Available'),
      );
    }
  } else {
    var errorMessage = response.data['ErrorMessage'];
    print('on Error request.data["ErrorMessage"] => $errorMessage');
    return AsyncResponseHandler.left(
      HttpConnectionFailure(message: errorMessage),
    );
  }
}

Future<AsyncResponseHandler<Failure, dynamic>> _checkDataInDB(
  CityDistrictRequest cityDistrictRequest,
) async {
  AsyncResponseHandler<Failure, dynamic> dbResponseForGeographyMaster =
      AsyncResponseHandler.left(
        HttpConnectionFailure(message: 'No data Found'),
      );

  Database db = await DBConfig().database;
  List<String> columnNames = [
    TableKeysGeographyMaster.stateId,
    TableKeysGeographyMaster.cityId,
  ];
  List<String> columnValues = [
    cityDistrictRequest.stateCode,
    cityDistrictRequest.cityCode ?? '0',
  ];

  List<GeographyMaster> cityMasterResponse = await GeographymasterCrudRepo(
    db,
  ).getByColumnNames(columnNames: columnNames, columnValues: columnValues);

  if (cityMasterResponse.isNotEmpty) {
    // if city code is null , set cityMaster collected from db
    if (cityDistrictRequest.cityCode == null && cityMasterResponse.isNotEmpty) {
      dbResponseForGeographyMaster = AsyncResponseHandler.right({
        "status": SaveStatus.mastersucess,
        "cityMaster": cityMasterResponse,
      });
    } else if (cityDistrictRequest.cityCode != null &&
        cityMasterResponse.isNotEmpty) {
      // if city code is not null , set districtMaster collected from db
      dbResponseForGeographyMaster = AsyncResponseHandler.right({
        "status": SaveStatus.mastersucess,
        "districtMaster": cityMasterResponse,
      });
    }
  }

  return dbResponseForGeographyMaster;
}

Future<void> saveGeographyMasterInDB(List<GeographyMaster> cityList) async {
  Database db = await DBConfig().database;
  Iterator<GeographyMaster> it = cityList.iterator;
  GeographymasterCrudRepo statecityMasterCrudRepo = GeographymasterCrudRepo(db);
  while (it.moveNext()) {
    statecityMasterCrudRepo.save(it.current);
  }
}
