import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'forgetpassword.dart';
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
  void fingerPrintScanner() {
    print('clicked finger print');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    //Header section of the landing page
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.31,
            child: SvgPicture.asset(
              'assets/app_background_2.svg',
              fit: BoxFit.cover,
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

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        gradient: LinearGradient(
                          colors: [const Color(0xC5F1ECF1), Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.03),

                          //Login using fingerprint (biometric authentication)
                          IconButton(
                            onPressed: () {
                              fingerPrintScanner();
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
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.02,
                            ),

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
                          ),
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
                          loginActionSheet(context);
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

                          backgroundColor: const Color.fromARGB(246, 4, 13, 95),
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
                          mpin(context);
                        },
                        child: Text(
                          "Or, login with mPIN",
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          forgetActionSheet(
                            context,
                            "Reset mPIN for \n Customer ID *****8977",
                            "Let's first Verify it's you ,before you reset the mPIN. \n it'll be super quick and easy.",
                            (Icons.lock),
                            "Cancel",
                            "Continue",
                          );
                        },
                        child: Text(
                          "Forgot mPIN?",
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.08),

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
                                color: const Color.fromARGB(246, 4, 13, 95),
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
                                color: const Color.fromARGB(246, 4, 13, 95),
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
                                color: const Color.fromARGB(246, 4, 13, 95),
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
    );
  }
}
