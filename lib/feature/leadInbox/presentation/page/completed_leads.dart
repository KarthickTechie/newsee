/*
  @author     : gayathri.b 12/06/2025
  @desc       : Stateless widget that renders a list of completed leads using BLoC.
                It dispatches a SearchLeadEvent on initialization and listens to state changes.
                Based on the state (loading, success, or failure), it renders:
                - Shimmer loading cards while waiting,    
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/presentation/bloc/lead_bloc.dart';
import 'package:newsee/widgets/lead_tile_card-shimmer.dart';
import 'package:newsee/widgets/lead_tile_card.dart';

class CompletedLeads extends StatelessWidget {
  final String searchQuery;

  const CompletedLeads({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadBloc()..add(SearchLeadEvent()),
      child: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {
          Future<void> onRefresh() async {
            context.read<LeadBloc>().add(SearchLeadEvent());
          }

          if (state.status == LeadStatus.loading) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return LeadTileCardShimmer(
                    title: 'Loading...',
                    subtitle: 'Loading...',
                    icon: Icons.person,
                    color: Colors.teal,
                    type: 'Loading...',
                    product: 'Loading...',
                    phone: 'Loading...',
                    createdon: 'Loading...',
                    location: 'Loading...',
                    loanamount: 'Loading...',
                  );
                },
              ),
            );
          }

          if (state.status == LeadStatus.failure) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Text(state.errorMessage ?? 'Something went wrong'),
                  ),
                ],
              ),
            );
          }

          final allLeads =
              state.leadResponseModel
                  ?.expand((model) => model.finalList)
                  .toList();

          final filteredLeads =
              allLeads?.where((lead) {
                final name = (lead['lleadfrstname'] ?? '').toLowerCase();
                final id = (lead['lleadid'] ?? '').toLowerCase();
                final phone = (lead['lleadmobno'] ?? '').toLowerCase();
                final loan = (lead['lldLoanamtRequested'] ?? '').toString();
                return name.contains(searchQuery.toLowerCase()) ||
                    id.contains(searchQuery.toLowerCase()) ||
                    phone.contains(searchQuery.toLowerCase()) ||
                    loan.contains(searchQuery.toLowerCase());
              }).toList();

          if (filteredLeads == null || filteredLeads.isEmpty) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("No leads found.")),
                ],
              ),
            );
          }

          final itemsPerPage = 5;
          // final totalPages = (filteredLeads.length / itemsPerPage).ceil();
          final totalPages = (filteredLeads.length);
          final currentPage = state.currentPage - 1;

         final startIndex = currentPage * itemsPerPage;
         final endIndex = ((currentPage + 1) * itemsPerPage).clamp(0, filteredLeads.length);
         final paginatedLeads = filteredLeads.sublist(startIndex, endIndex);


          return RefreshIndicator(
            onRefresh: onRefresh,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedLeads.length,
                    itemBuilder: (context, index) {
                      final lead = paginatedLeads[index];
                      return LeadTileCard(
                        title: lead['lleadfrstname'] ?? 'N/A',
                        subtitle: lead['lleadid'] ?? 'N/A',
                        icon: Icons.person,
                        color: Colors.teal,
                        type:
                            lead['lleadexistingcustomer'] == "N"
                                ? 'New Customer'
                                : 'Existing Customer',
                        product: lead['lfProdId'] ?? 'N/A',
                        phone: lead['lleadmobno'] ?? 'N/A',
                        createdon: lead['lpdCreatedOn'] ?? 'N/A',
                        location: lead['lleadprefbrnch'] ?? 'N/A',
                        loanamount:
                            lead['lldLoanamtRequested']?.toString() ?? '',
                        onTap: () {},
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: NumberPaginator(
                    numberPages: totalPages,
                    initialPage: currentPage,
                    onPageChange: (int index) {
                      context.read<LeadBloc>().add(
                        SearchLeadEvent(pageNo: index),
                      );
                    },
                    child: const SizedBox(
                      width: 250,
                      height: 35,
                      child: Row(
                        children: [
                          PrevButton(),
                          Expanded(child: NumberContent()),
                          NextButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
