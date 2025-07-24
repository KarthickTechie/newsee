import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_search.dart';
import 'package:reactive_forms/reactive_forms.dart';

final FormGroup dedupeForm = AppForms.DEDUPE_DETAILS_FORM;

void cifSearch(BuildContext context, FormGroup form, String? applicantType) {
  final String type = applicantType == 'C' ? 'coapplicant' : 'guarantor';
  if (form.control('cifNumber').valid) {
    final req = CIFRequest(
      cifId: form.control('cifNumber').value,
      type: 'borrower',
      token: ApiConstants.api_qa_token,
    );
    context.read<CoappDetailsBloc>().add(
      CoAppGurantorSearchCifEvent(request: req),
    );
  } else {
    form.control('cifNumber').markAsTouched();
  }
}

Future<void> showHideCifField(BuildContext context, FormGroup form) async {
  final customerType = form.control('customertype').value;
  print('customertype: $customerType');
  context.read<CoappDetailsBloc>().add(CifEditManuallyEvent(false));
  if (customerType != '002') {
    print('customertype: $customerType');
    form.control('cifNumber').clearValidators();
    form.control('cifNumber').updateValue(null);
    form.control('cifNumber').updateValueAndValidity();
  } else if (customerType == '002') {
    print('customertype rdff: $customerType');
    context.read<CoappDetailsBloc>().add(CifEditManuallyEvent(false));
    form.control('cifNumber').setValidators([Validators.required]);
    form.control('cifNumber').updateValueAndValidity();
  }
}

validateDedupe(BuildContext context, TabController? tabController) {
  _openModalSheet(context, tabController!);
}

Future<void> _openModalSheet(
  BuildContext context,
  // FormGroup dedupeForm,
  TabController tabController,
) async {
  try {
    dedupeForm.reset();
    final bloc = context.read<CoappDetailsBloc>();

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetcontext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return BlocProvider(
              create: (_) => DedupeBloc(),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetcontext).viewInsets.bottom,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: DedupeSearch(
                    dedupeForm: dedupeForm,
                    tabController: tabController,
                    onSuccess: (state) {
                      if (state.aadharvalidateResponse != null) {
                        final aadhar = state.aadharvalidateResponse!;
                        print('aadhar res: $aadhar');
                        bloc.add(
                          CoAppDetailsDedupeEvent(coapplicantData: aadhar),
                        );
                      } else if (state.dedupeResponse != null) {
                        final dedupe = state.dedupeResponse!;
                        if (dedupe.remarksFlag == false) {
                          ScaffoldMessenger.of(sheetcontext).showSnackBar(
                            const SnackBar(content: Text("Remarks flagged")),
                          );
                        } else {
                          if (tabController.index < tabController.length - 1) {
                            tabController.animateTo(tabController.index + 1);
                          }
                        }
                      } else {
                        showErrorDialog(context, state.errorMsg);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    print('dedupResule: $result');
  } catch (e) {
    showErrorDialog(context, e);
  }
}

void showErrorDialog(BuildContext context, message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
