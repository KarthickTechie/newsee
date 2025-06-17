import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatAmount(String amount) {
  try {
    final num value = num.parse(amount);
    final formatter = NumberFormat.decimalPattern('en_IN');
    return formatter.format(value);
  } catch (e) {
    return amount;
  }
}

// Convert CIF Response Date to String Date(dd-MM-yyyy);
String getDateFormat(dynamic value) {
  try {
    final DateFormat parser = DateFormat("MMM dd, yyyy, hh:mm:ss a");
    DateTime date = parser.parse(value);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String convertedDateString = formatter.format(date);
    return convertedDateString;
  } catch (error) {
    print("getDateFormat-string $error");
    return "";
  }
}

// Convert Aadhaar Response Date to String Date(dd-MM-yyyy);
String getCorrectDateFormat(dynamic value) {
  try {
    DateFormat parser = DateFormat('yyyy-MM-dd');
    DateTime date = parser.parse(value);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String convertedDateString = formatter.format(date);
    return convertedDateString;
  } catch (error) {
    print("getCorrectDateFormat-string $error");
    return "";
  }
}

void showSnack(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void goToNextTab({required BuildContext context}) {
  final tabController = DefaultTabController.of(context);
  if (tabController.index < tabController.length - 1) {
    tabController.animateTo(tabController.index + 1);
  }
}
