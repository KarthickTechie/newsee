import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/presentation/bloc/cif_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_page.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/pages/address.dart';
import 'package:newsee/pages/lead_submit_page.dart';
import 'package:newsee/pages/loan.dart';
import 'package:newsee/pages/personal.dart';
import 'package:newsee/widgets/side_navigation.dart';

class NewLeadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  LoanproductBloc()..add(
                    LoanproductInit(loanproductState: LoanproductState.init()),
                  ),
        ),
        BlocProvider(
          create:
              (context) =>
                  PersonalDetailsBloc()
                    ..add(PersonalDetailsInitEvent(cifResponseModel: null)),
          lazy: false,
        ),
        BlocProvider(
          create:
              (context) =>
                  AddressDetailsBloc()
                    ..add(AddressDetailsInitEvent(cifResponseModel: null)),
          lazy: false,
        ),
        BlocProvider(create: (context) => DedupeBloc(), lazy: false),
        BlocProvider(create: (context) => CifBloc()),
        BlocProvider(create: (context) => LeadSubmitBloc()),
      ],
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar:
              Globalconfig.isInitialRoute
                  ? null
                  : AppBar(
                    title: Text(
                      'Lead Details',
                      style: TextStyle(color: Colors.white),
                    ),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(color: Colors.teal),
                    ),
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      tabs: <Widget>[
                        Tab(icon: Icon(Icons.badge, color: Colors.white)),
                        Tab(icon: Icon(Icons.file_copy, color: Colors.white)),
                        Tab(icon: Icon(Icons.face, color: Colors.white)),
                        Tab(
                          icon: Icon(Icons.location_city, color: Colors.white),
                        ),
                        Tab(icon: Icon(Icons.done_all, color: Colors.white)),
                      ],
                    ),
                  ),
          drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
          body: TabBarView(
            children: [
              Loan(title: 'loan'),
              DedupeView(title: 'dedupe'),
              Personal(title: 'personal'),
              Address(title: 'address'),
              LeadSubmitPage(title: 'Lead Details'),
            ],
          ),
        ),
      ),
    );
  }
}
