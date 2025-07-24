import 'package:flutter/material.dart';
import 'package:path/path.dart';

/*
  @author     : akshayaa.p
  @date       : 16/05/2025
  @desc       : Reusable stateless widget to show an alert box with customizable:
                - Icon, text, colors and action button.
                - Used to display messages like success, failure, warning or error.
                - The button executes the provided onButtonPressed callback.
*/

class SysmoAlert extends StatelessWidget {
  final String message;
  final Color textColor;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SysmoAlert({
    super.key,
    required this.message,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.icon = Icons.info_outline,
    this.buttonText = 'OK',
    required this.onButtonPressed,
  });

  factory SysmoAlert.success({
    Key? key,
    required String message,
    VoidCallback? onButtonPressed,
    Color? textColor,
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    String? buttonText,
  }) {
    return SysmoAlert(
      key: key,
      message: message,
      textColor: textColor ?? Colors.black,
      backgroundColor: backgroundColor ?? Colors.green.shade50,
      iconColor: iconColor ?? Colors.green,
      icon: icon ?? Icons.check_circle_outline,
      buttonText: buttonText ?? 'OK',
      onButtonPressed: onButtonPressed ?? () {},
    );
  }

  factory SysmoAlert.failure({
    Key? key,
    required String message,
    VoidCallback? onButtonPressed,
    Color? textColor,
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    String? buttonText,
  }) {
    return SysmoAlert(
      key: key,
      message: message,
      textColor: textColor ?? Colors.black,
      backgroundColor: backgroundColor ?? Colors.red.shade50,
      iconColor: iconColor ?? Colors.red,
      icon: icon ?? Icons.error_outline,
      buttonText: buttonText ?? 'OK',
      onButtonPressed: onButtonPressed ?? () {},
    );
  }

  factory SysmoAlert.warning({
    Key? key,
    required String message,
    VoidCallback? onButtonPressed,
    Color? textColor,
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    String? buttonText,
  }) {
    return SysmoAlert(
      key: key,
      message: message,
      textColor: textColor ?? Colors.black,
      backgroundColor: backgroundColor ?? Colors.orange.shade50,
      iconColor: iconColor ?? Colors.orange,
      icon: icon ?? Icons.warning_amber_rounded,
      buttonText: buttonText ?? 'OK',
      onButtonPressed: onButtonPressed ?? () {},
    );
  }

  factory SysmoAlert.info({
    Key? key,
    required String message,
    VoidCallback? onButtonPressed,
    Color? textColor,
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    String? buttonText,
  }) {
    return SysmoAlert(
      key: key,
      message: message,
      textColor: textColor ?? Colors.black,
      backgroundColor: backgroundColor ?? Colors.blue.shade50,
      iconColor: iconColor ?? Colors.blue,
      icon: icon ?? Icons.info_outline,
      buttonText: buttonText ?? 'OK',
      onButtonPressed: onButtonPressed ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 40),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 22),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// sysmoalert(message:'') -> icon default to info icon , ok button
