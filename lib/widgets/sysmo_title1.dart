import 'package:flutter/material.dart';

class SysmoTitle1 extends StatelessWidget {
  final IconData icon;
  final IconData infoicon;
  final String label;
  final String value;

  const SysmoTitle1({
    super.key,
    required this.icon,
    required this.infoicon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 6),
            decoration: const BoxDecoration(
              // border: Border(
              //   bottom: BorderSide(color: Color.fromARGB(58, 0, 15, 14), width: 2),
              // ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(icon, color: Colors.red, size: 26),
                  backgroundColor: const Color.fromARGB(36, 0, 150, 135),
                  radius: 20,
                ),
                const SizedBox(width: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "$label",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                child: Icon(infoicon, color: Colors.blue, size: 20),
                backgroundColor: const Color.fromARGB(36, 0, 150, 135),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
