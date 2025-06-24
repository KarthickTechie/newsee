import 'package:flutter/material.dart';

class BadgeFab extends StatelessWidget {
  final Color bgColor;
  final Widget child;
  final Color badgeColor;
  final VoidCallback onPressed;
  final Widget badgeChild;
  const BadgeFab({
    super.key,
    required this.bgColor,
    required this.badgeColor,
    required this.onPressed,
    required this.child,
    required this.badgeChild,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: bgColor,
          child: child,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(minWidth: 20, minHeight: 20),
            child: badgeChild,
          ),
        ),
      ],
    );
  }
}
