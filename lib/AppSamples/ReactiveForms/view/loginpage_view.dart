import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:newsee/Utils/local_biometric.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/feature/globalconfig/bloc/global_config_bloc.dart';
import 'package:newsee/feature/pdf_viewer/presentation/pages/pdf_viewer_page.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../feature/forgetmpin/presentation/page/forgetpassword.dart';
import 'maintain.dart';
import 'reachus.dart';
import 'more.dart';
import 'login_mpin.dart';

/*
author : Gayathri B 
description : A stateless widget that serves as the main login screen for the app. It offers
              users multiple ways to authenticate and access frequently used features:
            - Login using fingerprint (biometric authentication)
              - Login with account  username and password
              - Login using mPIN
              - Option to reset mPIN via action sheet
              - Access to additional options like Maintenance, Reach Us, and More

 */

class LoginpageView extends StatelessWidget {
  Future fingerPrintScanner(context) async {
    final result =
        await GetIt.instance
            .get<BioMetricLogin>()
            .biometricAuthenticationWithKey();
    final user = await loadUser();

    print(
      ' biometric auth response => ${result.message} :: ${result.status} user :: ${user?.LPuserID}',
    );
  }

  /* 
@author     : karthick.d  07/08/2025
@desc       : when panning gesture detected with 2 finger pointers
              opening bottomsheet , when clicking enable offline mode
              will set the 
 */
  Widget renderSettingWidget(BuildContext context, GlobalConfigState state) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          OptionsSheet(
            icon:
                state.globalconfig.operationNetwork == OperationNetwork.online
                    ? Icons.signal_wifi_connected_no_internet_4
                    : Icons.network_wifi,
            title:
                state.globalconfig.operationNetwork == OperationNetwork.online
                    ? "Enable Offline Mode"
                    : "Enable Online Mode",
            subtitle: "Hassle-free Lead Onboarding",
            onTap: () {
              // set operation network value based on which offline feature enabled
              if (state.globalconfig.operationNetwork ==
                  OperationNetwork.online) {
                context.read<GlobalConfigBloc>().add(
                  NetworkChangedEvent(
                    Globalconfig.fromValue(network: OperationNetwork.offline),
                  ),
                );
              } else {
                context.read<GlobalConfigBloc>().add(
                  NetworkChangedEvent(
                    Globalconfig.fromValue(network: OperationNetwork.online),
                  ),
                );
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    //Header section of the landing page
    return Scaffold(
      body: BlocConsumer<GlobalConfigBloc, GlobalConfigState>(
        listener: (context, state) {
          print('on bloc listener => ${state.globalconfig.operationNetwork}');
        },
        builder:
            (context, state) => GestureDetector(
              onScaleEnd: (details) {
                print(
                  'SCALE END DETAILS => velocity : ${details.velocity} scalevelocity ${details.scaleVelocity} pointerCount : ${details.pointerCount}',
                );
                if (details.pointerCount >= 2) {
                  //openBottomSheet(context, 0.3, 0.2, 0.9, renderSettingWidget);
                  showBottomSheet(
                    backgroundColor: Colors.amber,
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.2),
                    context: context,
                    builder: (modalcontext) {
                      return renderSettingWidget(context, state);
                    },
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.31,
                    child: SvgPicture.asset(
                      'assets/app_background_2.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: double.infinity,

                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(0),
                              //     topRight: Radius.circular(0),
                              //   ),
                              //   gradient: LinearGradient(
                              //     colors: [
                              //       const Color(0xC5F1ECF1),
                              //       Colors.white,
                              //     ],
                              //     begin: Alignment.topCenter,
                              //     end: Alignment.bottomCenter,
                              //   ),
                              // ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: screenHeight * 0.03),

                                  //Login using fingerprint (biometric authentication)
                                  IconButton(
                                    onPressed: () {
                                      fingerPrintScanner(context);
                                    },
                                    icon: Icon(Icons.fingerprint),
                                    iconSize: screenWidth * 0.18,
                                    color: const Color.fromARGB(255, 3, 9, 110),
                                  ),

                                  Text(
                                    "Login with Fingerprint",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  // users multiple ways to authenticate and access frequently used features
                                  Text(
                                    "Frequently used features & special offers at your fingertips",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.06),

                                  // this function returns a widget that is a row with icon button
                                  // served as quick links to access other apk files for other loans
                                  //quickLink(screenHeight, screenWidth),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Login with account  username and password
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.12,
                            ),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  loginActionSheet(
                                    context,
                                    state.globalconfig.operationNetwork,
                                    createMPIN: false,
                                  );
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginBlocProvide()),);
                                },
                                icon: Icon(Icons.login, color: Colors.white),
                                label: Text(
                                  "Login with Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    double.infinity,
                                    screenHeight * 0.06,
                                  ),

                                  backgroundColor: const Color.fromARGB(
                                    246,
                                    4,
                                    13,
                                    95,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Login using mPIN
                              TextButton(
                                onPressed: () {
                                  mpin(context, null);
                                },
                                child: Text(
                                  "Or, login with mPIN",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  forgetActionSheet(
                                    context,
                                    "Reset mPIN",
                                    "Do you want to reset your mPIN?",
                                    Icons.lock_reset,
                                    "Reset",
                                    "Cancel",
                                  );
                                },
                                child: Text(
                                  "Forgot mPIN?",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.1),

                          // Access to additional options like Maintenance, Reach Us, and More
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        maintenanceActionSheet(
                                          context,
                                          "Comming Soon....",
                                          "We are Working to improve Your experence with our new mobile app.",
                                          Icons.person,
                                          "okay",
                                        );
                                      },
                                      icon: Icon(
                                        Icons.medical_information,
                                        color: const Color.fromARGB(
                                          246,
                                          4,
                                          13,
                                          95,
                                        ),
                                      ),
                                      label: Text(
                                        'Maintenance',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        reachUsActionSheet(
                                          context,
                                          "Reach Us...",
                                          "Whatsapp",
                                          "ContactUs",
                                          "BranchLocator",
                                          Icons.phone,
                                          Icons.location_pin,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.movie_creation_rounded,
                                        color: const Color.fromARGB(
                                          246,
                                          4,
                                          13,
                                          95,
                                        ),
                                      ),
                                      label: Text(
                                        'Reach Us',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        moreActionSheet(context, 'Okay');
                                      },
                                      icon: Icon(
                                        Icons.more,
                                        color: const Color.fromARGB(
                                          246,
                                          4,
                                          13,
                                          95,
                                        ),
                                      ),
                                      label: Text(
                                        'More',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

Widget quickLink(double screenHeight, double screenWidth) {
  return Padding(
    padding: EdgeInsets.only(bottom: screenHeight * 0.02),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/Retail_loan.svg',
                // width: screenWidth * 0.02,
                // height: screenHeight,
                width: screenWidth * 0.05,
                height: screenHeight * 0.05,
              ),
              iconSize: screenWidth * 0.08,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                'Retail Loan',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/Agri_Loan.svg',
                width: screenWidth * 0.05,
                height: screenHeight * 0.05,
              ),
              iconSize: screenWidth * 0.08,
              color: Colors.blue,
            ),
            Text(
              'Agri Loan',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/MSME.svg',
                width: screenWidth * 0.05,
                height: screenHeight * 0.05,
              ),
              iconSize: screenWidth * 0.07,
              color: Colors.pink,
            ),
            Text(
              'MSME Loan',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
