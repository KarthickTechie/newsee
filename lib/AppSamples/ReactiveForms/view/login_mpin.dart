import 'package:flutter/material.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/sysmo_mpin.dart';

/*
@author : Gayathri B    09/05/2025
@description : This function displays a custom modal bottom sheet that serves as an MPIN 
              (Mobile Personal Identification Number) entry interface. It includes:
              - A fingerprint icon for biometric authentication.
              - Four TextFields for entering a numeric MPIN.
              - A button to navigate to the Master Download page for checking progress.

@props      :
  - BuildContext context : The context in which the modal bottom sheet is displayed.
*/

mpin(
  BuildContext context,
  AsyncResponseHandler? masterVersionCheckResponseHandler,
) {
  // show the custom modal bottom sheet

  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext modalcontext) {
      return SysmoMpin(
        masterVersionCheckResponseHandler: masterVersionCheckResponseHandler,
        pageContext: context,
      );
    },
  );
}
