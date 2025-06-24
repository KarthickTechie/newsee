import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/leadsubmit/data/repository/lead_submit_repo_impl.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/dedupe.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/lead_submit_request.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_product.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_type.dart';
import 'package:newsee/feature/leadsubmit/domain/repository/lead_submit_repo.dart';

part './lead_submit_event.dart';
part './lead_submit_state.dart';

/* 
@author   : karthick.d  13/06/2025
@desc     : submiting lead business logic
 */
final class LeadSubmitBloc extends Bloc<LeadSubmitEvent, LeadSubmitState> {
  LeadSubmitBloc() : super(LeadSubmitState.init()) {
    on<LeadSubmitPageInitEvent>(onLeadSubmitPageInit);
    on<LeadSubmitPushEvent>(onLeadPush);
  }

  Future<void> onLeadSubmitPageInit(
    LeadSubmitPageInitEvent event,
    Emitter emit,
  ) async {
    PersonalData? personalData = event.personalData;
    LeadSubmitRequest leadSubmitRequest = LeadSubmitRequest(
      userid: '',
      vertical: '7',
      orgScode: '',
      orgName: '',
      orgLevel: '',
      token: '',
      leadDetails: LoanType(),
      chooseProduct: LoanProduct(
        mainCategory: '',
        subCategory: '',
        producrId: '',
      ),
      dedupeSearch: Dedupe(
        existingCustomer: false,
        cifNumber: '',
        constitution: '',
      ),
      individualNonIndividualDetails: personalData ?? null,
      addressDetails: AddressData(),
    );
    emit(state.copyWith(leadSubmitRequest: leadSubmitRequest));
  }

  Future<void> onLeadPush(LeadSubmitPushEvent event, Emitter emit) async {
    try {
      Map<String, dynamic> leadSubmitRequest = {
        "userid": "AGRI1124",
        "vertical": "7",
        "orgScode": "14356",
        "orgName": "BRAHMAMANGALAM",
        "orgLevel": "23",
        "token":
            "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
        "leadDetails": event.loanType.toMap(),
        "chooseProduct": event.loanProduct.toMap(),
        "dedupeSearch": event.dedupe.toMap(),
        "individualNonIndividualDetails": event.personalData?.toMap(),
        "addressDetails": [event.addressData?.toMap()],
      };

      AsyncResponseHandler<Failure, Map<String, dynamic>> responseHandler =
          await LeadSubmitRepoImpl().submitLead(request: leadSubmitRequest);
      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        String leadId = response['saveLeadDetails']['lleadid'] as String;

        print('Lead Submit Success..');
        emit(
          state.copyWith(
            leadSubmitStatus: SubmitStatus.success,
            leadId: leadId,
          ),
        );
      } else {
        print('Lead Submit Failure...');
        emit(state.copyWith(leadSubmitStatus: SubmitStatus.failure));
      }
    } on DioException catch (e) {
      print('leadsubmit exception => $e');
    } finally {
      emit(state.copyWith(leadSubmitStatus: SubmitStatus.success));
    }
  }
}
