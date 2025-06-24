import 'package:flutter/material.dart';
import 'package:newsee/pages/permanent%20_address.dart';
import 'package:newsee/pages/present_address.dart';

class AddressTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 190, 216, 214),
            child: const TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Color.fromARGB(179, 8, 8, 8),
              indicatorColor: Colors.teal,
              tabs: [Tab(text: "permanent"), Tab(text: "Present")],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                PermanentAddress(title: 'permanent'),
                PresentAddress(title: 'Present '),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
