/*
  @author     : akshayaa.p
  @date       : 19/06/2025
  @desc       : Reusable stateless widget used to display an action tile in a bottom sheet.
                - Optionally shows a status pill on the trailing side.
                - Status pill changes color based on completion:
                    - Green for 'Completed'
                    - Red for 'Pending'
                - Tapping the tile triggers the onTap callback.
*/

import 'package:flutter/material.dart';
import 'package:newsee/AppData/globalconfig.dart';

class OptionsSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final String? status;
  final List<String>? details;
  final List<String>? detailsName;

  const OptionsSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.status,
    this.details,
    this.detailsName,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status?.toLowerCase() == 'completed';

    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.tealAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            // Title, subtitle, and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  if (details != null &&
                      details!.isNotEmpty &&
                      detailsName != null) ...[
                    const SizedBox(height: 6),
                    ...List.generate(details!.length, (index) {
                      final label =
                          index < detailsName!.length
                              ? detailsName![index]
                              : '';
                      final detail = details![index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: RichText(
                          text: TextSpan(
                            text: label.isNotEmpty ? '$label: ' : '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: detail,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
            // Trailing Status Pill
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isCompleted ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  status!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        isCompleted
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
