import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
@author   : Gayathri.B  05/05/2025
@description : This function displays a Cupertino-style action sheet with two contact numbers 
              and a customizable icon

@props  : - BuildContext context : The context in which the Cupertino modal is displayed.

          - String title          : Title displayed at the top of the action sheet.
          - String number1        : The first phone number option displayed.
          - String number2        : The second phone number option displayed.
          - IconData icon         : An icon displayed next to each phone number.



 */

//Define the function take mulitiple pharameter and also take context

void contact(
  BuildContext context,
  String title,
  String number1,
  String number2,
  IconData icon,
) {
  //popup the action sheet
  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) {
          var actions = [
            CupertinoActionSheetAction(
              onPressed: () {
                // print(number1);
                //close the action sheet when pressed void contact
                Navigator.pop(context);
              },
              //List Of First number
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    number1,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Icon(icon, color: Color.fromARGB(255, 32, 219, 35), size: 30),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                print(number2);
                Navigator.pop(context);
              },
              //List Of Second number
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    number2,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Icon(icon, color: Color.fromARGB(255, 32, 219, 35), size: 30),
                ],
              ),
            ),
          ];
          return CupertinoActionSheet(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
          ),
          // list of Action sheet
          actions: actions,
        );
        },
  );
}
