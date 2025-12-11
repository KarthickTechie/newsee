import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/CropDetails/data/datasource/cropdetails_datasource.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_delete_request.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_get_response.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsresponse.dart';
import 'package:newsee/feature/CropDetails/domain/modal/croprequestmodel.dart';
import 'package:newsee/feature/CropDetails/domain/repository/cropdetails_repository.dart';

class CropDetailsRepositoryImpl implements CropDetailsRepository {
  @override
  Future<AsyncResponseHandler<Failure, CropDetailsResponse>> saveCrop(
    CropRequestModel req,
  ) async {
    try {
      print('Crop Details Save request payload => $req');
      final payload = req.toJson();
      print('Crop Details payload => $payload');
      final endpoint = ApiConfig.CROP_SUBMIT_API_ENDPOINT;
      var response = await CropDetailsDatasource(
        dio: ApiClient().getDio(),
      ).callCropAPI(payload, endpoint);

      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        var cropDetailsResponse = CropDetailsResponse(
          responseData: response.data['responseData'],
          ErrorMessage: response.data['ErrorMessage'],
          Success: response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY],
        );
        print('CropResponseModel => ${cropDetailsResponse.toString()}');
        return AsyncResponseHandler.right(cropDetailsResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Crop Details Save error => $errorMessage');
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: errorMessage),
        );
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cropDetailsResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Crop Details Save",
        ),
      );
    }
  }

  Future<AsyncResponseHandler<Failure, CropGetResponse>> getCrop(
    String proposalNumber,
  ) async {
    try {
      final req = {
        "proposalNumber": proposalNumber,
        "token": ApiConfig.AUTH_TOKEN,
      };
      final endpoint = ApiConfig.CROP_GET_API_ENDPOINT;
      final payload = req;
      print('Crop Details payload => $payload');
      var response = await CropDetailsDatasource(
        dio: ApiClient().getDio(),
      ).callCropAPI(payload, endpoint);
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        List<dynamic> listofvalues =
            response.data['responseData']['agriCropDetails'];
        List<CropDetailsModal> listofcrop =
            listofvalues.map((e) => CropDetailsModal.fromGetApi(e)).toList();
        var cropDetailsResponse = CropGetResponse(
          agriCropDetails: listofcrop,
          agriLandDetails: response.data['responseData']['agriLandDetails'],
          ErrorMessage: response.data['ErrorMessage'],
        );
        print('CropResponseModel => ${cropDetailsResponse.toString()}');
        return AsyncResponseHandler.right(cropDetailsResponse);
      } else if (response.data['responseData']['agriLandDetails'] != null) {
        var cropDetailsResponse = CropGetResponse(
          agriCropDetails: [],
          agriLandDetails: response.data['responseData']['agriLandDetails'],
          ErrorMessage: response.data['ErrorMessage'],
        );
        return AsyncResponseHandler.right(cropDetailsResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Crop Details Save error => $errorMessage');
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: errorMessage),
        );
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cropDetailsResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Crop Details Get",
        ),
      );
    }
  }

  Future<AsyncResponseHandler<Failure, String>> deleteCrop(
    CropDeleteRequest req,
  ) async {
    try {
      final endpoint = ApiConfig.CROP_DELETE_API_ENDPOINT;
      final payload = req.toJson();
      print('Crop Details payload => $payload');
      var response = await CropDetailsDatasource(
        dio: ApiClient().getDio(),
      ).callCropAPI(payload, endpoint);
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        String cropDeleteMessage =
            response.data[ApiConfig.API_RESPONSE_ERRORMESSAGE_KEY];
        return AsyncResponseHandler.right(cropDeleteMessage);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Crop Details Save error => $errorMessage');
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: errorMessage),
        );
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cropDetailsResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Crop Details Get",
        ),
      );
    }
  }
}
