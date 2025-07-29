import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class TextareaField extends StatelessWidget {
  final String controlName;
  final String label;
  final bool mantatory;
  final int maxLines;
  final FormGroup form;
  // final Widget? suffixIcon;

  const TextareaField({
    super.key,
    required this.controlName,
    required this.label,
    required this.mantatory,
    required this.maxLines,
    required this.form,
    // this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: controlName,
      maxLines: maxLines,
      validationMessages: {
        ValidationMessage.required: (_) => '$label is required',
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        // suffixIcon: suffixIcon,
      ),
    );
  }
}
