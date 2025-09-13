import 'package:equatable/equatable.dart';

abstract class DairyDetailsEvent{
  const DairyDetailsEvent();

}

/// Event to load all saved details for a given lead.
class LoadDetails extends DairyDetailsEvent {
  final String leadId;

  const LoadDetails({required this.leadId});

 
}

/// Event to add/save details for a given lead.
class AddDetails extends DairyDetailsEvent {
  final String leadId;
  final Map<String, dynamic> detail;

  const AddDetails({
    required this.detail,
    required this.leadId,
  });

}

/// Event to delete a specific detail by index for a given lead.
class DeleteDetails extends DairyDetailsEvent {
  final int index;
  final String leadId;

  const DeleteDetails({
    required this.index,
    required this.leadId,
  });


}
