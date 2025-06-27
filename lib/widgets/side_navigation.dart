/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Drawer at the side for navigation between pages
*/
import 'package:flutter/material.dart';
import 'package:newsee/pages/home_page.dart';

class Sidenavigationbar extends StatelessWidget {
  final Function(int)? onTabSelected;

  const Sidenavigationbar({this.onTabSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded, color: Colors.teal),
            title: Text("Dashboard"),
            onTap: () {
              onTabSelected?.call(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mail_rounded, color: Colors.teal),
            title: Text("Application Inbox"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 1)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.message_rounded, color: Colors.teal),
            title: Text("Query Inbox"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 2)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.update_rounded, color: Colors.teal),
            title: Text("Masters Update"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 3)),
              );
            },
          ),
        ],
      ),
    );
  }
}
