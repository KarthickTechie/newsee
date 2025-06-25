import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';

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

CoappDetailsState mapGeographyMasterResponseForCoAppPage(
  CoappDetailsState state,
  AsyncResponseHandler response,
) {
  if (response.isRight()) {
    Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

    List<GeographyMaster> cityMaster =
        _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
            ? _resp['cityMaster'] as List<GeographyMaster>
            : [];
    List<GeographyMaster> districtMaster =
        _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
            ? _resp['districtMaster'] as List<GeographyMaster>
            : [];
    // map
    return state.copyWith(
      status: SaveStatus.mastersucess,
      cityMaster: cityMaster,
      districtMaster: districtMaster,
    );
  } else {
    return state.copyWith(
      status: SaveStatus.masterfailure,
      cityMaster: [],
      districtMaster: [],
    );
  }
}

AddressDetailsState mapGeographyMasterResponseForAddressPage(
  AddressDetailsState state,
  AsyncResponseHandler response,
) {
  if (response.isRight()) {
    Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

    List<GeographyMaster>? cityMaster =
        _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
            ? _resp['cityMaster'] as List<GeographyMaster>
            : state.cityMaster;
    List<GeographyMaster>? districtMaster =
        _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
            ? _resp['districtMaster'] as List<GeographyMaster>
            : state.districtMaster;
    // map
    return state.copyWith(
      status: SaveStatus.mastersucess,
      cityMaster: cityMaster,
      districtMaster: districtMaster,
    );
  } else {
    return state.copyWith(
      status: SaveStatus.masterfailure,
      cityMaster: [],
      districtMaster: [],
    );
  }
}

void closeBottomSheetIfExists(BuildContext context) {
  // Check if the current route is a bottom sheet (ModalBottomSheetRoute)
  if (ModalRoute.of(context)?.isCurrent == true &&
      ModalRoute.of(context) is ModalBottomSheetRoute) {
    // Check if the route can be popped
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
