import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/badge_fab.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CoApplicantPage extends StatelessWidget {
  final String title;
  final FormGroup form = FormGroup({
    'customertype': FormControl<String>(validators: [Validators.required]),
    'constitution': FormControl<String>(validators: [Validators.required]),
    'cifNumber': FormControl<String>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'firstName': FormControl<String>(validators: [Validators.required]),
    'middleName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'relationshipFirm': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
    'primaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'secondaryMobileNumber': FormControl<String>(
      validators: [Validators.required, Validators.minLength(10)],
    ),
    'email': FormControl<String>(validators: [Validators.email]),
    'aadhaar': FormControl<String>(validators: []),
    'panNumber': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.PAN_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'aadharRefNo': FormControl<String>(
      validators: [
        Validators.pattern(AppConstants.AADHAAR_PATTERN),
        Validators.minLength(10),
      ],
    ),
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'cityDistrict': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(validators: [Validators.required]),
    'loanLiabilityCount': FormControl<String>(
      validators: [Validators.required],
    ),
    'loanLiabilityAmount': FormControl<String>(
      validators: [Validators.required],
    ),
    'depositCount': FormControl<String>(validators: [Validators.required]),
    'depositAmount': FormControl<String>(validators: [Validators.required]),
  });

  bool refAadhaar = false;

  CoApplicantPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("CoApplicant Details"),
        automaticallyImplyLeading: false,
      ),

      body: BlocConsumer<CoappDetailsBloc, CoappDetailsState>(
        listener: (context, state) {
          print(
            'coapplicantdetail::BlocConsumer:listen => ${state.lovList} ${state.coAppList} ${state.status?.name}',
          );
          if (state.status == SaveStatus.success) {
            showSnack(context, message: 'Personal Details Saved Successfully');
            goToNextTab(context: context);
          } else if (state.status == SaveStatus.failure) {
            globalLoadingBloc.add(HideLoading());

            showSnack(context, message: 'Failed to Save Personal Details');
          }
          if (state.status == SaveStatus.mastersucess ||
              state.status == SaveStatus.masterfailure) {
            if (state.status == SaveStatus.masterfailure) {
              showSnack(context, message: 'Failed to Fetch Masters...');
            }

            print('city list => ${state.cityMaster}');
            globalLoadingBloc.add(HideLoading());
          }

          if (state.status == SaveStatus.dedupesuccess) {
            final controls = form.controls.entries;
            final cifresponse = state.selectedCoApp?.toMap();
            for (final ctrl in controls) {
              if (cifresponse?[ctrl.key] != null) {
                if (ctrl.key == 'dob') {
                  final formattedDate = getDateFormatedByProvided(
                    cifresponse?[ctrl.key],
                    from: AppConstants.Format_dd_MM_yyyy,
                    to: AppConstants.Format_yyyy_MM_dd,
                  );
                  print('formattedDate in coapppage => $formattedDate');
                  form.controls[ctrl.key]?.updateValue(formattedDate);
                }
                if (ctrl.key == 'state' || ctrl.key == 'cityDistrict') {
                  form.controls[ctrl.key]?.updateValue("");
                }
                form.controls[ctrl.key]?.updateValue(cifresponse?[ctrl.key]);
              }
            }
          } else if (state.status == SaveStatus.dedupefailure) {
            showSnack(context, message: 'Cif pulling failed...');
          }
        },
        builder: (context, state) {
          return ReactiveForm(
            formGroup: form,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SearchableDropdown(
                      controlName: 'customertype',
                      label: 'Select CustomerType',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'CustType')
                              .toList(),
                      selItem: () {
                        final value = form.control('customertype').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        }
                        return state.lovList!
                            .where((v) => v.Header == 'CustType')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'customertype',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                      onChangeListener:
                          (Lov val) => form.controls['customertype']
                              ?.updateValue(val.optvalue),
                    ),
                    SearchableDropdown(
                      controlName: 'constitution',
                      label: 'Select Constitution',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'Constitution')
                              .toList(),
                      selItem: () {
                        final value = form.control('constitution').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        }
                        return state.lovList!
                            .where((v) => v.Header == 'Constitution')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'Constitution',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                      onChangeListener:
                          (Lov val) => form.controls['constitution']
                              ?.updateValue(val.optvalue),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: IntegerTextField(
                            controlName: 'cifNumber',
                            label: 'Enter Cif Number',
                            mantatory: true,
                            maxlength: 12,
                            minlength: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              3,
                              9,
                              110,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            cifSearch(context);
                          },
                          child:
                              state.status == SaveStatus.loading
                                  ? CircularProgressIndicator()
                                  : const Text("Search"),
                        ),
                      ],
                    ),
                    SearchableDropdown(
                      controlName: 'title',
                      label: 'Title',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'Title')
                              .toList(),
                      selItem: () {
                        final value = form.control('title').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        }
                        return state.lovList!
                            .where((v) => v.Header == 'Title')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'Title',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                      onChangeListener:
                          (Lov val) =>
                              form.controls['title']?.updateValue(val.optvalue),
                    ), // title
                    CustomTextField(
                      controlName: 'firstName',
                      label: 'First Name',
                      mantatory: true,
                    ),

                    CustomTextField(
                      controlName: 'middleName',
                      label: 'Middle Name',
                      mantatory: true,
                    ),
                    CustomTextField(
                      controlName: 'lastName',
                      label: 'Last Name',
                      mantatory: true,
                    ), // lastName
                    SearchableDropdown(
                      controlName: 'relationshipFirm',
                      label: 'Relationship With Firm',
                      items:
                          state.lovList!
                              .where((v) => v.Header == 'CoAppRelationship')
                              .toList(),
                      selItem: () {
                        final value = form.control('relationshipFirm').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        }
                        return state.lovList!
                            .where((v) => v.Header == 'CoAppRelationship')
                            .firstWhere(
                              (lov) => lov.optvalue == value,
                              orElse:
                                  () => Lov(
                                    Header: 'CoAppRelationship',
                                    optvalue: '',
                                    optDesc: '',
                                    optCode: '',
                                  ),
                            );
                      },
                      onChangeListener:
                          (Lov val) => form.controls['relationshipFirm']
                              ?.updateValue(val.optvalue),
                    ), // relationshipwithfirm
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ReactiveTextField<String>(
                        formControlName: 'dob',
                        validationMessages: {
                          ValidationMessage.required:
                              (error) => 'Date of Birth is required',
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Date Of Birth',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: (control) async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              Duration(days: 365 * 18),
                            ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            final formatted =
                                "${pickedDate.year}-"
                                "${pickedDate.month.toString().padLeft(2, '0')}-"
                                "${pickedDate.day.toString().padLeft(2, '0')}";
                            form.control('dob').value = formatted;
                          }
                        },
                      ),
                    ),
                    IntegerTextField(
                      controlName: 'primaryMobileNumber',
                      label: 'Primary Mobile Number',
                      mantatory: true,
                      maxlength: 10,
                      minlength: 10,
                    ),
                    IntegerTextField(
                      controlName: 'secondaryMobileNumber',
                      label: 'Secondary Mobile Number',
                      mantatory: false,
                      maxlength: 10,
                      minlength: 10,
                    ),
                    CustomTextField(
                      controlName: 'email',
                      label: 'Email Id',
                      mantatory: true,
                    ),
                    CustomTextField(
                      controlName: 'panNumber',
                      label: 'Pan No',
                      mantatory: true,
                      autoCapitalize: true,
                    ),
                    CustomTextField(
                      controlName: 'address1',
                      label: 'Address 1',
                      mantatory: true,
                    ),
                    CustomTextField(
                      controlName: 'address2',
                      label: 'Address 2',
                      mantatory: true,
                    ),
                    CustomTextField(
                      controlName: 'address3',
                      label: 'Address 3',
                      mantatory: true,
                    ),
                    SearchableDropdown(
                      controlName: 'state',
                      label: 'State',
                      items: state.stateCityMaster!,
                      onChangeListener: (GeographyMaster val) {
                        form.controls['state']?.updateValue(val.code);
                        globalLoadingBloc.add(
                          ShowLoading(message: "Fetching city..."),
                        );

                        context.read<CoappDetailsBloc>().add(
                          OnStateCityChangeEvent(stateCode: val.code),
                        );
                      },
                      selItem: () {
                        final value = form.control('state').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        }
                        if (state.selectedCoApp?.state != null) {
                          String? stateCode = state.selectedCoApp?.state;

                          GeographyMaster? geographyMaster = state
                              .stateCityMaster
                              ?.firstWhere((val) => val.code == stateCode);
                          print(geographyMaster);
                          if (geographyMaster != null) {
                            form.controls['state']?.updateValue(
                              geographyMaster.code,
                            );
                            return geographyMaster;
                          } else {
                            return <GeographyMaster>[];
                          }
                        } else if (state.stateCityMaster!.isEmpty) {
                          form.controls['state']?.updateValue("");
                          return <GeographyMaster>[];
                        }
                      },
                    ),
                    SearchableDropdown(
                      controlName: 'cityDistrict',
                      label: 'City',
                      items: state.cityMaster!,
                      onChangeListener: (GeographyMaster val) {
                        form.controls['cityDistrict']?.updateValue(val.code);
                      },
                      selItem: () {
                        final value = form.control('cityDistrict').value;
                        if (value == null || value.toString().isEmpty) {
                          return null;
                        } else {
                          GeographyMaster? geographyMaster = state.cityMaster
                              ?.firstWhere((val) => val.code == value);
                          print(geographyMaster);
                          if (geographyMaster != null) {
                            form.controls['cityDistrict']?.updateValue(
                              geographyMaster.code,
                            );
                            return geographyMaster;
                          } else {
                            return <GeographyMaster>[];
                          }
                        }
                      },
                    ),
                    IntegerTextField(
                      controlName: 'pincode',
                      label: 'Pin Code',
                      mantatory: true,
                      maxlength: 6,
                      minlength: 6,
                    ),
                    IntegerTextField(
                      controlName: 'loanLiabilityCount',
                      label: 'Loan Liability Count',
                      mantatory: true,
                      maxlength: 2,
                      minlength: 1,
                    ),
                    IntegerTextField(
                      controlName: 'loanLiabilityAmount',
                      label: 'Loan Liability Amount',
                      mantatory: true,
                      isRupeeFormat: true,
                    ),
                    IntegerTextField(
                      controlName: 'depositCount',
                      label: 'DepositCount',
                      mantatory: true,
                      maxlength: 2,
                      minlength: 1,
                    ),

                    IntegerTextField(
                      controlName: 'depositAmount',
                      label: 'Deposit Amount',
                      mantatory: true,
                      isRupeeFormat: true,
                    ),
                    SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 3, 9, 110),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          print("coapplicant Details value ${form.value}");

                          if (form.valid) {
                            CoapplicantData coapplicantData =
                                CoapplicantData.fromMap(form.value);
                            CoapplicantData coapplicantDataFormatted =
                                coapplicantData.copyWith(
                                  dob: getDateFormatedByProvided(
                                    coapplicantData.dob,
                                    from: AppConstants.Format_dd_MM_yyyy,
                                    to: AppConstants.Format_yyyy_MM_dd,
                                  ),
                                );
                            context.read<CoappDetailsBloc>().add(
                              CoAppDetailsSaveEvent(
                                coapplicantData: coapplicantDataFormatted,
                              ),
                            );
                          } else {
                            form.markAllAsTouched();
                            showSnack(
                              context,
                              message:
                                  'Please Check Error Message and Enter Valid Data',
                            );
                          }
                        },
                        child: Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /* 
  @author   : karthick.d 26/06/2025
  @desc     : search cif function
   */

  void cifSearch(BuildContext context) {
    if (form.control('cifNumber').valid) {
      final CIFRequest req = CIFRequest(
        cifId: form.control('cifNumber').value,
        type: 'borrower',
        token: ApiConstants.api_qa_token,
      );
      context.read<CoappDetailsBloc>().add(SearchCifEvent(request: req));
    } else {
      form.control('cifNumber').markAsTouched();
    }
  }
}
