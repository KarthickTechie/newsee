/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable reactive text field integrated with the reactive forms package.
*/

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTextField extends StatelessWidget {
  final String controlName;
  final String label;
  final bool mantatory;
  bool? autoCapitalize;
  int? maxlength;

  CustomTextField({
    super.key,
    required this.controlName,
    required this.label,
    required this.mantatory,
    this.autoCapitalize,
    this.maxlength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        maxLength: maxlength,
        textCapitalization:
            autoCapitalize == true
                ? TextCapitalization.characters
                : TextCapitalization.none,
        validationMessages: {
          ValidationMessage.required: (error) => '$label is required',
          ValidationMessage.email: (error) => 'Enter valid $label',
        },
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: mantatory ? ' *' : '',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
