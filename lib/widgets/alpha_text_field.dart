/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable input field for accepting only alphabets,integrated with the reactive forms package.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AlphaTextField extends StatelessWidget {
  final String controlName;
  final String label;
  final bool mantatory;

  const AlphaTextField({
    super.key,
    required this.controlName,
    required this.label,
    required this.mantatory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ReactiveTextField<String>(
        formControlName: controlName,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[0-9]'))],
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
        validationMessages: {
          ValidationMessage.required: (error) => '$label is required',
        },
      ),
    );
  }
}
