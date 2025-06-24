import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/dedupe/data/datasource/dedupe_serach_datasource.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperesponse.dart';
import 'package:newsee/feature/dedupe/domain/repositoy/deduperepository.dart';

class DedupeSearchRepositoryimpl implements DedupeRepository {
  @override
  Future<AsyncResponseHandler<Failure, DedupeResponse>> dedupeSearchforCustomer(
    DedupeRequest request,
  ) async {
    try {
      final payload = request.toJson();
      var response = await DedupeDataSource(
        dio: ApiClient().getDio(),
      ).dedupeSearchcustomer(payload);

      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        print(
          "response.data['responseData'] ${response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY]}",
        );
        var dedupResponse = DedupeResponse.fromJson(
          response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY],
        );

        // print('DedupeResponse.fromJson() => ${dedupResponse.toString()}');
        return AsyncResponseHandler.right(dedupResponse);
      } else {
        // api response success : false , process error message
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
