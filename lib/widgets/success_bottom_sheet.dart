import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';

/*
 @created on : june 3,2025
 @author : Lathamani 
 Description : Custom bottom sheet widget for showing on lead successfull submission
 usage: use showSuccessBottomSheet(arg1, arg2, arg3) method where ever want to show bottom sheet
 arg1: context of that page,
 arg2: header text of bottom sheet 
 arg3: message text of bottom sheet
*/
void showSuccessBottomSheet({
  required BuildContext context,
  required String headerTxt,
  required String lead,
  required String message,
  required VoidCallback? onPressedLeftButton,
  required VoidCallback? onPressedRightButton,
  required String? leftButtonLabel,
  required String? rightButtonLabel,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder:
        (context) => _AnimatedSuccessContent(
          headerTxt: headerTxt,
          lead: lead,
          message: message,
          onPressedLeftButton: onPressedLeftButton,
          onPressedRightButton: onPressedRightButton,
          leftButtonLabel: leftButtonLabel,
          rightButtonLabel: rightButtonLabel,
        ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );
}

class _AnimatedSuccessContent extends StatefulWidget {
  final String message;
  final String lead;
  final String headerTxt;
  final VoidCallback? onPressedLeftButton;
  final VoidCallback? onPressedRightButton;
  final String? leftButtonLabel;
  final String? rightButtonLabel;

  const _AnimatedSuccessContent({
    required this.headerTxt,
    required this.lead,
    required this.message,
    required this.onPressedLeftButton,
    required this.onPressedRightButton,
    required this.leftButtonLabel,
    required this.rightButtonLabel,
  });

  @override
  State<_AnimatedSuccessContent> createState() =>
      _AnimatedSuccessContentState();
}

class _AnimatedSuccessContentState extends State<_AnimatedSuccessContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.headerTxt == ApiConstants.api_response_success
                  ? Icon(Icons.check_circle, color: Colors.green, size: 60)
                  : Icon(Icons.close_rounded, color: Colors.red, size: 60),
              SizedBox(height: 16),
              Text(
                widget.headerTxt,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.lead,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Row(
                spacing: 10.0,
                children: [
                  Flexible(
                    flex: 4,

                    child: ElevatedButton(
                      onPressed: widget.onPressedLeftButton,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          20,
                        ),
                        padding: EdgeInsets.all(8),
                        backgroundColor: Color.fromARGB(255, 3, 9, 110),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(widget.leftButtonLabel ?? "Cancel"),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: widget.onPressedRightButton,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(8),

                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          20,
                        ),
                        backgroundColor: Color.fromARGB(255, 3, 9, 110),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(widget.rightButtonLabel ?? "Ok"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
