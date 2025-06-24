import 'package:flutter/material.dart';

class CustomerResponsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Response")),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 9, 110),
                      ),
                    ),
                    Divider(thickness: 1, height: 24),

                    Row(
                      children: [
                        _buildKeyValue("Product ID", "1556659"),
                        SizedBox(width: 20),
                        _buildKeyValue("Description", "Kissan Credit Card"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 9, 110),
                      ),
                    ),
                    Divider(thickness: 1, height: 24),

                    Row(
                      children: [
                        _buildKeyValue("CIF ID", "1734239823"),
                        SizedBox(width: 20),
                        _buildKeyValue("Name", "Ganesh Kumar B"),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        _buildKeyValue("mobile", "9834509345"),
                        SizedBox(width: 20),
                        _buildKeyValue("DOB", "21/09/1991"),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        _buildKeyValue("PAN", "HIOPN5342L"),
                        SizedBox(width: 20),
                        _buildKeyValue("Aadhaar", "786254611432"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 9, 110),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text('Proceed with Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget KeyValue(String key, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(key),
      Text(value, style: TextStyle(color: Color.fromARGB(255, 3, 9, 110))),
    ],
  );
}

Widget _buildKeyValue(String key, String value) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$key: ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black87),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
