import 'package:flutter/material.dart';

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

mpin(BuildContext context) {
  // show the custom modal bottom sheet
  showModalBottomSheet<void>(
    isScrollControlled: true,

    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screenHeight * 0.7,
          // height: screenHeight * 5.0,
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Title(
                    color: Colors.black,
                    child: Text(
                      'Enter the MPIN',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Row(
                // Four TextFields for entering a numeric MPIN
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (i) {
                  return Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.08,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // fingerprint icon for biometric authentication
                    child:
                        i == 0
                            ? Center(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.fingerprint,
                                  size: 35,
                                  color: Color.fromARGB(255, 3, 9, 110),
                                ),
                              ),
                            )
                            : Center(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                ),

                                onChanged: (v) {
                                  if (v.isNotEmpty && i + 1 < 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                              ),
                            ),
                  );
                }),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      );
    },
  );
}
