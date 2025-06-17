import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String message;

  const Loader({super.key, this.message = 'Loading...'});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

// for display loader use this function at time of calling api's like in presentLoading(context, 'fetching..')
presentLoading(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Loader(message: message),
  );
}

// for dismiss loader use this function at time of calling api's like in dismissLoading(context)

void dismissLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
