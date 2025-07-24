import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/group_proposal_inbox.dart';
import 'package:reactive_forms/reactive_forms.dart';

String formatAmount(String amount) {
  try {
    final num value = num.parse(amount);
    final formatter = NumberFormat.decimalPattern('en_IN');
    // return '₹${formatter.format(value)}';
    // final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
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

// Split Aadhaar Address String more than 40 digit and return string data
String? addressSplit(String str) {
  try {
    if (str == "") {
      return str;
    } else {
      if (str[0] == " ") {
        str = str.trim();
      }
      // let first = str.substring(0, 40).lastIndexOf(',')
      String? line1;
      if (str.length < 40) {
        line1 = str;
      } else {
        final first = str.substring(0, 40).lastIndexOf(' ');
        if (first < 0) {
          line1 = str.substring(0);
        } else {
          line1 = str.substring(0, first + 1);
        }
      }
      return line1;
    }
  } catch (error) {
    print("error catching $error");
    return null;
  }
}

/// @desc   : converts date by provided arguments
/// @param  : {from} - date to be formated , {to} will be retured formatted string
/// @return : {String} - formatted date

String getDateFormatedByProvided(
  dynamic value, {
  required String from,
  required String to,
}) {
  try {
    DateFormat parser = DateFormat(from);
    DateTime date = parser.parse(value);
    DateFormat formatter = DateFormat(to);
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
  if (tabController.index < tabController.length - 1)  {
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

CoapplicantData mapCoapplicantDataFromCif(CifResponse response) {
  String mobileno = '';
  if (response.lleadmobno!.length == 12 &&
      response.lleadmobno!.startsWith("91")) {
    mobileno = response.lleadmobno!.substring(2);
  }

  CoapplicantData data = CoapplicantData(
    firstName: response.lleadfrstname,
    lastName: response.lleadlastname,
    email: response.lleademailid,
    primaryMobileNumber: mobileno != '' ? mobileno : response.lleadmobno,
    panNumber: response.lleadpanno,
    address1: response.lleadaddress,
    address2: response.lleadaddresslane1,
    address3: response.lleadaddresslane2,
    pincode: response.lleadpinno,
    cifNumber: response.lldCbsid,
    aadharRefNo: response.lleadadharno,
    dob: getDateFormat(response.lleaddob),
    loanLiabilityCount: response.liabilityCount,
    loanLiabilityAmount: response.liabilityAmount,
    depositCount: response.depositCount,
    depositAmount: response.depositAmount,
    constitution: response.cifFlag,
    title: response.lleadtitle,
  );

  print('mapCoapplicantDataFromCif => $data');
  return data;
}

/// @desc   : Remove rupee seperator from form value
/// @param  : {from} - String value from form , {to} will be retured removed comma from string value
/// @return : {String} - string data
String? removeSpecialCharacters(String formval) {
  try {
    String raw = formval.replaceAll(RegExp(r'[^\d]'), '');
    return raw;
  } catch (error) {
    print('removeSpecialCharacters-utilspage => $error');
  }
}

List<GroupLeadInbox>? onSearchLeadInbox({
  required List<GroupLeadInbox>? items,
  required String searchQuery,
}) {
  final filteredLeads =
      items?.where((lead) {
        final name = (lead.finalList!['lleadfrstname'] ?? '').toLowerCase();
        final id = (lead.finalList!['lleadid'] ?? '').toLowerCase();
        final phone = (lead.finalList!['lleadmobno'] ?? '').toLowerCase();
        final loan = (lead.finalList!['lldLoanamtRequested'] ?? '').toString();
        return name.contains(searchQuery.toLowerCase()) ||
            id.contains(searchQuery.toLowerCase()) ||
            phone.contains(searchQuery.toLowerCase()) ||
            loan.contains(searchQuery.toLowerCase());
      }).toList();
  return filteredLeads;
}

List<GroupProposalInbox>? onSearchApplicationInbox({
  required List<GroupProposalInbox>? items,
  required String searchQuery,
}) {
  final filteredLeads =
      items?.where((lead) {
        final name = (lead.finalList['lleadfrstname'] ?? '').toLowerCase();
        final propNo = (lead.finalList!['propNo'] ?? '').toString();
        final id = (lead.finalList['lleadid'] ?? '').toLowerCase();
        final phone = (lead.finalList['lleadmobno'] ?? '').toLowerCase();
        final loan = (lead.finalList['lldLoanamtRequested'] ?? '').toString();
        return name.contains(searchQuery.toLowerCase()) ||
            propNo.contains(searchQuery.toLowerCase()) ||
            id.contains(searchQuery.toLowerCase()) ||
            phone.contains(searchQuery.toLowerCase()) ||
            loan.contains(searchQuery.toLowerCase());
      }).toList();
  return filteredLeads;
}
