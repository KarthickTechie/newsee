

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Kwillpopscope extends StatefulWidget {
  final FormGroup form;
  final Widget widget;
   Kwillpopscope({required this.form,required this.widget });

  @override
  State<Kwillpopscope> createState() => _KwillpopscopeState();
}

class _KwillpopscopeState extends State<Kwillpopscope> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      
      onWillPop: () async {
        bool hasValues = widget.form.controls.values.any(
          (control) => control.value != null && control.value!= '',
        );

        if (hasValues) {
          return await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Unsaved Changes'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Cancel'),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
          )??false;
        }
        return true;
        
      },
      child: widget.widget,
    );
  }
}