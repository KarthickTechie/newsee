/* 
  @author     : gayathri.b 12/06/2025
  @desc       : BLoC class that encapsulates business logic for lead search feature.
                Listens to LeadEvent events and emits updated LeadState based on repository responses.
  @param      : LeadEvent, LeadState
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/leadInbox/data/repository/lead_respository_impl.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/domain/repository/lead_repository.dart';

part 'lead_event.dart';
part 'lead_state.dart';

class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadRepository leadRepository;

  LeadBloc({LeadRepository? repository})
    : leadRepository = repository ?? LeadRepositoryImpl(),
      super(LeadState()) {
    on<SearchLeadEvent>(onSearchLead);
  }

  Future<void> onSearchLead(
    SearchLeadEvent event,
    Emitter<LeadState> emit,
  ) async {
    emit(state.copyWith(status: LeadStatus.loading));
    UserDetails? userDetails = await loadUser();
    LeadInboxRequest request = LeadInboxRequest(
      userid: userDetails!.LPuserID,
      pageNo: event.pageNo,
      pageCount: event.pageCount,
      token: ApiConstants.api_qa_token,
    );

    final response = await leadRepository.searchLead(request);
    // check if response i success and contains valid data , success status is emitted

    if (response.isRight()) {
      emit(
        state.copyWith(
          status: LeadStatus.success,
          leadResponseModel: response.right,
          currentPage: event.pageNo + 1        ),
      );
    } else {
      print('Lead failure response.left');
      emit(
        state.copyWith(
          status: LeadStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
