/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Drawer at the side for navigation between pages
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/pages/home_page.dart';

class Sidenavigationbar extends StatelessWidget {
  final Function(int)? onTabSelected;
  final BuildContext? pageContext;
  const Sidenavigationbar({this.onTabSelected, this.pageContext, super.key});

  @override
  Widget build(BuildContext sidemenucontext) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: FutureBuilder<UserDetails?>(
              future: loadUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'User : ${user?.UserName} | ${user?.LPuserID}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Branch : ${user?.Orgscode} | ${user?.OrgName}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded, color: Colors.teal),
            title: Text("Dashboard"),
            onTap: () {
              onTabSelected?.call(0);
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mail_rounded, color: Colors.teal),
            title: Text("Field Visit Inbox"),
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 1)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.message_rounded, color: Colors.teal),
            title: Text("Query Inbox"),
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 2)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.update_rounded, color: Colors.teal),
            title: Text("Masters Update"),
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 3)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: Colors.teal),
            title: Text("Logout"),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: sidemenucontext,
                builder:
                    (dialogcontext) => AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(dialogcontext).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogcontext).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
              );

              if (shouldLogout ?? false) {
                Navigator.of(sidemenucontext).pop();
                pageContext?.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
