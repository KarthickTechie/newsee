/* 
  @author         : Gayathri.b
  @created        : 11/06/2025
  @desc           : Abstract repository that encapsulates the method to either resolve 
                    and return lead response data or return a failure.
  
 */

import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';

abstract class LeadRepository {
  Future<AsyncResponseHandler<Failure, List<GroupLeadInbox>>> searchLead(
    LeadRequest req,
  );
}
