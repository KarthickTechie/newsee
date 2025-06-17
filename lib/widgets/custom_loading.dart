import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoading extends StatelessWidget {
  final String message;
  const CustomLoading({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dimmed background
        const ModalBarrier(
          dismissible: false,
          color: Colors.black54, // Slightly less opaque for better visibility
        ),
        // Loading card in the center
        Center(
          child: Card(
            color: Colors.white, // Explicit background for visibility
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(75),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Minimize Row width
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spinner
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.teal,
                    size: 50,
                  ),
                  const SizedBox(width: 16),
                  // Loading message with wrapping
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                      softWrap: true, // Enable text wrapping
                      overflow:
                          TextOverflow
                              .visible, // Ensure text wraps instead of clipping
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
