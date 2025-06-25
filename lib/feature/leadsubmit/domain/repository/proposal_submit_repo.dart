import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/proposal_creation_request.dart';

abstract class ProposalSubmitRepo {
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> submitProposal({
    required ProposalCreationRequest request,
  });
}
