import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/qr_nav_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/coapplicant/applicants_utility_service.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CoApplicantFormBottomSheet extends StatefulWidget {
  final TabController? tabController;
  final String? applicantType;
  final CoapplicantData? existingData;
  final int? index;
  const CoApplicantFormBottomSheet({
    super.key,
    this.tabController,
    this.applicantType,
    this.existingData,
    this.index,
  });

  @override
  State<CoApplicantFormBottomSheet> createState() =>
      _CoApplicantFormBottomSheetState();
}

class _CoApplicantFormBottomSheetState
    extends State<CoApplicantFormBottomSheet> {
  final FormGroup coAppAndGurantorForm = AppForms.COAPPLICANT_DETAILS_FORM;
  late final String title;
  bool refAadhaar = false;
  @override
  void initState() {
    super.initState();
    coAppAndGurantorForm.reset();
    title = widget.applicantType == 'C' ? 'Co-Applicant' : 'Gurantor';
    if (widget.existingData != null) {
      coAppAndGurantorForm.patchValue(widget.existingData!.toMap());
      if (widget.existingData!.aadharRefNo != null) {
        refAadhaar = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Kwillpopscope(
      form: coAppAndGurantorForm,
      routeContext: context,
      widget: SafeArea(
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BlocConsumer<CoappDetailsBloc, CoappDetailsState>(
            listener: (context, state) {
              print(
                'coapplicantdetail::BlocConsumer:listen => ${state.lovList} ${state.coAppList} ${state.status?.name}',
              );
              if (state.status == SaveStatus.success) {
                showSnack(
                  context,
                  message: '$title Details Saved Successfully',
                );
                goToNextTab(context: context);
              } else if (state.status == SaveStatus.failure) {
                globalLoadingBloc.add(HideLoading());

                showSnack(context, message: 'Failed to Save $title Details');
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
                final controls = coAppAndGurantorForm.controls.entries;
                final cifresponse = state.selectedCoApp?.toMap();
                print(cifresponse);
                if (cifresponse?['aadharRefNo'] != null) {
                  refAadhaar = true;
                }
                for (final ctrl in controls) {
                  final key = ctrl.key;
                  final value = cifresponse?[key];

                  if (value != null) {
                    if (key == 'dob') {
                      final formattedDate = getDateFormatedByProvided(
                        value,
                        from: AppConstants.Format_dd_MM_yyyy,
                        to: AppConstants.Format_yyyy_MM_dd,
                      );
                      coAppAndGurantorForm
                          .control(key)
                          .updateValue(formattedDate);
                    } else if (key == 'state' || key == 'cityDistrict') {
                      coAppAndGurantorForm.control(key).updateValue("");
                    } else {
                      coAppAndGurantorForm.control(key).updateValue(value);
                    }
                  }
                }

                // for (final ctrl in controls) {
                //   if (cifresponse?[ctrl.key] != null) {
                //     if (ctrl.key == 'dob') {
                //       final formattedDate = getDateFormatedByProvided(
                //         cifresponse?[ctrl.key],
                //         from: AppConstants.Format_dd_MM_yyyy,
                //         to: AppConstants.Format_yyyy_MM_dd,
                //       );
                //       print('formattedDate in coapppage => $formattedDate');
                //       coAppAndGurantorForm.controls[ctrl.key]?.updateValue(
                //         formattedDate,
                //       );
                //     }
                //     if (ctrl.key == 'state' || ctrl.key == 'cityDistrict') {
                //       coAppAndGurantorForm.controls[ctrl.key]?.updateValue("");
                //     }
                //     coAppAndGurantorForm.controls[ctrl.key]?.updateValue(
                //       cifresponse?[ctrl.key],
                //     );
                //   }
                // }
              } else if (state.status == SaveStatus.dedupefailure) {
                // showSnack(context, message: 'Cif pulling failed...');
                showErrorDialog(
                  context,
                  'Dedupe/CIF/Aadhar Validation failed...',
                );
              }
            },
            builder: (context, state) {
              if(state.status == SaveStatus.success && state.getLead) {
                coAppAndGurantorForm.markAsDisabled();
              }
              DedupeState? dedupeState;
              dedupeState = context.watch<DedupeBloc>().state;
              print('coapp : $dedupeState');
              return ReactiveForm(
                formGroup: coAppAndGurantorForm,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SearchableDropdown(
                                controlName: 'customertype',
                                label: 'Select CustomerType',
                                items:
                                    state.lovList!
                                        .where((v) => v.Header == 'CustType')
                                        .toList(),
                                selItem: () {
                                  final value =
                                      coAppAndGurantorForm
                                          .control('customertype')
                                          .value;
                                  if (value == null ||
                                      value.toString().isEmpty) {
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
                                onChangeListener: (Lov val) {
                                  coAppAndGurantorForm.controls['customertype']
                                      ?.updateValue(val.optvalue);
                                  setState(() {
                                    coAppAndGurantorForm.reset(
                                      value: {
                                        'customertype':
                                            coAppAndGurantorForm
                                                .control('customertype')
                                                .value,
                                      },
                                      removeFocus: true,
                                    );
                                  });
                                  refAadhaar = false;
                                  showHideCifField(
                                    context,
                                    coAppAndGurantorForm,
                                    // widget.tabController,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (coAppAndGurantorForm
                                    .control('customertype')
                                    .value ==
                                '001')
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed:
                                      state.isCifValid
                                          ? null
                                          : () => validateDedupe(
                                            context,
                                            widget.tabController,
                                          ),

                                  child: const Text("Dedupe"),
                                ),
                              ),
                          ],
                        ),
                        SearchableDropdown(
                          controlName: 'constitution',
                          label: 'Select Constitution',
                          items:
                              state.lovList!
                                  .where((v) => v.Header == 'Constitution')
                                  .toList(),
                          selItem: () {
                            final value =
                                coAppAndGurantorForm
                                    .control('constitution')
                                    .value;
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
                              (Lov val) => coAppAndGurantorForm
                                  .controls['constitution']
                                  ?.updateValue(val.optvalue),
                        ),
                        if (coAppAndGurantorForm
                                .control('customertype')
                                .value ==
                            '002')
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
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed:
                                      state.isCifValid
                                          ? null
                                          : () {
                                            cifSearch(
                                              context,
                                              coAppAndGurantorForm,
                                              widget.applicantType,
                                            );
                                          },
                                  child:
                                      state.status == SaveStatus.loading
                                          ? CircularProgressIndicator()
                                          : const Text("Search"),
                                ),
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
                            final value =
                                coAppAndGurantorForm.control('title').value;
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
                              (Lov val) => coAppAndGurantorForm
                                  .controls['title']
                                  ?.updateValue(val.optvalue),
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
                          label:
                              dedupeState.constitution == 'NI'
                                  ? 'Relationship With Firm'
                                  : 'Relationship With Applicant',
                          items:
                              state.lovList!
                                  .where((v) => v.Header == 'CoAppRelationship')
                                  .toList(),
                          selItem: () {
                            final value =
                                coAppAndGurantorForm
                                    .control('relationshipFirm')
                                    .value;
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
                              (Lov val) => coAppAndGurantorForm
                                  .controls['relationshipFirm']
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
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                coAppAndGurantorForm.control('dob').value =
                                    formatted;
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
                          mantatory: false,
                        ),
                        CustomTextField(
                          controlName: 'panNumber',
                          label: 'Pan No',
                          mantatory: true,
                          autoCapitalize: true,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: IntegerTextField(
                                controlName: 'aadharRefNo',
                                label: 'Aadhaar No',
                                mantatory: true,
                                maxlength: 12,
                                minlength: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: Icon(Icons.qr_code_scanner),
                              label: Text('Scan'),
                              onPressed: () => showScannerOptions(context),
                            ),
                          ],
                        ),

                        // if ((coAppAndGurantorForm
                        //                 .control('customertype')
                        //                 .value !=
                        //             '002' &&
                        //         coAppAndGurantorForm
                        //                 .control('customertype')
                        //                 .value !=
                        //             '001') ||
                        //     refAadhaar == false)
                        //   Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Expanded(
                        //         child: IntegerTextField(
                        //           controlName: 'aadhaar',
                        //           label: 'Aadhaar Number',
                        //           mantatory: true,
                        //           maxlength: 12,
                        //           minlength: 12,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 8),
                        //       ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor: const Color.fromARGB(
                        //             255,
                        //             3,
                        //             9,
                        //             110,
                        //           ),
                        //           foregroundColor: Colors.white,
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 10,
                        //           ),
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8),
                        //           ),
                        //         ),
                        //         onPressed: () {
                        //           final aadharvalidateRequest =
                        //               AadharvalidateRequest(
                        //                 aadhaarNumber:
                        //                     coAppAndGurantorForm
                        //                         .control('aadhaar')
                        //                         .value,
                        //               );
                        //           context.read<CoappDetailsBloc>().add(
                        //             AadhaarValidateEvent(
                        //               request: aadharvalidateRequest,
                        //             ),
                        //           );
                        //         },
                        //         child:
                        //             state.status == SaveStatus.loading
                        //                 ? CircularProgressIndicator()
                        //                 : const Text("Validate"),
                        //       ),
                        //     ],
                        //   ),
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
                          mantatory: false,
                        ),
                        SearchableDropdown(
                          controlName: 'state',
                          label: 'State',
                          items: state.stateCityMaster!,
                          onChangeListener: (GeographyMaster val) {
                            coAppAndGurantorForm.controls['state']?.updateValue(
                              val.code,
                            );
                            globalLoadingBloc.add(
                              ShowLoading(message: "Fetching city..."),
                            );

                            context.read<CoappDetailsBloc>().add(
                              OnStateCityChangeEvent(stateCode: val.code),
                            );
                          },
                          selItem: () {
                            final value =
                                coAppAndGurantorForm.control('state').value;
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
                                coAppAndGurantorForm.controls['state']
                                    ?.updateValue(geographyMaster.code);
                                return geographyMaster;
                              } else {
                                return <GeographyMaster>[];
                              }
                            } else if (state.stateCityMaster!.isEmpty) {
                              coAppAndGurantorForm.controls['state']
                                  ?.updateValue("");
                              return <GeographyMaster>[];
                            } else if (state.getLead) {
                              String? stateCode = widget.existingData!.state;
      
                              GeographyMaster? geographyMaster = state
                                  .stateCityMaster
                                  ?.firstWhere((val) => val.code == stateCode);
                              if (geographyMaster != null) {
                                coAppAndGurantorForm.controls['state']
                                    ?.updateValue(geographyMaster.code);
                                return geographyMaster;
                              } else {
                                return <GeographyMaster>[];
                              }
                            }
                          },
                        ),
                        SearchableDropdown(
                          controlName: 'cityDistrict',
                          label: 'City',
                          items: state.cityMaster!,
                          onChangeListener: (GeographyMaster val) {
                            coAppAndGurantorForm.controls['cityDistrict']
                                ?.updateValue(val.code);
                          },
                          selItem: () {
                            final value =
                                coAppAndGurantorForm
                                    .control('cityDistrict')
                                    .value;
                            if (value == null || value.toString().isEmpty) {
                              return null;
                            } else {
                              GeographyMaster? geographyMaster = state
                                  .cityMaster
                                  ?.firstWhere((val) => val.code == value);
                              print(geographyMaster);
                              if (geographyMaster != null) {
                                coAppAndGurantorForm.controls['cityDistrict']
                                    ?.updateValue(geographyMaster.code);
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
                              if (state.getLead == false) {
                                print(
                                  "coapplicant Details value ${coAppAndGurantorForm.value}, ${coAppAndGurantorForm.valid}, ${state.isCifValid}",
                                );
                                if ((coAppAndGurantorForm
                                                .control('customertype')
                                                .value ==
                                            '001' ||
                                        coAppAndGurantorForm
                                                .control('customertype')
                                                .value ==
                                            '002') &&
                                    state.isCifValid == false) {
                                  showErrorDialog(
                                    context,
                                    'Please validate Dedupe/CIF before submitting.',
                                  );
                                  return;
                                } else {
                                  if (coAppAndGurantorForm.valid) {
                                    print('formco: $coAppAndGurantorForm');
                                    CoapplicantData coapplicantData =
                                        CoapplicantData.fromMap(
                                          coAppAndGurantorForm.value,
                                        );
                                    CoapplicantData coapplicantDataFormatted =
                                        coapplicantData.copyWith(
                                          dob: getDateFormatedByProvided(
                                            coapplicantData.dob,
                                            from: AppConstants.Format_dd_MM_yyyy,
                                            to: AppConstants.Format_yyyy_MM_dd,
                                          ),
                                          applicantType: widget.applicantType,
                                        );
                                    context.read<CoappDetailsBloc>().add(
                                      CoAppDetailsSaveEvent(
                                        coapplicantData: coapplicantDataFormatted,
                                        index: widget.index,
                                      ),
                                    );
                                    Navigator.of(context).pop({});
                                  } else {
                                    coAppAndGurantorForm.controls.forEach((
                                      key,
                                      control,
                                    ) {
                                      if (control.invalid) {
                                        print(
                                          'Field "$key" is invalid: ${control.errors}',
                                        );
                                      }
                                    });
                                    coAppAndGurantorForm.markAllAsTouched();
                                    showErrorDialog(
                                      context,
                                      'Please Check and Enter Valid Data',
                                    );
                                  }
                                }
                              }
                              
                              
                            },
                            child: Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    // );
  }
}
