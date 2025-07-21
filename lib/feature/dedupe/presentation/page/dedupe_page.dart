import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/bottom_sheet_container.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeView extends StatelessWidget {
  final String title;
  DedupeView({required this.title, super.key});

  final dedupeForm = AppForms.DEDUPE_DETAILS_FORM;
  final cifForm = AppForms.CIF_DETAILS_FORM;
  final customerTypeForm = AppForms.CUSTOMER_TYPE_FORM;

  void callOpenSheet(context, state) {
    print("customerTypeForm.value ${customerTypeForm.value}");
    if (state.isNewCustomer) {
      dedupeForm.reset();
      _openModalSheet(context, true, dedupeForm);
    } else {
      _openModalSheet(context, false, cifForm);
    }
  }

  /* 
    @author     : ganeshkumar.b  9/06/2025
    @desc       : Open Existing or New Customer Form BottomSheet
    @param      : null
  */
  void _openModalSheet(
    BuildContext context,
    bool isNewCustomer,
    FormGroup form,
  ) {
    final tabController = DefaultTabController.of(context);
    final dedupebloc = context.read<DedupeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (BuildContext context) => BlocProvider.value(
            value: dedupebloc,
            child: BottomSheetContainer(
              isNewCustomer: isNewCustomer,
              form: form,
              tabController: tabController,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Kwillpopscope(
      routeContext: context,
      form: customerTypeForm,
      widget: Scaffold(
        appBar: AppBar(
          title: const Text("Dedupe Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<DedupeBloc, DedupeState>(
          listener:
              (context, state) => {
                if (state.status == DedupeFetchStatus.change)
                  {callOpenSheet(context, state)},
              },
          builder: (context, state) {
            print("Current status => ${state.status}");
            print("Current state, => $state");
            print("customerTypeForm ${customerTypeForm.value}");
            if (state.status == null) {
              customerTypeForm.reset();
            }
            return ReactiveForm(
              formGroup: customerTypeForm,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Select Customer Constution",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ReactiveRadioListTile<String>(
                                title: const Text('Individual'),
                                value: 'I',
                                formControlName: 'constitution',
                                onChanged: (control) {
                                  if (customerTypeForm.valid) {
                                    context.read<DedupeBloc>().add(
                                      OpenSheetEvent(
                                        request: customerTypeForm.value,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Divider(),
                              ),
                              ReactiveRadioListTile<String>(
                                title: const Text('Non-Individual'),
                                value: 'NI',
                                formControlName: 'constitution',
                                onChanged: (control) {
                                  if (customerTypeForm.valid) {
                                    context.read<DedupeBloc>().add(
                                      OpenSheetEvent(
                                        request: customerTypeForm.value,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Select Customer Type",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.grey,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ReactiveRadioListTile<bool>(
                                title: const Text('New Customer'),
                                value: true,
                                formControlName: 'isNewCustomer',
                                onChanged: (control) {
                                  if (customerTypeForm.valid) {
                                    context.read<DedupeBloc>().add(
                                      OpenSheetEvent(
                                        request: customerTypeForm.value,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Divider(),
                              ),
                              ReactiveRadioListTile<bool>(
                                title: const Text('Existing Customer'),
                                value: false,
                                formControlName: 'isNewCustomer',
                                onChanged: (control) {
                                  if (customerTypeForm.valid) {
                                    context.read<DedupeBloc>().add(
                                      OpenSheetEvent(
                                        request: customerTypeForm.value,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
