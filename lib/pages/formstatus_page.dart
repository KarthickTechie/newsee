import 'package:flutter_bloc/flutter_bloc.dart';

enum FormStatus { saved, unsaved }

class FormState {
  final Map<String, FormStatus> forms;

  FormState({required this.forms});

  FormState copyWith({Map<String, FormStatus>? forms}) {
    return FormState(forms: forms ?? this.forms);
  }
}

class FormStateCubit extends Cubit<FormState> {
  FormStateCubit()
      : super(FormState(
          forms: {
            'loanPage': FormStatus.saved,
            'personalPage': FormStatus.saved,
            'addressPage': FormStatus.saved,
            'otherPage': FormStatus.saved,
            'submitPage': FormStatus.saved,
          },
        ));

  void markFormAsDirty(String formName) {
    emit(
      state.copyWith(
        forms: {...state.forms, formName: FormStatus.unsaved},
      ),
    );
  }

  void markFormAsSaved(String formName) {
    emit(
      state.copyWith(
        forms: {...state.forms, formName: FormStatus.saved},
      ),
    );
  }

  bool isFormUnsaved() {
    return state.forms.values.contains(FormStatus.unsaved);
  }
}
