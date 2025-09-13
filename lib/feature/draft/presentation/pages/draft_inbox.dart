
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/cic_check/cic_check_page.dart';
import 'package:newsee/feature/draft/domain/draft_lead_model.dart';
import 'package:newsee/feature/draft/draft_service.dart';
import 'package:newsee/feature/draft/draft_event_notifier.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/lead_tile_card.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:number_paginator/number_paginator.dart';

class DraftInbox extends StatefulWidget {
  const DraftInbox({super.key});

  @override
  DraftInboxState createState() => DraftInboxState();
}

class DraftInboxState extends State<DraftInbox> {
  final DraftService draftService = DraftService();
  List<DraftLead> allDrafts = [];
  int currentPage = 0;
  int pageSize = 10;

  @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadDrafts();


    draftEventNotifier.addListener(_onDraftEvent);
  }

  @override
  void dispose() {
    draftEventNotifier.removeListener(_onDraftEvent);
    super.dispose();
  }

  void _onDraftEvent() {
    loadDrafts();
  }

  Future<void> loadDrafts() async {
    final refs = await draftService.getAllDraftLeadRefs();
    final List<DraftLead> loaded = [];
    for (var ref in refs) {
      final draft = await draftService.getDraft(ref);
      if (draft != null) loaded.add(draft);
    }
 



    setState(() => allDrafts = loaded);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    final paginatedDrafts =
        allDrafts.skip(currentPage * pageSize).take(pageSize).toList();
    final numberOfPages = (allDrafts.length / pageSize).ceil();

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadDrafts,
            child:
                allDrafts.isEmpty
                    ? ListView(
                      children: const [
                        SizedBox(
                          height: 250,
                          child: Center(
                            child: Text(
                              'No leads found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : ListView.builder(
                      itemCount: paginatedDrafts.length,
                      itemBuilder: (context, index) {
                        final draft = paginatedDrafts[index];
                        return LeadTileCard(
                          title: draft.personal['firstName'] ?? 'N/A',
                          subtitle: draft.leadref,
                          icon: Icons.person,
                          color: Colors.teal,
                          type:
                              draft.dedupe['isNewCustomer'] == false
                                  ? 'Existing Customer'
                                  : 'New Customer',
                          product:
                              draft
                                  .loan['selectedProductScheme']['optionDesc'] ??
                              'N/A',
                          phone: draft.personal['primaryMobileNumber'] ?? 'N/A',
                          ennablePhoneTap: true,
                          createdon: draft.personal['dob'] ?? 'N/A',
                          location: draft.address['state'] ?? 'N/A',
                          loanamount:
                              draft.personal['loanAmountRequested']
                                  ?.toString() ??
                              '',
                        
                          onTap: () {
                            openBottomSheet(context, 0.6, 0.4, 0.9, (
                              context,
                              scrollController,
                            ) {
                              return SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                     OptionsSheet(
                                      icon: Icons.document_scanner,
                                      title: "CIC Check",
                                      subtitle: "View your CIC here",
                                      status: 'pending',
                                      onTap: () {
                                        context.pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => CicCheckPage(),
                                                
                                          ),
                                        );
                                      },
                                    ),

                                    if (
                                        draft.loan['selectedProductScheme']?['optionValue'] ==
                                            "129")
                                      OptionsSheet(
                                        icon: Icons.agriculture_sharp,
                                        title: "Poultry Details",
                                        subtitle:
                                            "View your Poultry Details here",
                                        onTap: () {
                                          context.pop();
                                             context.pushNamed('poultrydetails', extra: {'leadId': draft.leadref} );
                                        },
                                      ),

                                    if (
                                        draft.loan['selectedProductScheme']?['optionValue'] ==
                                            "55")
                                      OptionsSheet(
                                        icon: Icons.collections_bookmark,
                                        title: "Dairy Details",
                                        subtitle:
                                            "View your Dairy Details here",
                                      onTap: () {
                                          if (draft.leadref == null || draft.leadref.isEmpty) {
                                            debugPrint(" LeadRef missing, cannot open DairyDetailsPage");
                                            return;
                                          }
                                          context.pushNamed(
                                            'dairydetails',
                                            extra: {'leadId': draft.leadref},
                                          );
                                        },
                                      ),
                                      

                                    if (draft.loan['selectedProductScheme']?['optionValue'] !=
                                            "129" &&
                                        draft.loan['selectedProductScheme']?['optionValue'] !=
                                            "55") ...[
                                               
                                      OptionsSheet(
                                        icon: Icons.landscape,
                                        title: "Land Details",
                                        subtitle: "View your Land Details here",
                                        status: 'pending',
                                        onTap: () {
                                          context.pop();
                                          context.pushNamed(
                                            'landholdings',
                                            extra: {
                                              'applicantName': 'SaravanaKumar',
                                              'proposalNumber': '1287654445569',
                                            },
                                          );
                                        },
                                      ),
                                      OptionsSheet(
                                        icon: Icons.grass,
                                        title: "Crop Details",
                                        subtitle: "View your Crop Details here",
                                        status: 'pending',
                                        onTap: () {
                                          context.pop();
                                          context.pushNamed(
                                            'cropdetails',
                                            extra: '1098776666667',
                                          );
                                        },
                                      ),
                                      
                                  
                                    ],

                                    // Document upload
                                    OptionsSheet(
                                      icon: Icons.description,
                                      title: "Document Upload",
                                      subtitle:
                                          "Pre-Sanctioned Documents Upload",
                                      status: 'pending',
                                      onTap: () {
                                        context.pop();
                                        context.pushNamed(
                                          'document',
                                          extra: '1034557766666',
                                        );
                                      },
                                    ),

                                    // Field Investigation
                                    OptionsSheet(
                                      icon: Icons.description,
                                      title: "Field Investigation",
                                      subtitle:
                                          "Field Investigation Details here",
                                      status: 'pending',
                                      onTap: () {
                                        context.pop();
                                        context.pushNamed(
                                          'fieldinvestigation',
                                          extra: {
                                            'proposalNumber': '1456453987',
                                          },
                                        );
                                      },
                                    ),

                                    // Field Investigation Documents
                                    OptionsSheet(
                                      icon: Icons.description,
                                      title: "Field Investigation Documents",
                                      subtitle:
                                          "Field Investigation Document Capture here",
                                      status: 'pending',
                                      onTap: () {
                                        context.pop();
                                        context.pushNamed(
                                          'document',
                                          extra: "9298776696",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                          },

                          showarrow: false,
                        );
                      },
                    ),
          ),
        ),
        if (numberOfPages > 1)
          Padding(
            padding: const EdgeInsets.all(5),
            child: NumberPaginator(
              numberPages: numberOfPages,
              initialPage: currentPage,
              onPageChange: (int index) {
                setState(() {
                  currentPage = index;
                });
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
    );
  }
}
