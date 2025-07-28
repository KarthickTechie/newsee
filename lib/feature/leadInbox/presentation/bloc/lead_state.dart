part of 'lead_bloc.dart';

/* 
  @author     : gayathri.b 12/05/2025
  @desc       : Encapsulates the state used in the lead search BLoC.
                Maintains the current status, API response data (LeadResponseModel),
                and any error message resulting from the lead search process.
  
*/
enum LeadStatus { initial, loading, success, failure }
// we need following state status which is defines http init , loading
// success and failure

class LeadState extends Equatable {
  final LeadStatus status;
  final List<GroupLeadInbox>? leadResponseModel;
  final String? errorMessage;
  final int currentPage;
  final int totApplication;
  final String? proposalNo;
  final SaveStatus? proposalSubmitStatus;
  final SaveStatus? getLeaStatus;
  final GetLeadResponse? getleadData;

  const LeadState({
    this.status = LeadStatus.initial,
    this.leadResponseModel,
    this.errorMessage,
    this.currentPage = 0,
    this.totApplication = 1,
    this.proposalNo,
    this.proposalSubmitStatus,
    this.getLeaStatus,
    this.getleadData
  });

  factory LeadState.init() => const LeadState();

  LeadState copyWith({
    LeadStatus? status,
    List<GroupLeadInbox>? leadResponseModel,
    String? errorMessage,
    int? currentPage,
    int? totApplication,
    String? proposalNo,
    SaveStatus? proposalSubmitStatus,
    SaveStatus? getLeaStatus,
    GetLeadResponse? getleadData
  }) {
    return LeadState(
      status: status ?? this.status,
      leadResponseModel: leadResponseModel ?? this.leadResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totApplication: totApplication ?? this.totApplication,
      proposalNo: proposalNo ?? this.proposalNo,
      proposalSubmitStatus: proposalSubmitStatus ?? this.proposalSubmitStatus,
      getLeaStatus: getLeaStatus ?? this.getLeaStatus,
      getleadData: getleadData ?? this.getleadData
    );
  }

  List<Object?> get props => [
    status,
    leadResponseModel,
    errorMessage,
    currentPage,
    totApplication,
    proposalNo,
    proposalSubmitStatus,
    getLeaStatus,
    getleadData
  ];
}
