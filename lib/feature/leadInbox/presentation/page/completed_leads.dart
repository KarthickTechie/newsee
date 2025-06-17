
/*
  @author     : gayathri.b 12/06/2025
  @desc       : Stateless widget that renders a list of completed leads using BLoC.
                It dispatches a SearchLeadEvent on initialization and listens to state changes.
                Based on the state (loading, success, or failure), it renders:
                - Shimmer loading cards while waiting,
              
*/


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/presentation/bloc/lead_bloc.dart';
import 'package:newsee/widgets/lead_tile_card-shimmer.dart';
import '../../../../widgets/lead_tile_card.dart';

class CompletedLeads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadBloc()
      ..add(SearchLeadEvent(request: LeadRequest(userid: "AGRI1124"))),
      child: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {

          if(state.status == LeadStatus.loading)
          {
            // return const Center(child: ShimmerLoader(cardHeight: 120,itemCount: 5));
            return ListView.builder(
            itemCount: 4,
            itemBuilder: (context,index){

                return LeadTileCardShimmer(
                title: 'dfsdfsfdsfsd',
                subtitle: 'dfsdfsfdsfsd',
                icon: Icons.person,
                color: Colors.teal,
                type: 'dfsdfsfdsfsd',
                product: 'dfsdfsfdsfsd',
                phone: 'dfsdfsfdsfsd',
                createdon: 'dfsdfsfdsfsd',
                location: 'dfsdfsfdsfsd',
                loanamount: 'dfsdfsfdsfsd',
              );
             



            },
             
           
            
          );

          }
            if (state.status == LeadStatus.failure) {
            return Center(child: Text(" ${state.errorMessage ?? 'Something went wrong'}"));
          }

          final allLeads = state.leadResponseModel ?.expand((model)=> model.leadlists).toList();
 
         if(allLeads == null || allLeads.isEmpty){
          return const Center(child: Text("No leads found."));
         }

          print("final completed lead response $state");
          return ListView.builder(
            itemCount: allLeads.length,
            itemBuilder: (context,index){
              final lead = allLeads[index];

                return LeadTileCard(
                title: lead['lleadfrstname'] ?? 'N/A',
                subtitle: lead['lleadid'] ?? 'N/A',
                icon: Icons.person,
                color: Colors.teal,
                type: lead['existingCustomer'] == true ? 'Existing Customer' : 'New Customer',
                product: lead['lfProdId'] ?? 'N/A',
                phone: lead['lleadmobno'] ?? 'N/A',
                createdon: lead['lpdCreatedOn'] ?? 'N/A',
                location: lead['lleadprefbrnch'] ?? 'N/A',
                loanamount: lead['lldLoanamtRequested']?.toString() ?? '',
              );
            },
            
            
          );
        },
      ),
    );
  }
}
