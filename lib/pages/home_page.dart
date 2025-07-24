/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Primary screen contains tab interface with options and switches views based on bottom navigation bar
*/

import 'package:flutter/material.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/masterupdate/presentation/page/master_update.dart';
import '../widgets/side_navigation.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/floating_action.dart';
import '../widgets/lead_tab_bar.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  int? tabdata;

  HomePage({Key? key, this.tabdata}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchQuery = "";
  bool loading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tabdata != null) {
      selectedIndex = widget.tabdata!;
    }
  }

  Future<void> onItemTapped(int index) async {
    print("tabdata ${widget.tabdata}");
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      selectedIndex = index;
      loading = false;
    });
  }

  Widget getPage() {
    switch (selectedIndex) {
      case 0:
        return LeadTabBar(searchQuery: searchQuery);
      case 1:
        return Center(
          child: Text("Field Visit Inbox", style: TextStyle(fontSize: 24)),
        );
      case 2:
        return Center(
          child: Text("Query Inbox", style: TextStyle(fontSize: 24)),
        );
      case 3:
      default:
        return Center(child: MasterUpdate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenavigationbar(
        pageContext: context,
        onTabSelected: (index) {
          setState(() => selectedIndex = index);
        },
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: searchController,
            onChanged: (value) => setState(() => searchQuery = value),
          ),
          if (loading) LinearProgressIndicator(minHeight: 3),
          Expanded(child: getPage()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      floatingActionButton:
          selectedIndex != 3 ? FloatingActionBarWidget() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
