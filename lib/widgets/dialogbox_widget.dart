
/* 
@author   : Sandhiya A  17/06/2025
@desc     : When user trying to navigate incase of form partially filled,show alert message to the user.
 */
import 'package:flutter/material.dart';
Future<bool?> showExitConfirmationDialog(context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('Form not saved,Do you want to go back?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Leave'),
            ),
          ],
        );
      },
    );
  }