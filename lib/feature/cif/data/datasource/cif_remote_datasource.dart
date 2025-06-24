import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';

/*
  @author     : gayathri
  @desc       : searcg cif api consumer - dio.post method 
                datasource directory encapsulated http services and setup like
                http interceptors etc
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */

class CifRemoteDatasource {
  final Dio dio;

  CifRemoteDatasource({required this.dio});

  Future<Response> searchCif(payload) async {
    Response response = await dio.post(
      ApiConfig.CIF_API_ENDPOINT,
      data: payload,
      options: Options(
        headers: {
          'token': ApiConfig.AUTH_TOKEN,
          'deviceId': ApiConfig.DEVICE_ID,
          'userid': '4321',
        },
      ),
    );
    return response;
  }
}
