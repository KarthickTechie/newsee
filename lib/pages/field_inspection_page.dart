import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/speech_text/bloc/speech.bloc.dart';
import 'package:newsee/feature/speech_text/bloc/speech.event.dart';
import 'package:newsee/feature/speech_text/bloc/speech.state.dart';
import 'package:newsee/widgets/textarea_field.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FieldInspectionPage extends StatelessWidget {
  const FieldInspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeechBloc(stt.SpeechToText()),
      child: const _FieldInspectPageView(),
    );
  }
}

class _FieldInspectPageView extends StatefulWidget {
  const _FieldInspectPageView({super.key});

  @override
  State<_FieldInspectPageView> createState() => _FieldInspectPageViewState();
}

class _FieldInspectPageViewState extends State<_FieldInspectPageView> {
  late final FormGroup fieldInspectionForm = AppForms.fieldInspectionForm();
  String? activeControlName;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SpeechBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("Field Inspection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SpeechBloc, SpeechState>(
          // listenWhen:
          //     (previous, current) =>
          //         previous.recognizedText != current.recognizedText ||
          //         previous.error != current.error,
          listener: (context, state) {
            print('vddd: ${state.recognizedText}, $activeControlName');
            if (activeControlName != null && state.recognizedText.isNotEmpty) {
              final control =
                  fieldInspectionForm.control(activeControlName!)
                      as FormControl<String>;
              control.value = state.recognizedText;

              context.read<SpeechBloc>().add(RecognizedTextChanged(''));
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Speech error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return ReactiveForm(
              formGroup: fieldInspectionForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) activeControlName = 'remarks';
                    },
                    child: TextareaField(
                      controlName: 'remarks',
                      label: 'Remarks',
                      mantatory: true,
                      maxLines: 5,
                      form: fieldInspectionForm,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) activeControlName = 'comment';
                    },
                    child: TextareaField(
                      controlName: 'comment',
                      label: 'Comment',
                      mantatory: true,
                      maxLines: 3,
                      form: fieldInspectionForm,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (fieldInspectionForm.valid) {
                        print(
                          "Remarks: ${fieldInspectionForm.control('remarks').value}",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Submitted successfully'),
                          ),
                        );
                      } else {
                        fieldInspectionForm.markAllAsTouched();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<SpeechBloc, SpeechState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state.isListening) {
                bloc.add(StopListening());
              } else {
                bloc.add(StartListening());
              }
            },
            backgroundColor: state.isListening ? Colors.blue : Colors.white,
            child: Icon(state.isListening ? Icons.mic_off : Icons.mic),
          );
        },
      ),
    );
  }
}
