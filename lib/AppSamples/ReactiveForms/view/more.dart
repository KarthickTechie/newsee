import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*

@author : Gayathri.b    14/05/25
@description : Displays a cupertino action sheet labled "more" with a grid layout of 
               loan categories and additional services and primary action button at the bottom of sheet 

 @props       : - BuildContext context : The context in which the Cupertino modal is displayed.
                - String action        : action button at the bottom of the sheet.


 */

//Define the function take context pharameters

void moreActionSheet(BuildContext context, String action) {
  final size = MediaQuery.of(context).size;
  final screenWidth = size.width;
  final screenHeight = size.height;
  //popup the action sheet
  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  bottom: screenHeight * 0.02,
                  right: screenWidth * 0.02,
                ),
                child: Text(
                  'More',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Wrap(
                  spacing: screenWidth * 0.03,
                  runSpacing: screenHeight * 0.02,
                  children: [
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'Retail Loan',
                      'assets/Retail_loan.svg',
                      onTap: () {},
                    ),
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'Agri Loan',
                      'assets/Agri_Loan.svg',
                      onTap: () {},
                    ),
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'MSME Loan',
                      'assets/MSME.svg',
                      onTap: () {},
                    ),
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'Home Loan',
                      'assets/Home_Loan.svg',
                      onTap: () {},
                    ),
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'Vehicle Loan',
                      'assets/Vehicle_Loan.svg',
                      onTap: () {},
                    ),
                    LoanOption(
                      context,
                      screenWidth,
                      screenHeight,
                      'Gold Loan',
                      'assets/Gold_Loan.svg',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              //Section for other Services
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header of Other services
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 40,
                          right: 20,
                        ),
                        child: Text(
                          "OTHER SERVICES",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Manage e-Mandates row
                              Icon(Icons.currency_rupee_rounded),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Service One',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,

                              color: const Color.fromARGB(198, 7, 61, 105),
                              size: 20,
                              weight: 80,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_add_alt),
                              //Update employer Details
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  'Service Two',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,

                              color: const Color.fromARGB(198, 7, 61, 105),
                              size: 20,
                              weight: 80,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //main action button of the action buttom
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                //close the bottom sheet
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: const Color.fromARGB(255, 3, 9, 110),
                    child: Text(
                      action,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
  );
}

Widget LoanOption(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String title,
  String assetPath, {
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth * 0.26,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(130, 158, 158, 158),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            height: screenHeight * 0.08,
            width: screenWidth * 0.04,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.030,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
