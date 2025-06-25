part of './lead_submit_bloc.dart';

enum SubmitStatus { init, loading, success, failure }

class LeadSubmitState extends Equatable {
  final String? leadId;
  final LeadSubmitRequest? leadSubmitRequest;
  final SubmitStatus leadSubmitStatus;
  final String? proposalNo;
  final SaveStatus? proposalSubmitStatus;

  LeadSubmitState({
    required this.leadId,
    required this.leadSubmitRequest,
    required this.leadSubmitStatus,
    required this.proposalNo,
    required this.proposalSubmitStatus,
  });

  factory LeadSubmitState.init() => LeadSubmitState(
    leadId: null,
    leadSubmitRequest: null,
    leadSubmitStatus: SubmitStatus.init,
    proposalNo: null,
    proposalSubmitStatus: SaveStatus.init,
  );

  LeadSubmitState copyWith({
    String? leadId,
    LeadSubmitRequest? leadSubmitRequest,
    SubmitStatus? leadSubmitStatus,
    String? proposalNo,
    SaveStatus? proposalSubmitStatus,
  }) {
    return LeadSubmitState(
      leadId: leadId ?? this.leadId,
      leadSubmitRequest: leadSubmitRequest ?? this.leadSubmitRequest,
      leadSubmitStatus: leadSubmitStatus ?? this.leadSubmitStatus,
      proposalNo: proposalNo ?? this.proposalNo,
      proposalSubmitStatus: proposalSubmitStatus ?? this.proposalSubmitStatus,
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
  ];
}
