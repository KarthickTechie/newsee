import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String productDescription;
  final String amountFrom;
  final String amountTo;

  const ProductCard({
    required this.productId,
    required this.productDescription,
    required this.amountFrom,
    required this.amountTo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productDescription,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BuildCard(
              icon: Icons.file_copy_rounded,
              label: "Procuct Id",
              value: productId,
            ),
            BuildCard(
              icon: Icons.currency_rupee_rounded,
              label: "Amount From",
              value: amountFrom,
            ),
            BuildCard(
              icon: Icons.currency_rupee_rounded,
              label: "Amount To",
              value: amountTo,
            ),
          ],
        ),
      ),
    );
  }
}

/*   @author   :  Sandhiya A  10/06/2025
     @desc     :  Create a dynamic UI to display an icon, a key, and a value in a single row."
  */
class BuildCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  BuildCard({required this.icon, required this.label, required this.value});
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
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
