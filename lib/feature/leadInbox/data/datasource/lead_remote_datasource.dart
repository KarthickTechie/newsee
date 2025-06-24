import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
/*
  @author     : gayathri.b 9/06/2025
  @desc       : lead api consumer - dio.post method 
                datasource directory encapsulated http services and setup like
                http interceptors etc
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */

class LeadRemoteDatasource {
  final Dio dio;
  LeadRemoteDatasource({required this.dio});

  Future<Response> searchLead(Map<String, dynamic> payload) async {
    return await dio.post(
      ApiConfig.LEAD_INBOX_API_ENDPOINT,
      data: payload,
      options: Options(
        headers: {
          'token': ApiConfig.AUTH_TOKEN,
          'deviceId': ApiConfig.DEVICE_ID,
          'userid': '4321',
        },
      ),
    );
  }
}
