import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/k_willpopscope.dart';
import 'package:newsee/widgets/badge_fab.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CoApplicantPage extends StatelessWidget {
  final String title;
  final FormGroup form = AppForms.COAPPLICANT_DETAILS_FORM;
  bool refAadhaar = false;

  CoApplicantPage({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();

    return Kwillpopscope(
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          title: Text("CoApplicant Details"),
          automaticallyImplyLeading: false,
        ),
      
        /// BadgeFab - reusable  widget with provision to customize
        /// color , icon , badge test style
      
        // floatingActionButton: BadgeFab(
        //   onPressed: () => {},
        //   bgColor: Colors.white,
        //   child: Icon(Icons.list, color: Colors.black),
        //   badgeColor: Colors.red,
        //   badgeChild: Center(
        //     child: Text(
        //       '5', // Replace with your count
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
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
                      CustomTextField(
                        controlName: 'cifNumber',
                        label: 'Enter Cif Number',
                        mantatory: true,
                      ),
                      SearchableDropdown(
                        controlName: 'title',
                        label: 'Title',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Title')
                                .toList(),
                        selItem: () {
                          if (state.selectedCoApp != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'Title' &&
                                  lov.optvalue == state.selectedCoApp?.title,
                            );
                            form.controls['title']?.updateValue(lov?.optvalue);
                            return lov;
                          } else {
                            return null;
                          }
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
                          if (state.selectedCoApp != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'CoAppRelationship' &&
                                  lov.optvalue ==
                                      state.selectedCoApp?.relationshipFirm,
                            );
                            form.controls['relationshipFirm']?.updateValue(
                              lov?.optvalue,
                            );
                            return lov;
                          } else {
                            return null;
                          }
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
                                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                                  "${pickedDate.year}";
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
                        selItem: () => null,
                      ),
                      SearchableDropdown(
                        controlName: 'cityDistrict',
                        label: 'City',
                        items: state.cityMaster!,
                        onChangeListener: (GeographyMaster val) {
                          form.controls['cityDistrict']?.updateValue(val.code);
                        },
                        selItem: () => null,
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
      
                              context.read<CoappDetailsBloc>().add(
                                CoAppDetailsSaveEvent(
                                  coapplicantData: coapplicantData,
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
      ),
    );
  }
}
