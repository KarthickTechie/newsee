import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/application_status_response.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/proposal_inbox_responce_model.dart';

abstract class ProposalInboxRepository {
  Future<AsyncResponseHandler<Failure, ProposalInboxResponseModel>>
  searchProposalInbox(LeadInboxRequest req);
  Future<AsyncResponseHandler<Failure, ApplicationStatusResponse>> getApplicationStatus(req);
}
