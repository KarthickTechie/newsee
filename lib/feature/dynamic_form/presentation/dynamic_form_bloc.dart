import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/dynamic_form/presentation/dynamic_form_event.dart';
import 'package:newsee/feature/dynamic_form/presentation/dynamic_form_state.dart';

final class DynamicFormBloc extends Bloc<DynamicFormEvent, DynamicFormState> {
  DynamicFormBloc() : super(DynamicFormState(addDetails: [])) {
    on<AddDynamicFormDetails>(_addFormDetails);
    on<RemoveDynamicFormDetails>(_onRemove);
  }

  Future<void> _addFormDetails(
    AddDynamicFormDetails event,
    Emitter<DynamicFormState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DynamicFormstatus.loading));
      await Future.delayed(Duration(seconds: 1));

      final updated = List<Map<String, dynamic>>.from(state.addDetails)
        ..add(event.details);

      emit(
        state.copyWith(
          addDetails: updated,
          status: DynamicFormstatus.success,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DynamicFormstatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemove(
    RemoveDynamicFormDetails event,
    Emitter<DynamicFormState> emit,
  ) async {
    try {
      final updatedList =
          List<Map<String, dynamic>>.from(state.addDetails)..removeAt(event.index);

      print("final updatedList $updatedList");

      emit(
        state.copyWith(
          addDetails: updatedList,
          status: DynamicFormstatus.delete,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addDetails: [],
          status: DynamicFormstatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
