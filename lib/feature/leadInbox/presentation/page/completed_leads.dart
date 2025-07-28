/*
  @author     : gayathri.b 12/06/2025
  @desc       : Stateless widget that renders a list of completed leads using BLoC.
                It dispatches a SearchLeadEvent on initialization and listens to state changes.
                Based on the state (loading, success, or failure), it renders:
                - Shimmer loading cards while waiting,    
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/widgets/button_frame.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:number_paginator/number_paginator.dart';
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
      child: BlocConsumer<LeadBloc, LeadState>(
        listener: (context, state) {
          if (state.proposalSubmitStatus == SaveStatus.loading) {
            presentLoading(context, 'Creating Proposal...');
          } else if (state.proposalSubmitStatus == SaveStatus.success ||
              state.proposalSubmitStatus == SaveStatus.failure) {
            dismissLoading(context);
          }
          if (state.getLeaStatus == SaveStatus.loading) {
            presentLoading(context, 'Fetching Lead Details...');
          } else if (state.getLeaStatus == SaveStatus.success ||
              state.getLeaStatus == SaveStatus.failure) {
            dismissLoading(context);
          }

          if (state.proposalSubmitStatus == SaveStatus.success &&
              state.proposalNo != null) {
            showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_success,
              lead: "Proposal No : ${state.proposalNo}",
              message: "Proposal successfully Created",
              onPressedLeftButton: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              onPressedRightButton: () {
                context.pop();
                final tabController = DefaultTabController.of(context);
                if (tabController.index < tabController.length - 1) {
                  tabController.animateTo(tabController.index + 1);
                }
              },
              leftButtonLabel: 'Cancel',
              rightButtonLabel: 'Go To Application',
            );
          }

          if (state.proposalSubmitStatus == SaveStatus.failure) {
            showDialog(
              context: context,
              builder:
                  (_) => SysmoAlert.failure(
                    message: "Proposal Creation Failed",
                    onButtonPressed: () {
                      Navigator.pop(context);
                    },
                  ),
            );
          }

          if (state.getLeaStatus == SaveStatus.loading) {
          } else if (state.getLeaStatus == SaveStatus.success) {
            context.pushNamed(
              'newlead',
              extra: {'leadData': state.getleadData},
            );
          } else if (state.getLeaStatus == SaveStatus.failure) {
            showDialog(
              context: context,
              builder:
                  (_) => SysmoAlert.failure(
                    message: state.errorMessage.toString(),
                    onButtonPressed: () {
                      Navigator.pop(context);
                    },
                  ),
            );
          }
        },
        builder: (context, state) {
          Future<void> onRefresh() async {
            context.read<LeadBloc>().add(
              SearchLeadEvent(
                pageNo: state.currentPage 
              )
            );
          }

          if (state.status == LeadStatus.loading) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return LeadTileCardShimmer(
                    icon: Icons.person,
                    color: Colors.teal,
                  );
                },
              ),
            );
          }

          if (state.status == LeadStatus.failure) {
            return renderWhenNoItems(onRefresh, state, context);
          }

          final List<GroupLeadInbox>? allLeads = state.leadResponseModel;

          // logic for search functionaluty , when user type search query
          // in searchbar
          List<GroupLeadInbox>? filteredLeads = onSearchLeadInbox(
            items: allLeads,
            searchQuery: searchQuery,
          );
          if (filteredLeads == null || filteredLeads.isEmpty) {
            return renderWhenNoItems(onRefresh, state, context);
          } else {
            // final totalPages = (filteredLeads.length / itemsPerPage).ceil();
            return renderItems(state, filteredLeads, onRefresh, context);
          }

          // comments
        },
      ),
    );
  }

  RefreshIndicator renderItems(
    LeadState state,
    List<GroupLeadInbox> filteredLeads,
    Future<void> Function() onRefresh,
    BuildContext context,
  ) {
    final currentPage = state.currentPage;
    print("currentPage: $currentPage");
    final int pageCount = 20;
    final int totalNumberOfApplication = state.totApplication.toInt();
    final int numberOfpages = (totalNumberOfApplication / pageCount).ceil();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                final lead =
                    filteredLeads[index].finalList as Map<String, dynamic>;
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
                  ennablePhoneTap: true,
                  createdon: lead['lpdCreatedOn'] ?? 'N/A',
                  location: lead['lleadprefbrnch'] ?? 'N/A',
                  loanamount: lead['lldLoanamtRequested']?.toString() ?? '',
                  onTap: () {
                    context.read<LeadBloc>().add(
                      GetLeadDataEvent(leadId: lead['lleadid']),
                    );
                  },
                  showarrow: false,
                  button: ButtonFrame(
                    text: 'Create Proposal',
                    icon: Icons.create,
                    onPressed: () {
                      context.read<LeadBloc>().add(
                        CreateProposalLeadEvent(leadId: lead['lleadid'] ?? ''),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfpages,
              initialPage: currentPage,
              onPageChange: (int index) {
                // check if the
                context.read<LeadBloc>().add(SearchLeadEvent(pageNo: index));
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
  }

  RefreshIndicator renderWhenNoItems(
    Future<void> Function() onRefresh,
    LeadState state,
    BuildContext context,
  ) {
    final currentPage = state.currentPage;
    print("currentPage: $currentPage");
    final int pageCount = 20;
    final int totalNumberOfApplication = state.totApplication.toInt();
    final int numberOfpages = (totalNumberOfApplication / pageCount).ceil();
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 200),
                Center(
                  child: Text(
                    state.errorMessage ?? AppConstants.GLOBAL_NO_DATA_FOUND,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfpages,
              initialPage: currentPage,
              onPageChange: (int index) {
                context.read<LeadBloc>().add(SearchLeadEvent(pageNo: index));
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
  }
}
