/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Drawer at the side for navigation between pages
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/audit_log/presentation/page/audit_log_page.dart';
import 'package:newsee/pages/home_page.dart';
import 'package:path/path.dart';

class Sidenavigationbar extends StatelessWidget {
  final Function(int)? onTabSelected;
  final BuildContext? pageContext;

  const Sidenavigationbar({this.onTabSelected, this.pageContext, super.key});

  @override
  Widget build(BuildContext sidemenucontext) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove default padding
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF26A69A), Color(0xFF00796B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Branch : ${user?.Orgscode} | ${user?.OrgName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
          buildGradientTile(
            context: sidemenucontext,
            icon: Icons.dashboard_rounded,
            title: "Dashboard",
            onTap: () {
              onTabSelected?.call(0);
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          buildGradientTile(
            context: sidemenucontext,
            icon: Icons.mail_rounded,
            title: "Field Visit Inbox",
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 1)),
              );
            },
          ),
          buildGradientTile(
            context: sidemenucontext,
            icon: Icons.message_rounded,
            title: "Query Inbox",
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 2)),
              );
            },
          ),
          buildGradientTile(
            context: sidemenucontext,
            icon: Icons.update_rounded,
            title: "Masters Update",
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => HomePage(tabdata: 3)),
              );
            },
          ),
         
            buildGradientTile(
            context: sidemenucontext,
            icon: Icons.audio_file_rounded,
            title: "Audio Logs",
            onTap: () {
              Navigator.push(
                sidemenucontext,
                MaterialPageRoute(builder: (context) => AuditLogPage()),
              );
            },
          ),





          buildGradientTile(
            context: sidemenucontext,
            icon: Icons.logout_rounded,
            title: "Logout",
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: sidemenucontext,
                builder:
                    (dialogcontext) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(dialogcontext).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogcontext).pop(true);
                          },
                          child: const Text('Yes'),
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

  Widget buildGradientTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      hoverColor: Colors.teal.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
