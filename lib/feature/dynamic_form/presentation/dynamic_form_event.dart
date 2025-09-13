
import 'package:reactive_forms/reactive_forms.dart';

abstract class DynamicFormEvent {}

class AddDynamicFormDetails extends DynamicFormEvent{
  final Map<String,dynamic> details;
  AddDynamicFormDetails(this.details);
}

class RemoveDynamicFormDetails extends DynamicFormEvent{
  final int index;

  RemoveDynamicFormDetails(this.index);
}