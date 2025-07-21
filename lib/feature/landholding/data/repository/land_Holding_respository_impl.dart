import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/landholding/data/datasource/landHolding_remote_datasource.dart';
import 'package:newsee/feature/landholding/domain/modal/Land_Holding_delete_request.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_responce_model.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';

class LandHoldingRespositoryImpl implements LandHoldingRepository {
  @override
  Future<AsyncResponseHandler<Failure, LandHoldingResponceModel>>
  submitLandHolding(LandHoldingRequest request) async {
    try {
      print('Land holding request => $request');

      final payload = request.toJson();
      print("payload-LandHoldingRespositoryImpl => $payload");
      final endPoint = ApiConfig.LAND_HOLDING_ENDPOINT;
      final response = await LandHoldingRemoteDatasource(
        dio: ApiClient().getDio(),
      ).submitLandHolding(payload, endPoint);

      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        var landholdingResponse = LandHoldingResponceModel.fromJson(
          response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY],
        );
        print('LandHoldingResponseModel => $landholdingResponse');
        return AsyncResponseHandler.right(landholdingResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Land Holding error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("LandHoldingResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Land Holding Details",
        ),
      );
    }
  }

  @override
  Future<AsyncResponseHandler<Failure, LandHoldingResponceModel>> getLandholding(
    String proposalNumber
  ) async {
    try {
      final req = {
        "proposalNumber": proposalNumber,
        "token": ApiConfig.AUTH_TOKEN
      };
      final payload = req;
      print('Land Holging get payload => $payload');
      final endPoint = ApiConfig.LAND_HOLDING_GET_API_ENDPOINT;
      final response = await LandHoldingRemoteDatasource(
        dio: ApiClient().getDio(),
      ).submitLandHolding(payload, endPoint);

      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        var landholdingResponse = LandHoldingResponceModel.fromJson(
          response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY],
        );
        print('LandHoldingResponseModel => $landholdingResponse');
        return AsyncResponseHandler.right(landholdingResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Land Holding error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("LandHoldingResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Land Holding Details",
        ),
      );
    }
  }

  @override
  Future<AsyncResponseHandler<Failure, String>> deleteLandHoldingData(LandHoldingDeleteRequest req) async {
    try {
      final payload = req.toJson();
      print('Land Holging get payload => $payload');
      final endPoint = ApiConfig.LAND_HOLDING_DELETE_API_ENDPOINT;
      final response = await LandHoldingRemoteDatasource(
        dio: ApiClient().getDio(),
      ).submitLandHolding(payload, endPoint);
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        final String responseString = response.data[ApiConfig.API_RESPONSE_ERRORMESSAGE_KEY];
        print('responseString => $responseString');
        return AsyncResponseHandler.right(responseString);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Land Holding error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch(error) {
      print("LandHoldingResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Land Holding Details",
        ),
      );
    }
  }
}
