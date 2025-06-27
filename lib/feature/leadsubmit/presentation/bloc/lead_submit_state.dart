part of './lead_submit_bloc.dart';

enum SubmitStatus { init, loading, success, failure }

class LeadSubmitState extends Equatable {
  final String? leadId;
  final LeadSubmitRequest? leadSubmitRequest;
  final SubmitStatus leadSubmitStatus;
  final String? proposalNo;
  final SaveStatus? proposalSubmitStatus;

  // final String? orgCode;
  // final String? userId;
  // final String? userName;

  LeadSubmitState({
    required this.leadId,
    required this.leadSubmitRequest,
    required this.leadSubmitStatus,
    required this.proposalNo,
    required this.proposalSubmitStatus,
    // required this.orgCode,
    // required this.userId,
    // required this.userName,
  });

  factory LeadSubmitState.init() => LeadSubmitState(
    leadId: null,
    leadSubmitRequest: null,
    leadSubmitStatus: SubmitStatus.init,
    proposalNo: null,
    proposalSubmitStatus: SaveStatus.init,
    // orgCode: null,
    // userId: null,
    // userName: null,
  );

  LeadSubmitState copyWith({
    String? leadId,
    LeadSubmitRequest? leadSubmitRequest,
    SubmitStatus? leadSubmitStatus,
    String? proposalNo,
    SaveStatus? proposalSubmitStatus,
    // String? orgCode,
    // String? userId,
    // String? userName,
  }) {
    return LeadSubmitState(
      leadId: leadId ?? this.leadId,
      leadSubmitRequest: leadSubmitRequest ?? this.leadSubmitRequest,
      leadSubmitStatus: leadSubmitStatus ?? this.leadSubmitStatus,
      proposalNo: proposalNo ?? this.proposalNo,
      proposalSubmitStatus: proposalSubmitStatus ?? this.proposalSubmitStatus,
      // orgCode: orgCode ?? this.orgCode,
      // userId: userId ?? this.userId,
      // userName: userName ?? this.userName,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    leadId,
    leadSubmitRequest,
    leadSubmitStatus,
    proposalNo,
    proposalSubmitStatus,
    // orgCode,
    // userId,
    // userName,
  ];
}
