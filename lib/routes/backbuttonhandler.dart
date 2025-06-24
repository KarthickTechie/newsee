import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalBackHandler extends StatelessWidget {
  final Widget child;

  const GlobalBackHandler({required this.child});

  Future<bool> _onWillPop(BuildContext context) async {
    final router = GoRouter.of(context);

    if (router.canPop()) {
      router.pop();
      return false; // Don't exit app
    }

    // Show exit confirmation
    final shouldExit = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Exit App?'),
            content: Text('Do you want to close the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () => _onWillPop(context), child: child);
  }
}
