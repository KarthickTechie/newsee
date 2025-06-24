import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsee/AppData/app_constants.dart';

/* 
@author         :   ganeshkumar.b    14/05/2025
@description    :   Action Sheet for accessing camera, gallery or file.
@props          :   possible props BuildContext, List<FilePickingOptionList>

 */

showMediaPickerActionSheet({
  required BuildContext context,
  required List<FilePickingOptionList> actions,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: const Text('Document Type'),
          message: const Text('select document from '),
          actions:
              actions
                  .where((option) => option.title != 'CANCEL')
                  .map(
                    (picker) => CupertinoActionSheetAction(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(picker.icon),
                          SizedBox(width: 8),
                          Text(picker.title),
                        ],
                      ),
                      onPressed: () async {
                        if (context.mounted) {
                          Navigator.pop(context, picker.title);
                        }
                      },
                    ),
                  )
                  .toList(),
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // actions.firstWhere((a) => a.title == "CANCEL").callback(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel),
                SizedBox(width: 8),
                Text("Cancel"),
              ],
            ),
          ),
        ),
  );
}
