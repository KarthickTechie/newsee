import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/proposal_inbox/presentation/bloc/proposal_inbox_bloc.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/lead_tile_card-shimmer.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/lead_tile_card.dart';
import 'package:number_paginator/number_paginator.dart';

class PendingLeads extends StatelessWidget {
  final String searchQuery;
  PendingLeads({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProposalInboxBloc()
        ..add(
          SearchProposalInboxEvent(
            request: LeadInboxRequest(userid: '', token: ''),
          ),
        ),
      child: BlocBuilder<ProposalInboxBloc, ProposalInboxState>(
        builder: (context, state) {
          Future<void> onRefresh() async {
            context.read<ProposalInboxBloc>().add(
                  SearchProposalInboxEvent(
                    request: LeadInboxRequest(userid: '', token: ''),
                  ),
                );
          }

          if (state.status == ProposalInboxStatus.loading) {
            // return const Center(child: ShimmerLoader(cardHeight: 120,itemCount: 5));
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return LeadTileCardShimmer(
                    title: 'loading...',
                    subtitle: 'loading...',
                    icon: Icons.person,
                    color: Colors.teal,
                    type: 'loading...',
                    product: 'loading...',
                    phone: 'loading...',
                    createdon: 'loading...',
                    location: 'loading...',
                    loanamount: 'loading...',
                  );
                },
              ),
            );
          }

          if (state.status == ProposalInboxStatus.failure) {
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Text(
                      state.errorMessage ?? 'Something went wrong',
                    ),
                  ),
                ],
              ),
            );
          }

          final allProposalInboxLeads = state.proposalResponseModel
              ?.expand((model) => model.proposalDetails)
              .toList();

          final filterProposalInboxLeads = allProposalInboxLeads?.where((proposal) {
            final name = (proposal['applicantName'] ?? '').toLowerCase();
            final id = (proposal['propNo'] ?? '').toLowerCase();
            final branchCode = (proposal['branchCode'] ?? '').toLowerCase();
            final loan = (proposal['loanAmount'] ?? '').toString();
            return name.contains(searchQuery.toLowerCase()) ||
                id.contains(searchQuery.toLowerCase()) ||
                branchCode.contains(searchQuery.toLowerCase()) ||
                loan.contains(searchQuery.toString());
          }).toList();

          if (filterProposalInboxLeads == null || filterProposalInboxLeads.isEmpty) {
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
          final totalPages = (filterProposalInboxLeads.length);
          final rawPage = state.currentPage <= 0 ? 1 : state.currentPage;
          final currentPage = rawPage - 1;

          final startIndex = (currentPage * itemsPerPage).clamp(0, filterProposalInboxLeads.length);
          final endIndex = ((currentPage + 1) * itemsPerPage).clamp(0, filterProposalInboxLeads.length);
          final paginatedLeads = filterProposalInboxLeads.sublist(startIndex, endIndex);

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedLeads.length,
                    itemBuilder: (context, index) {
                      final proposal = paginatedLeads[index];
                      return LeadTileCard(
                        title: proposal['applicantName']?.toString().isNotEmpty == true
                            ? proposal['applicantName']
                            : 'Name is Empty',
                        subtitle: proposal['propNo'] ?? 'N/A',
                        icon: Icons.person,
                        color: Colors.teal,
                        type: proposal['proposalStatus'] ?? 'N/A',
                        product: proposal['schemeName'] ?? 'N/A',
                        phone: proposal['propRefNo'] ?? 'N/A',
                        createdon: proposal['createdOn'] ?? 'N/A',
                        location: proposal['branchName'] ?? 'N/A',
                        loanamount: proposal['loanAmount']?.toString() ?? '',
                        onTap: () {
                          openBottomSheet(context, 0.6, 0.4, 0.9, (context, scrollController) {
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  const SizedBox(height: 12),
                                  OptionsSheet(
                                    icon: Icons.visibility,
                                    title: "Land Details",
                                    subtitle: "View your Land Details here",
                                    status: 'Completed',
                                    onTap: () {
                                      context.pushNamed('landholdings', extra: {
                                        'applicantName': proposal['applicantName'],
                                        'proposalNumber': proposal['propNo'],
                                      });
                                    },
                                  ),
                                  OptionsSheet(
                                    icon: Icons.visibility,
                                    title: "Crop Details",
                                    subtitle: "View your Crop Details here",
                                    status: 'Pending',
                                    onTap: () {
                                      context.pushNamed('cropdetails', extra: proposal['propNo']);
                                    },
                                  ),
                                  OptionsSheet(
                                    icon: Icons.description,
                                    title: "Document Upload",
                                    subtitle: "Pre-Sanctioned Documents Upload",
                                    status: 'Pending',
                                    onTap: () {
                                      context.pushNamed('document', extra: proposal['propNo']);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: NumberPaginator(
                    numberPages: totalPages,
                    initialPage: currentPage,
                    onPageChange: (int index) async {
                      final userDetails = await loadUser();
                      context.read<ProposalInboxBloc>().add(
                        SearchProposalInboxEvent(
                          request: LeadInboxRequest(
                            userid: userDetails!.LPuserID,
                            token: ApiConstants.api_qa_token,
                            pageNo: index + 1,
                          ),
                        ),
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
