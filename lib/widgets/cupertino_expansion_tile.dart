
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsee/widgets/expansion_controller.dart';

class CupertinoExpansionTile extends StatelessWidget {
  final int index;
  final ExpansionController controller;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final double? cardWidthValue;

  const CupertinoExpansionTile({
    super.key,
    required this.index,
    required this.controller,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.cardWidthValue
  });

  @override
  Widget build(BuildContext context) {
    final double cardwidth = cardWidthValue ?? 12;
    print("cardwidth $cardwidth");
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isExpanded = controller.expandedIndex == index;

        return Column(
          children: [
            GestureDetector(
              onTap: () => controller.expand(index),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      offset: isExpanded ? const Offset(0.2, 0) : Offset.zero,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 600),
                        turns: isExpanded ? 0.05 : 0,
                        child: Icon(icon, color: Colors.teal, size: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 2),
                          Text(subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: Icon(
                        isExpanded
                            ? CupertinoIcons.minus_circled
                            : CupertinoIcons.add_circled,
                        key: ValueKey(isExpanded),
                        size: 20,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Card(
                margin: EdgeInsets.symmetric(horizontal: cardwidth, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0.25,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: child,
                ),
              ),
          ],
        );
      },
    );
  }
}

