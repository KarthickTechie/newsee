import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/presentation/bloc/cif_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/page/coapp_page.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_page.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/pages/address.dart';
import 'package:newsee/pages/lead_submit_page.dart';
import 'package:newsee/pages/loan.dart';
import 'package:newsee/pages/personal.dart';
import '../widgets/side_navigation.dart';

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
        BlocProvider(create: (context) => DedupeBloc()),

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
        BlocProvider(
          create: (context) => CoappDetailsBloc()..add(CoAppDetailsInitEvent()),
          lazy: false,
        ),

        BlocProvider(create: (context) => LeadSubmitBloc()),
      ],
      child: DefaultTabController(
        length: 6,
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
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60.0),
                      child: Builder(
                        builder: (context) {
                          final personalState =
                              context.watch<PersonalDetailsBloc>().state;
                          final addressState =
                              context.watch<AddressDetailsBloc>().state;
                          final dedupeState = context.watch<DedupeBloc>().state;
                          final loanState =
                              context.watch<LoanproductBloc>().state;
                          final coappState =
                              context.watch<CoappDetailsBloc>().state;

                          return TabBar(
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            tabs: <Widget>[
                              Tab(
                                icon: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.badge,
                                        color: Colors.white,
                                      ),
                                      if (loanState.status?.name ==
                                          SaveStatus.success.name)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                icon: FittedBox(
                                  fit: BoxFit.scaleDown,

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.file_copy,
                                        color: Colors.white,
                                      ),
                                      if (dedupeState.status?.name ==
                                          SaveStatus.success.name)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                icon: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.face,
                                        color: Colors.white,
                                      ),
                                      if (personalState.status?.name ==
                                          SaveStatus.success.name)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                icon: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_city,
                                        color: Colors.white,
                                      ),
                                      if (addressState.status ==
                                          SaveStatus.success)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ), // address tab
                              Tab(
                                icon: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.add_reaction,
                                        color: Colors.white,
                                      ),
                                      if (coappState.status ==
                                          SaveStatus.success)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ), // co applicant tab
                              const Tab(
                                icon: Icon(Icons.done_all, color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
          drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
          body: TabBarView(
            children: [
              Loan(title: 'loan'),
              DedupeView(title: 'dedupe'),
              Personal(title: 'personal'),
              Address(title: 'address'),
              CoApplicantPage(title: 'Co Applicant Details'),
              LeadSubmitPage(title: 'Lead Details'),
            ],
          ),
        ),
      ),
    );
  }
}
