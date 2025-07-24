import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

PinTheme getPinTheme() {
  return PinTheme(
    shape: PinCodeFieldShape.underline,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 50,
    fieldWidth: 40,
    activeFillColor: Colors.white,
    activeColor: Colors.black,
    inactiveColor: Colors.black,
    inactiveFillColor: Colors.white,
    selectedFillColor: Colors.grey.shade200,
    activeBorderWidth: 1,
    inactiveBorderWidth: 1,
  );
}
