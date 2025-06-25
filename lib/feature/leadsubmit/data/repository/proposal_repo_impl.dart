import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/feature/leadsubmit/data/datasource/lead_submit_datasource.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/proposal_creation_request.dart';
import 'package:newsee/feature/leadsubmit/domain/repository/proposal_submit_repo.dart';

/* 
@author   : karthick.d  24/06/2025
@desc     : encapsulated proposalCreation logic for better usablity across app
            and better mantenance
 */
class ProposalRepoImpl extends ProposalSubmitRepo {
  @override
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> submitProposal({
    required ProposalCreationRequest request,
  }) async {
    LeadSubmitDatasource leadSubmitDatasource = LeadSubmitDatasource(
      dio: ApiClient().getDio(),
    );

    //
    final Response response = await leadSubmitDatasource.createProposal(
      request.toMap(),
    );
    if (response.data[ApiConstants.api_response_success]) {
      print(response.data[ApiConstants.api_response_data]);
      return AsyncResponseHandler.right(
        response.data[ApiConstants.api_response_data],
      );
    } else {
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: 'Proposal Creation Failed'),
      );
    }
  }
}
