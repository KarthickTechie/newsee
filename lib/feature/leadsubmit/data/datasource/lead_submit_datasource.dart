import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/lead_submit_request.dart';

class LeadSubmitDatasource {
  final Dio dio;
  LeadSubmitDatasource({required this.dio});

  /*
  @author     : karthick.d 16/06/2025
  @desc       : 
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */
  submitLead(Map<String, dynamic> payload) async {
    final res = await dio.post(
      ApiConfig.LEAD_SUBMIT_API_ENDPOINT,
      data: payload,
    );
    return res;
  }
}
