import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';

class DedupeDataSource {
  final Dio dio;
  DedupeDataSource({required this.dio});

  /*
  @author     : ganeshkumar.b 03/06/2025
  @desc       : dedupe search api consumer - dio.post method 
                datasource directory encapsulated http services and setup like
                http interceptors etc
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */
  dedupeSearchcustomer(payload) async {
    final res = await dio.post(ApiConfig.DEDUPE_API_ENDPOINT, data: payload);
    // print("REsponse for dedupe $res" );
    return res;
  }
}
