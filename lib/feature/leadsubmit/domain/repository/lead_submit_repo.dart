import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/lead_submit_request.dart';

abstract class LeadSubmitRepo {
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>> submitLead({
    required Map<String, dynamic> request,
  });
}
