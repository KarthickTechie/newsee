/*
 @created on : May 16, 2025
 @author : Akshayaa 
 @description : A custom TextInputFormatter that applies Indian Rupee style
                comma formatting (e.g. 1,00,000) while typing and allows
                only numeric digits.
*/

import 'package:flutter/services.dart';
import 'package:newsee/Utils/utils.dart';

class Rupeeformatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Removes all non digit characters and extracts only digits
    String raw = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    print('Rupeeformatter-raw $raw');

    if (raw.isEmpty) return newValue;

    // Extract last 3 digits then extract remaining digits before the last 3 digits
    // then group the remaining digits in 2s from the end
    String finalValue = formatAmount(raw);
    return TextEditingValue(
      text: finalValue,
      selection: TextSelection.collapsed(offset: finalValue.length),
    );
  }
}
