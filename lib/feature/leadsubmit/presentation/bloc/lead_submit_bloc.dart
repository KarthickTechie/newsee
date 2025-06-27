import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/leadsubmit/data/repository/lead_submit_repo_impl.dart';
import 'package:newsee/feature/leadsubmit/data/repository/proposal_repo_impl.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/dedupe.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/lead_submit_request.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_product.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_type.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/proposal_creation_request.dart';
import 'package:newsee/feature/leadsubmit/domain/repository/lead_submit_repo.dart';
import 'package:newsee/feature/leadsubmit/domain/repository/proposal_submit_repo.dart';

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
    on<CreateProposalEvent>(onCreateProposalRequest);
    // on<InitPreferenceEvent>(onInitPreference);
  }

  // Future<void> onInitPreference(InitPreferenceEvent event, Emitter emit) async {
  //   final orgCode = event.loginMap['Orgscode'];
  //   final userId = event.loginMap['LPuserID'];
  //   final userName = event.loginMap['UserName'];

  //   print(
  //     "Loaded from SharedPrefs => Org: $orgCode, ID: $userId, Name: $userName",
  //   );

  //   emit(state.copyWith(orgCode: orgCode, userId: userId, userName: userName));
  // }

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
    final coappdataMap = event.coapplicantData?.toMap();
    coappdataMap?.addAll({"residentialStatus": "4"});
    try {
      Map<String, dynamic> leadSubmitRequest = {
        "userid": state.userId ?? "AGRI1124",
        "vertical": "7",
        "orgScode": state.orgCode ?? "14356",
        "orgName": "BRAHMAMANGALAM",
        "orgLevel": "23",
        "coapplicantRequired": event.coapplicantData != null ? 'Y' : 'N',
        "guarantorRequired": 'N',
        "token":
            "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
        "leadDetails": event.loanType.toMap(),
        "chooseProduct": event.loanProduct.toMap(),
        "dedupeSearch": event.dedupe.toMap(),
        "individualNonIndividualDetails": event.personalData?.toMap(),
        "addressDetails": [event.addressData?.toMap()],
        "coApplicantDetils": event.coapplicantData != null ? coappdataMap : {},
        "guarantorDetils": {},
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
      emit(state.copyWith(leadSubmitStatus: SubmitStatus.failure));
    }
  }

  Future<void> onCreateProposalRequest(
    CreateProposalEvent event,
    Emitter emit,
  ) async {
    try {
      ProposalCreationRequest proposalCreationRequest = ProposalCreationRequest(
        leadId: event.proposalCreationRequest.leadId ?? state.leadId,
        userid:
            event.proposalCreationRequest.userid ?? ApiConstants.api_qa_userid,
        token: event.proposalCreationRequest.token ?? ApiConstants.api_qa_token,
      );
      print('proposalCreationRequest => $proposalCreationRequest');

      final responseHandler = await ProposalRepoImpl().submitProposal(
        request: proposalCreationRequest,
      );
      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        String proposalNumber =
            response[ApiConstants.api_response_proposalNumber];
        emit(
          state.copyWith(
            proposalNo: proposalNumber,
            proposalSubmitStatus: SaveStatus.success,
          ),
        );
      } else {
        emit(state.copyWith(proposalSubmitStatus: SaveStatus.failure));
      }
    } on Exception catch (e) {
      print('Proposal Creation Request Error => $e');
      emit(state.copyWith(proposalSubmitStatus: SaveStatus.failure));
    }
  }
}
