import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/bottom_sheet_container.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeView extends StatelessWidget {
  final String title;
  DedupeView({required this.title, super.key});

  final dedupeForm = AppForms.DEDUPE_DETAILS_FORM;
  final cifForm = AppForms.CIF_DETAILS_FORM;  

  /* 
    @author     : ganeshkumar.b  9/06/2025
    @desc       : Open Existing or New Customer Form BottomSheet
    @param      : null
  */
  void _openModalSheet(
    BuildContext context,
    bool isNewCustomer,
    FormGroup form,
    String customerConstitution,
  ) {
    final tabController = DefaultTabController.of(context);
    final dedupebloc = context.read<DedupeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:(BuildContext context) => 
        BlocProvider.value(
          value: dedupebloc,
          child: BottomSheetContainer(isNewCustomer: isNewCustomer, form: form, tabController: tabController, constitution: customerConstitution)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? selectedValue;
    String? constitution;
    // List<Map<String, dynamic>> dataList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dedupe Details"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          "Select Customer Constution",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            
                            color: Colors.white
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey, blurStyle: BlurStyle.outer)]
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text("Individual"),
                              leading: Radio<String>(
                                value: "I",
                                groupValue: constitution,
                                onChanged: (value) {
                                  setState(() => constitution = value);
                                },
                              ),
                              onTap: () {
                                setState(() => constitution = "I");
                              },
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(),
                            )
                            ,
                            ListTile(
                              title: const Text("Non-Individual"),
                              leading: Radio<String>(
                                value: "N",
                                groupValue: constitution,
                                onChanged: (value) {
                                  setState(() => constitution = value);
                                },
                              ),
                              onTap: () {
                                setState(() => constitution = "N");
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          "Select Customer Type",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            
                            color: Colors.white
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey, blurStyle: BlurStyle.outer)]
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text("New Customer"),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() => selectedValue = value);
                                  _openModalSheet(context, true, dedupeForm, constitution!);
                                },
                              ),
                              onTap: () {
                                setState(() => selectedValue = true);
                                _openModalSheet(context, true, dedupeForm, constitution!);
                              },
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(),
                            )
                            ,
                            ListTile(
                              title: const Text("Existing Customer"),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() => selectedValue = value);
                                  _openModalSheet(context, false, cifForm, constitution!);
                                },
                              ),
                              onTap: () {
                                setState(() => selectedValue = false);
                                _openModalSheet(context, false, cifForm, constitution!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
            ),
          )
      );
  }
}