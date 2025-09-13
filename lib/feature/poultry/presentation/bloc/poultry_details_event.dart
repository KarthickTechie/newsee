
abstract class PoultryEvent {}

class LoadPoultryDetails extends PoultryEvent {
    final String leadId;
   LoadPoultryDetails({required this.leadId});

}

class AddPoultryDetails extends PoultryEvent {
  final Map<String, dynamic> details;
    final String leadId;

  AddPoultryDetails({required this.details, required this.leadId,
});
}

class RemovePoultryDetails extends PoultryEvent {
  final int index;
  final String leadId;
  RemovePoultryDetails({required this.index,required this.leadId,
});
}

