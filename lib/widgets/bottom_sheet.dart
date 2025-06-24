import 'package:flutter/material.dart';

void openBottomSheet(
  BuildContext context,
  double initialChildSize,
  double minChildSize,
  double maxChildSize,
  Widget Function(BuildContext context, ScrollController ctrl) renderWidget,
) {
  try {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder:
                (context, scrollController) =>
                    renderWidget(context, scrollController),
          ),
    );
  } catch (e) {
    print("Error opening bottom sheet: $e");
  }
}
