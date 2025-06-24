import 'package:flutter/material.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';

class DocumentForm extends StatefulWidget {
  const DocumentForm({super.key});

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();

    form = FormGroup({
      'docClassification': FormControl<String>(
        validators: [Validators.required],
      ),
    });
    context.read<DocumentBloc>().formKey = form;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DocumentBloc>();

    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Documents"),
          const SizedBox(height: 24),

          BlocBuilder<DocumentBloc, DocumentState>(
            builder: (context, state) {
              return ReactiveDropdownField<String>(
                formControlName: 'docClassification',
                decoration: const InputDecoration(
                  labelText: 'Document',
                  border: OutlineInputBorder(),
                ),
                items:
                    state.docTypeList
                        .map(
                          (doc) => DropdownMenuItem(
                            value: doc.code,
                            child: Text(doc.desc),
                          ),
                        )
                        .toList(),
                onChanged: (control) {
                  final value = control.value;
                  if (value != null) {
                    context.read<DocumentBloc>().add(SelectDocTypeEvent(value));
                  }
                },
                validationMessages: {
                  ValidationMessage.required: (_) => 'This field is required',
                },
              );
            },
          ),
          const SizedBox(height: 24),

          //  Add Button
          Center(
            child: ReactiveFormConsumer(
              builder: (context, formGroup, _) {
                return ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed:
                      formGroup.valid && !bloc.state.disableBtn
                          ? () {
                            final selected =
                                form.control('docClassification').value;
                            print('Submitting document with code: $selected');
                            bloc.add(AddDocEvent());
                            form.reset();
                            Navigator.of(context).pop(); // close bottom sheet
                          }
                          : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
