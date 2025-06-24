import 'package:flutter/material.dart';

class BuildInRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  BuildInRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Icon(icon, color: Colors.teal),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
          // Icon(icon, color: Colors.teal),
          // const SizedBox(width: 12),
          // Text(
          //   "$label: ",
          //   style: const TextStyle(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(width: 12),
          // Expanded(
          //   child: Text(value, style: const TextStyle(fontSize: 13)),
          // ),
        ],
      ),
    );
  }
}
