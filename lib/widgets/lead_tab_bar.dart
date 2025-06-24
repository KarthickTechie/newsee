/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Custom widget for displaying tabs for Pending and Completed Leads
*/

import 'package:flutter/material.dart';
import 'package:newsee/feature/leadInbox/presentation/page/completed_leads.dart';
import 'pending_leads.dart';
import '../feature/leadInbox/presentation/page/completed_leads.dart';

class LeadTabBar extends StatelessWidget {
  final String searchQuery;

  const LeadTabBar({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.teal,
            child: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [Tab(text: "Leads"), Tab(text:"Applications" )],
            ),
          ),
          Expanded(
            child: TabBarView(children: [ CompletedLeads(searchQuery: searchQuery),PendingLeads(),]),
          ),
        ],
      ),
    );
  }
}
