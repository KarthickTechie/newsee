import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/qr_nav_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/widgets/SearchableMultiSelectDropdown.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Personal extends StatelessWidget {
  final String title;
  // scrollcontroller is required to scroll to errorformfield
  final _scrollController = ScrollController();
  Personal({required this.title, super.key});

  final FormGroup form = AppForms.GET_PERSONAL_DETAILS_FORM();
  final _titleKey = GlobalKey();
  final _firstNameKey = GlobalKey();
  final _middleNameKey = GlobalKey();
  final _lastNameKey = GlobalKey();
  final _dobKey = GlobalKey();
  final _residentialStatusKey = GlobalKey();
  final _primaryMobileNumberKey = GlobalKey();
  final _secondaryMobileNumberKey = GlobalKey();
  final _emailKey = GlobalKey();
  final _aadhaarKey = GlobalKey();
  final _panNumberKey = GlobalKey();
  final _aadharRefNoKey = GlobalKey();
  final _loanAmountRequestedKey = GlobalKey();
  final _natureOfActivityKey = GlobalKey();
  final _occupationTypeKey = GlobalKey();
  final _agriculturistTypeKey = GlobalKey();
  final _farmerCategoryKey = GlobalKey();
  final _farmerTypeKey = GlobalKey();
  final _religionKey = GlobalKey();
  final _casteKey = GlobalKey();
  final _genderKey = GlobalKey();
  final _subActivityKey = GlobalKey();
  bool refAadhaar = true;

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map Aadhaar response in personal form
    @param      : {AadharvalidateResponse val} - aadhaar response
  */
  mapAadhaarData(val) {
    try {
      if (val != null) {
        form.control('aadharRefNo').updateValue(val?.referenceId);
        refAadhaar = true;
        if (val.name != null) {
          String fullname = val?.name;
          List getNameArray = fullname.split(' ');
          if (getNameArray.length > 2) {
            String fullname = getNameArray.sublist(2).join();
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('middleName').updateValue(getNameArray[1]);
            form.control('lastName').updateValue(fullname);
          } else if (getNameArray.length == 2) {
            form.control('firstName').updateValue(getNameArray[0]);
            form.control('lastName').updateValue(getNameArray[1]);
          } else if (getNameArray.length == 1) {
            form.control('firstName').updateValue(getNameArray[0]);
          }
        }
        final formattedDate = getDateFormatedByProvided(
          val?.dateOfBirth!,
          from: AppConstants.Format_dd_MM_yyyy,
          to: AppConstants.Format_yyyy_MM_dd,
        );
        print('formattedDate in personal page => $formattedDate');

        form.control('dob').updateValue(formattedDate);
        form.control('email').updateValue(val?.email!);
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  /* 
    @author     : ganeshkumar.b  13/06/2025
    @desc       : map cif response in personal form
    @param      : {CifResponse val} - cifresponse
  */
  mapCifDate(val) {
    datamapperCif(val);
  }

  void datamapperCif(val) {
    try {
      form.control('firstName').updateValue(val.lleadfrstname!);
      form.control('middleName').updateValue(val.lleadmidname!);
      form.control('lastName').updateValue(val.lleadlastname!);
      form.control('dob').updateValue(getDateFormat(val.lleaddob!));
      form.control('primaryMobileNumber').updateValue(val.lleadmobno!);
      form.control('email').updateValue(val.lleademailid!);
      form.control('panNumber').updateValue(val.lleadpanno!);
      form.control('aadharRefNo').updateValue(val.lleadadharno!);
      if (val.lleadadharno != null) {
        refAadhaar = true;
      }
    } catch (error) {
      print("autoPopulateData-catch-error $error");
    }
  }

  /* 
    @author : karthick.d  
    @desc   : scroll to error field which identified first in the widget tree
              
   */

  void scrollToErrorField() async {
    final fields = [
      {'key': _titleKey, 'controlName': 'title'},
      {'key': _firstNameKey, 'controlName': 'firstName'},
      {'key': _middleNameKey, 'controlName': 'middleName'},
      {'key': _lastNameKey, 'controlName': 'lastName'},
      {'key': _dobKey, 'controlName': 'dob'},
      {'key': _primaryMobileNumberKey, 'controlName': 'primaryMobileNumber'},
      {
        'key': _secondaryMobileNumberKey,
        'controlName': 'secondaryMobileNumber',
      },
      {'key': _emailKey, 'controlName': 'email'},
      {'key': _panNumberKey, 'controlName': 'panNumber'},
      {'key': _aadhaarKey, 'controlName': 'aadhaar'},
      {'key': _aadharRefNoKey, 'controlName': 'aadharRefNo'},
      {'key': _loanAmountRequestedKey, 'controlName': 'loanAmountRequested'},
      {'key': _residentialStatusKey, 'controlName': 'residentialStatus'},
      {'key': _natureOfActivityKey, 'controlName': 'natureOfActivity'},
      {'key': _occupationTypeKey, 'controlName': 'occupationType'},
      {'key': _agriculturistTypeKey, 'controlName': 'agriculturistType'},
      {'key': _farmerCategoryKey, 'controlName': 'farmerCategory'},
      {'key': _farmerTypeKey, 'controlName': 'farmerType'},
      {'key': _religionKey, 'controlName': 'religion'},
      {'key': _casteKey, 'controlName': 'caste'},
      {'key': _genderKey, 'controlName': 'gender'},
    ];

    for (var field in fields) {
      final control = form.control(field['controlName'] as String);
      if (control.invalid && control.touched) {
        final context = (field['key'] as GlobalKey).currentContext;
        if (context != null) {
          await Scrollable.ensureVisible(
            context,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
          control.focus();
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          title: Text("Personal Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
          listener: (context, state) {
            print(
              'personaldetail::BlocConsumer:listen => ${state.lovList} ${state.personalData} ${state.status?.name}',
            );
            if (state.status == SaveStatus.success) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => SysmoAlert.success(
                      message: "Personal Details Saved Successfully",
                      onButtonPressed: () {
                        Navigator.pop(context);
                        goToNextTab(context: context);
                      },
                    ),
              );
            } else if (state.status == SaveStatus.failure) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => SysmoAlert.failure(
                      message: "Failed to save Loan Details",
                      onButtonPressed: () => Navigator.pop(context),
                    ),
              );
            }
          },
          builder: (context, state) {
            DedupeState? dedupeState;
            if (state.status == SaveStatus.init && state.aadhaarData != null) {
              mapAadhaarData(state.aadhaarData);
            } else if (state.status == SaveStatus.init) {
              dedupeState = context.watch<DedupeBloc>().state;
              if (dedupeState.cifResponse != null) {
                print(
                  'cif response title => ${dedupeState.cifResponse?.lleadtitle}',
                );
                print('state.lovList =>${state.lovList}');
                mapCifDate(dedupeState.cifResponse);
              } else if (dedupeState.aadharvalidateResponse != null) {
                mapAadhaarData(dedupeState.aadharvalidateResponse);
              }
            } else if (state.status == SaveStatus.success) {
              print('saved personal data =>${state.personalData}');
            }
            return ReactiveForm(
              formGroup: form,
              child: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SearchableDropdown(
                        fieldKey: _titleKey,
                        controlName: 'title',
                        label: 'Title',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Title')
                                .toList(),
                        selItem: () {
                          if (dedupeState?.cifResponse != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'Title' &&
                                  lov.optvalue ==
                                      dedupeState?.cifResponse?.lleadtitle,
                            );
                            form.controls['title']?.updateValue(lov?.optvalue);
                            return lov;
                          } else if (state.personalData != null) {
                            Lov? lov = state.lovList?.firstWhere(
                              (lov) =>
                                  lov.Header == 'Title' &&
                                  lov.optvalue == state.personalData?.title,
                            );
                            form.controls['title']?.updateValue(lov?.optvalue);
                            return lov;
                          } else {
                            return null;
                          }
                        },
                        onChangeListener:
                            (Lov val) => form.controls['title']?.updateValue(
                              val.optvalue,
                            ),
                      ),
                      CustomTextField(
                        fieldKey: _firstNameKey,
                        controlName: 'firstName',
                        label: 'First Name',
                        mantatory: true,
                      ),
                      CustomTextField(
                        fieldKey: _middleNameKey,
                        controlName: 'middleName',
                        label: 'Middle Name',
                        mantatory: true,
                      ),
                      CustomTextField(
                        fieldKey: _lastNameKey,
                        controlName: 'lastName',
                        label: 'Last Name',
                        mantatory: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ReactiveTextField<String>(
                          key: _dobKey,
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
                        fieldKey: _primaryMobileNumberKey,
                        controlName: 'primaryMobileNumber',
                        label: 'Primary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      IntegerTextField(
                        fieldKey: _secondaryMobileNumberKey,
                        controlName: 'secondaryMobileNumber',
                        label: 'Secondary Mobile Number',
                        mantatory: true,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      CustomTextField(
                        fieldKey: _emailKey,
                        controlName: 'email',
                        label: 'Email Id',
                        mantatory: true,
                      ),
                      CustomTextField(
                        fieldKey: _panNumberKey,
                        controlName: 'panNumber',
                        label: 'Pan No',
                        mantatory: true,
                        autoCapitalize: true,
                        maxlength: 10,
                      ),
                      refAadhaar
                          ? Row(
                            children: [
                              Expanded(
                                child: IntegerTextField(
                                  fieldKey: _aadharRefNoKey,
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
                          )
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IntegerTextField(
                                  fieldKey: _aadhaarKey,
                                  controlName: 'aadhaar',
                                  label: 'Aadhaar Number',
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
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  final AadharvalidateRequest
                                  aadharvalidateRequest = AadharvalidateRequest(
                                    aadhaarNumber:
                                        form.control('aadhaar').value,
                                  );
                                  context.read<PersonalDetailsBloc>().add(
                                    AadhaarValidateEvent(
                                      request: aadharvalidateRequest,
                                    ),
                                  );
                                },
                                child:
                                    state.status == SaveStatus.loading
                                        ? CircularProgressIndicator()
                                        : const Text("Validate"),
                              ),
                            ],
                          ),
                      IntegerTextField(
                        fieldKey: _loanAmountRequestedKey,
                        controlName: 'loanAmountRequested',
                        label: 'Loan Amount Required',
                        mantatory: true,
                        isRupeeFormat: true,
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _residentialStatusKey,
                        controlName: 'residentialStatus',
                        label: 'Residential Status',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'ResidentialStatus')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['residentialStatus']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('residentialStatus').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'ResidentialStatus')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'ResidentialStatus',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),

                      SearchableDropdown<Lov>(
                        fieldKey: _natureOfActivityKey,
                        controlName: 'natureOfActivity',
                        label: 'Nature of Activity',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'NatureOfActivity')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['natureOfActivity']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('natureOfActivity').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'NatureOfActivity')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'NatureOfActivity',
                                      optDesc: '',
                                      optvalue: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _occupationTypeKey,
                        controlName: 'occupationType',
                        label: 'Occupation Type',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'OccupationType')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['occupationType']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('occupationType').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'OccupationType')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'OccupationType',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _agriculturistTypeKey,
                        controlName: 'agriculturistType',
                        label: 'Agriculturist Type',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'AgricultType')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['agriculturistType']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('agriculturistType').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'AgricultType')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'AgricultType',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _farmerCategoryKey,
                        controlName: 'farmerCategory',
                        label: 'Farmer Category',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'FarmerCategory')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['farmerCategory']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('farmerCategory').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'FarmerCategory')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'FarmerCategory',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _farmerTypeKey,
                        controlName: 'farmerType',
                        label: 'Farmer Type',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'FarmerType')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['farmerType']?.updateValue(
                            val.optvalue,
                          );
                        },
                        selItem: () {
                          final value = form.control('farmerType').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'FarmerType')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'FarmerType',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _religionKey,
                        controlName: 'religion',
                        label: 'Religion',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Religion')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['religion']?.updateValue(val.optvalue);
                        },
                        selItem: () {
                          final value = form.control('religion').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'Religion')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'Religion',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _casteKey,
                        controlName: 'caste',
                        label: 'Caste',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Caste')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['caste']?.updateValue(val.optvalue);
                        },

                        selItem: () {
                          final value = form.control('caste').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'Caste')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'Caste',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableDropdown<Lov>(
                        fieldKey: _genderKey,
                        controlName: 'gender',
                        label: 'Gender',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'Gender')
                                .toList(),
                        onChangeListener: (Lov val) {
                          form.controls['gender']?.updateValue(val.optvalue);
                        },
                        selItem: () {
                          final value = form.control('gender').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.lovList!
                              .where((v) => v.Header == 'Gender')
                              .firstWhere(
                                (lov) => lov.optvalue == value,
                                orElse:
                                    () => Lov(
                                      Header: 'Gender',
                                      optvalue: '',
                                      optDesc: '',
                                      optCode: '',
                                    ),
                              );
                        },
                      ),
                      SearchableMultiSelectDropdown<Lov>(
                        fieldKey: _subActivityKey,
                        controlName: 'subActivity',
                        label: 'Sub Activity',
                        items:
                            state.lovList!
                                .where((v) => v.Header == 'SubActivity')
                                .toList(),
                        selItems: () {
                          final currentValues =
                              form.control('subActivity').value;
                          if (currentValues == null || currentValues.isEmpty) {
                            return <Lov>[];
                          }
                          return state.lovList!
                              .where(
                                (v) =>
                                    v.Header == 'SubActivity' &&
                                    currentValues.contains(v.optvalue),
                              )
                              .toList();
                        },
                        onChangeListener: (List<Lov>? selectedItems) {
                          final selectedValues =
                              selectedItems?.map((e) => e.optvalue).toList() ??
                              [];
                          String subactivities = selectedValues.join(',');
                          form.controls['subActivity']?.updateValue(
                            subactivities,
                          );
                        },
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
                            print("personal Details value ${form.value}");

                            if (form.valid) {
                              PersonalData personalData = PersonalData.fromMap(
                                form.value,
                              );
                              PersonalData personalDataFormatted = personalData
                                  .copyWith(
                                    dob: getDateFormatedByProvided(
                                      personalData.dob,
                                      from: AppConstants.Format_dd_MM_yyyy,
                                      to: AppConstants.Format_yyyy_MM_dd,
                                    ),
                                  );

                              context.read<PersonalDetailsBloc>().add(
                                PersonalDetailsSaveEvent(
                                  personalData: personalDataFormatted,
                                ),
                              );
                            } else {
                              form.markAllAsTouched();
                              scrollToErrorField();
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
