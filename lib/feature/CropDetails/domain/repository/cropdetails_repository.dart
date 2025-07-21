import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_delete_request.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_get_response.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsresponse.dart';
import 'package:newsee/feature/CropDetails/domain/modal/croprequestmodel.dart';

abstract class CropDetailsRepository {
  Future<AsyncResponseHandler<Failure, CropDetailsResponse>> saveCrop(CropRequestModel req);
  Future<AsyncResponseHandler<Failure, CropGetResponse>> getCrop(String proposalNumber);
  Future<AsyncResponseHandler<Failure, String>> deleteCrop(CropDeleteRequest req);
}
