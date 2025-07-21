/* 
@author   :  @vishnucenddle [https://github.com/vishnucenddle] 25/06/2025
@desc     :  interview task given to solve problem in custom navigation in pages
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Kwillpopscope extends StatefulWidget {
  final FormGroup form;
  final Widget widget;
  final BuildContext routeContext;
  Kwillpopscope({
    required this.routeContext,
    required this.form,
    required this.widget,
  });

  @override
  State<Kwillpopscope> createState() => _KwillpopscopeState();
}

class _KwillpopscopeState extends State<Kwillpopscope> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool hasValues = widget.form.controls.values.any(
          (control) => control.value != null && control.value != '',
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
                            widget.routeContext.goNamed('home');
                          },
                          child: Text('Go back'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Stay'),
                        ),
                      ],
                    ),
              ) ??
              false;
        }
        return true;
      },
      child: widget.widget,
    );
  }
}
