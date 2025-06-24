import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/cif/data/datasource/cif_remote_datasource.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';

class CifRepositoryImpl implements CifRepository {
  @override
  Future<AsyncResponseHandler<Failure, CifResponse>> searchCif(
    CIFRequest req,
  ) async {
    try {
      print('CIF Search request payload => $req');
      final payload = req.toJson();
      var response = await CifRemoteDatasource(
        dio: ApiClient().getDio(),
      ).searchCif(payload);

      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        var cifResponse = CifResponse.fromJson(
          response.data[ApiConfig
              .API_RESPONSE_RESPONSE_KEY]['lpretLeadDetails'],
        );
        print('ChifResponseModel => ${cifResponse.toString()}');
        return AsyncResponseHandler.right(cifResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('CIF Search error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cifResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: "Unexpected Failure during CIF Search"),
      );
    }
  }
}
