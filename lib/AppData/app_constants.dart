import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstants {
  static final RegExp PATTERN_SPECIALCHAR = RegExp(
    r'[\*\%!$\^.,;:{}\(\)\-_+=\[\]]',
  );

  static final RegExp PAN_PATTERN = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  static final RegExp AADHAAR_PATTERN = RegExp('[0-9]{12}');

  static final RegExp PATTER_ONLYALPHABET = RegExp(r'(\w+)');
}

class BioMetricResult {
  final String message;
  final bool status;

  BioMetricResult({required this.message, required this.status});
}

class FilePickingOptionList {
  final IconData icon;
  final String title;
  FilePickingOptionList({required this.icon, required this.title});
}

enum SaveStatus {
  init,
  loading,
  success,
  failure,
  update,
  mastersucess,
  masterfailure,
}
