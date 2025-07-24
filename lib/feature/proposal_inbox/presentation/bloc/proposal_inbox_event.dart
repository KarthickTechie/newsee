part of 'proposal_inbox_bloc.dart';

abstract class ProposalInboxEvent {
  const ProposalInboxEvent();
}
// bloc event type that will be called when Login button clicked

class SearchProposalInboxEvent extends ProposalInboxEvent {
  final LeadInboxRequest request;

  const SearchProposalInboxEvent({required this.request});
}

class ApplicationStatusCheckEvent extends ProposalInboxEvent {
  final Map<String, dynamic> currentApplication;
  const ApplicationStatusCheckEvent({required this.currentApplication});
}
