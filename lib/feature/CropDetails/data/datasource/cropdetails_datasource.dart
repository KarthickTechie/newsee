import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

/*
  @author     : ganeshkuamr.b
  @desc       : save CropDetails save and get api consumer - dio.post method 
                datasource directory encapsulated http services and setup like
                http interceptors etc
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */

class CropDetailsDatasource {
  final Dio dio;

  CropDetailsDatasource({required this.dio});

  Future<Response> callCropAPI(payload, endPoint) async {
    Response response = await dio.post(
      endPoint,
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
