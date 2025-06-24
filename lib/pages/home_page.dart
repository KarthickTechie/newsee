/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Primary screen contains tab interface with options and switches views based on bottom navigation bar
*/

import 'package:flutter/material.dart';
import 'package:newsee/AppData/globalconfig.dart';
import '../widgets/side_navigation.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/floating_action.dart';
import '../widgets/lead_tab_bar.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchQuery = "";
  bool loading = false;
  final TextEditingController searchController = TextEditingController();

  Future<void> onItemTapped(int index) async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      selectedIndex = index;
      loading = false;
    });
  }

  Widget getPage() {
    if (selectedIndex == 0) {
      return LeadTabBar(searchQuery: searchQuery);
    } else if (selectedIndex == 1) {
      return Center(
        child: Text("Application Inbox", style: TextStyle(fontSize: 24)),
      );
    } else if (selectedIndex == 2) {
      return Center(child: Text("Query Inbox", style: TextStyle(fontSize: 24)));
    } else {
      return Center(
        child: Text("Masters Update", style: TextStyle(fontSize: 24)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenavigationbar(),
      body: Column(
        children: [
          SearchBarWidget(
            controller: searchController,
            onChanged: (value) {
              setState(() => searchQuery = value);
            },
          ),
          if (loading) LinearProgressIndicator(minHeight: 3),
          Expanded(child: getPage()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      floatingActionButton: FloatingActionBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
