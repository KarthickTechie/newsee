import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: constant_identifier_names

class AppConstants {
  static final RegExp PATTERN_SPECIALCHAR = RegExp(
    r'[\*\%!$\^.,;:{}\(\)\-_+=\[\]]',
  );

  static final RegExp PAN_PATTERN = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  static final RegExp AADHAAR_PATTERN = RegExp('[0-9]{12}');

  static final RegExp PATTER_ONLYALPHABET = RegExp(r'(\w+)');

  static const String CREATE_PROPOSAL = 'Create Proposal';
  static const String GOTO_INBOX = "GoTo Inbox";

  static const String Format_yyyy_MM_dd = 'yyyy-MM-dd';
  static const String Format_dd_MM_yyyy = 'dd-MM-yyyy';
  static const int PAGINATION_ITEM_PER_PAGE = 5;
  static const String GLOBAL_API_ERROR_MESSAGE = 'Something went wrong';
  static const String GLOBAL_NO_DATA_FOUND = 'No Data found';
  static const String GLOBAL_COULD_NOT_LAUNCH = 'Could not launch';
  static const String FAILED_TO_LOAD_PDF_MESSAGE = 'Failed to load PDF';
  static const String OK = 'OK';
  static const bool SHOW_LOG = true;

  static const String downloadingCibil = 'Downloading CIBIL Report...';
  static const String downloadingCrif = 'Downloading CRIF Report...';
  static const String creatingCibil = 'Creating CIBIL Report...';
  static const String creatingCrif = 'Creating CRIF Report...';
  static const String appLabelApplicant = 'Applicant';
  static const String appLabelCoApplicant = 'Co-Applicant';
  static const String remoteUrlCibilReport =
      'http://www.policywala.com/downloads/Sample-CIBIL-CIR-Report.pdf';
  static const String remoteUrlCrifReport =
      'https://www.crifhighmark.com/media/2989/company-credit-reportp-sample.pdf';
  static const String applicantCibilReportFileName = 'ApplicantCIBIL.pdf';
  static const String applicantCrifReportFileName = 'ApplicantCRIF.pdf';
  static const String coappCibilReportFileName = 'ApplicantCIBIL.pdf';
  static const String coappCrifReportFileName = 'ApplicantCRIF.pdf';
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
  edit,
  update,
  reset,
  delete,
  mastersucess,
  masterfailure,
  dedupesuccess,
  dedupefailure,
}
