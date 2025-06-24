import 'package:flutter/material.dart';
import 'package:newsee/widgets/build_in_row.dart';

class ResponseWidget extends StatelessWidget {
  double heightSize;
  List<Map<String, dynamic>> dataList;
  bool buttonshow;
  VoidCallback? onpressed;

  ResponseWidget({
    required this.heightSize,
    required this.dataList,
    required this.buttonshow,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * heightSize,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...dataList
                      .map(
                        (list) => BuildInRow(
                          icon: list['icon'] as IconData,
                          label: list['label'] as String,
                          value: list['value'] as String,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          buttonshow
              ? Center(
                child: ElevatedButton.icon(
                  onPressed: onpressed,
                  icon: Icon(Icons.send, color: Colors.white),
                  label: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      children: [TextSpan(text: 'OK')],
                    ),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 75, 33, 83),
                    ),
                  ),
                ),
              )
              : SizedBox(height: 50),
        ],
      ),
    );
  }
}
