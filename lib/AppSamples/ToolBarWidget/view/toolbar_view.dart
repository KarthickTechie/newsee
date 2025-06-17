import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/pages/address_page.dart';
import 'package:newsee/pages/loan_details_page.dart';
import 'package:newsee/pages/sourcing_page.dart';
import 'package:newsee/timer/view/timer_view.dart';
import 'package:newsee/widgets/side_navigation.dart';

class ToolbarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar:
            Globalconfig.isInitialRoute
                ? null
                : AppBar(
                  actionsPadding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    (screenwidth * 0.1),
                    0,
                  ),
                  actions: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () => {context.goNamed('profile')},
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                  // leading: IconButton(
                  //   onPressed: () {
                  //     print('');
                  //   },
                  //   icon: Icon(Icons.person),
                  //   color: Colors.white,
                  // ),
                  leading: IconButton(
                    onPressed: () {
                      print(Scaffold()!.drawer);
                      // if (ScaffoldState().isDrawerOpen) {
                      //   ScaffoldState().closeDrawer();
                      // } else {
                      //   ScaffoldState().openDrawer();
                      // }
                    },
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                  ),
                  title: Text(
                    'New Lead',
                    style: TextStyle(color: Colors.white),
                  ),

                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.file_copy, color: Colors.white),
                        child: Text(
                          'Sourcing',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.face, color: Colors.white),
                        child: Text(
                          'Personal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.home, color: Colors.white),
                        child: Text(
                          'Address',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.currency_rupee_sharp,
                          color: Colors.white,
                        ),
                        child: Text(
                          'Loan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // actions: <Widget>[],
                ),
        drawer: Globalconfig.isInitialRoute ? null : Sidenavigationbar(),
        body: TabBarView(
          children: [
            // SourcingPage(title: 'Sourcing'),
            // PersonalDetailsPage(title: 'Personal'),
            // AddressPage(title: 'Address'),
            // LoanDetailsPage(title: 'LoanDetails'),
          ],
        ),
      ),
    );
  }
}
