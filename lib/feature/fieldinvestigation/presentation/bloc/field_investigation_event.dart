part of 'field_investigation_bloc.dart';

abstract class FieldInvestigationEvent {
  const FieldInvestigationEvent();
}

class FieldInvestigationInitEvent extends FieldInvestigationEvent {
  final String proposalNumber;
  FieldInvestigationInitEvent({required this.proposalNumber});
}