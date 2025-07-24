import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/feature/documentupload/data/datasource/document_datasource.dart';
import 'package:newsee/feature/documentupload/domain/repository/documents_repo.dart';

class GetDocumentRepoImpl extends GetDocumentsRepo {
  @override
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> getDocuments({
    required Map<String, dynamic> request,
  }) async {
    DocumentDataSource documentdatasource = DocumentDataSource(
      dio: ApiClient().getDio(),
    );

    var response = await documentdatasource.getDocuments(request);
    if (response.data[ApiConstants.api_response_success]) {
      print('docResponse: ${response.data['responseData']}');
      return AsyncResponseHandler.right(
        response.data[ApiConstants.api_response_data],
      );
    } else {
      String errorMessage = response.data['ErrorMessage'];
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: errorMessage),
      );
    }
  }
}
