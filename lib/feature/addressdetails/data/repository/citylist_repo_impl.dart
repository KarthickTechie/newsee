import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/addressdetails/data/datasource/city_datasource.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';

/*
@author   : Rajesh. S  12/06/2025 
@Desc     : Implementation of the Cityrepository interface for fetching city or district lists.
This class interacts with the data source to fetch city and district data based on the input request.
 */
class CitylistRepoImpl implements Cityrepository {
  @override
  Future<AsyncResponseHandler<Failure, dynamic>> fetchCityList(
    CityDistrictRequest cityDistrictRequest,
  ) async {
    try {
      var response;
      if (cityDistrictRequest.cityCode != null) {
        response = await CityDatasource(
          dio: ApiClient().getDio(),
        ).fecthDistrictList(cityDistrictRequest);
      } else {
        response = await CityDatasource(
          dio: ApiClient().getDio(),
        ).fecthCityList(cityDistrictRequest.stateCode);
      }
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        List<dynamic> cityResponse =
            response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY][ApiConfig
                .API_RESPONSE_RESPONSE_KEY];
        if (cityResponse.isNotEmpty) {
          List<GeographyMaster> cityList = [];
          if (cityDistrictRequest.cityCode != null) {
            cityList =
                cityResponse.map((e) {
                  e['stateParentId'] = cityDistrictRequest.stateCode;
                  e['cityParentId'] = cityDistrictRequest.cityCode;
                  return GeographyMaster.fromMap(e);
                }).toList();
          } else {
            cityList =
                cityResponse.map((e) {
                  e['stateParentId'] = cityDistrictRequest.stateCode;
                  e['cityParentId'] = "0";
                  return GeographyMaster.fromMap(e);
                }).toList();
          }
          return AsyncResponseHandler.right(cityList);
        } else {
          return AsyncResponseHandler.right(<GeographyMaster>[]);
        }
      } else {
        var errorMessage = response.data['ErrorMessage'];
        print('on Error request.data["ErrorMessage"] => $errorMessage');
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: errorMessage),
        );
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    }
  }
}
