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

  const LeadState({
    this.status = LeadStatus.initial,
    this.leadResponseModel,
    this.errorMessage,
  });

  factory LeadState.init() => const LeadState();

  LeadState copyWith({
    LeadStatus? status,
    List<GroupLeadInbox>? leadResponseModel,
    String? errorMessage,
  }) {
    return LeadState(
      status: status ?? this.status,
      leadResponseModel: leadResponseModel ?? this.leadResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, leadResponseModel, errorMessage];
}
