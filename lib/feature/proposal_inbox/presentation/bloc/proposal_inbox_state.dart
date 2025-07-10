part of 'proposal_inbox_bloc.dart';

enum ProposalInboxStatus { init, loading, success, failure }
// we need following state status which is defines http init , loading
// success and failure

class ProposalInboxState extends Equatable {
  final ProposalInboxStatus status;
  final List<ProposalInboxResponseModel>? proposalResponseModel;
  final String? errorMessage;
  final int currentPage ;


  const ProposalInboxState({
    this.status = ProposalInboxStatus.init,
    this.proposalResponseModel,
    this.errorMessage,
    this.currentPage = 1  ,

    
  });

  factory ProposalInboxState.init() => const ProposalInboxState();

  ProposalInboxState copyWith({
    ProposalInboxStatus? status,
    List<ProposalInboxResponseModel>? proposalResponseModel,
    String? errorMessage,
        int? currentPage,

  }) {
    return ProposalInboxState(
      status: status ?? this.status,
      proposalResponseModel:
          proposalResponseModel ?? this.proposalResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
            currentPage:currentPage ?? this.currentPage

    );
  }

  @override
  List<Object?> get props => [status, proposalResponseModel, errorMessage];
}
