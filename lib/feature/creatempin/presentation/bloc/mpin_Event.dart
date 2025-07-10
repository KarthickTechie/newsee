abstract class MpinEvent {}

class UpdateMpin extends MpinEvent {
  final int index;
  final String value;
  UpdateMpin(this.index, this.value);
}

class UpdateConfirmMpin extends MpinEvent {
  final int index;
  final String value;
  UpdateConfirmMpin(this.index, this.value);
}

class SubmitMpin extends MpinEvent {}
