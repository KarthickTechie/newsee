import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/custom_loading.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Address extends StatelessWidget {
  final String title;

  Address({required this.title, super.key});

  final form = FormGroup({
    'addressType': FormControl<String>(validators: [Validators.required]),
    'address1': FormControl<String>(validators: [Validators.required]),
    'address2': FormControl<String>(validators: [Validators.required]),
    'address3': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'cityDistrict': FormControl<String>(validators: [Validators.required]),
    'area': FormControl<String>(validators: [Validators.required]),
    'pincode': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });

  void goToNextTab(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => SysmoAlert.success(
            message: 'Address Details Saved Successfully',
            onButtonPressed: () {
              Navigator.of(context).pop();
              final tabController = DefaultTabController.of(context);
              if (tabController.index < tabController.length - 1) {
                tabController.animateTo(tabController.index + 1);
              }
            },
          ),
    );
  }

  mapAadharResponse(AadharvalidateResponse? aadharResponse) {
    try {
      String address =
          '${aadharResponse?.house} ${aadharResponse?.street} ${aadharResponse?.locality} ${aadharResponse?.vtcName} ${aadharResponse?.postOfficeName}';
      String addressOne = addressSplit(address);
      form.control('address1').updateValue(addressOne);
      String remainingAddress = address.substring(addressOne.length).trim();
      String addressTwo = addressSplit(remainingAddress);
      form.control('address2').updateValue(addressTwo);
    } catch (error) {
      print(error);
    }
  }

  mapCifResponse(CifResponse? cifResponse) {
    try {
      form.control('address1').updateValue(cifResponse?.lleadaddress);
      form.control('address2').updateValue(cifResponse?.lleadaddresslane1);
      form.control('address3').updateValue(cifResponse?.lleadaddresslane2);
    } catch (error) {
      print(error);
    }
  }

  addressSplit(String str) {
    try {
      if (str.trim() == '') {
        return str;
      }
      str = str.trim();

      if (str.length <= 40) {
        return str;
      }

      var lastSpaceIndex = str.substring(0, 40).lastIndexOf(' ');

      if (lastSpaceIndex == -1) {
        return str.substring(0, 40);
      } else {
        return str.substring(0, lastSpaceIndex).trim();
      }
    } catch (error) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          title: Text("Address Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<AddressDetailsBloc, AddressDetailsState>(
          listener: (context, state) {
            print(
              'addressdetail::BlocConsumer:listen => ${state.lovList} ${state.addressData} ${state.status?.name}',
            );
            if (state.status == SaveStatus.success) {
              goToNextTab(context);
            }
            if (state.status == SaveStatus.mastersucess ||
                state.status == SaveStatus.masterfailure) {
              globalLoadingBloc.add(HideLoading());
            }
          },
          builder: (context, state) {
            print('adressState----------------->${state.addressData}');
            DedupeState? dedupeState;
            AddressDetailsState addressDetailsState =
                context.watch<AddressDetailsBloc>().state;
            if (state.status == SaveStatus.init) {
              dedupeState = context.watch<DedupeBloc>().state;
              if (dedupeState.cifResponse != null) {
                print(
                  'address cifresponse-------->$dedupeState["cifResponse"]',
                );
                mapCifResponse(dedupeState.cifResponse);
              } else if (dedupeState.aadharvalidateResponse != null) {
                print(dedupeState.aadharvalidateResponse);
                mapAadharResponse(dedupeState.aadharvalidateResponse);
              }
            }
            return Stack(
              alignment: Alignment.topLeft,
              children: [
                ReactiveForm(
                  formGroup: form,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SearchableDropdown(
                            controlName: 'addressType',
                            label: 'Address Type',
                            items:
                                state.lovList!
                                    .where((v) => v.Header == 'AddressType')
                                    .toList(),
                            onChangeListener:
                                (Lov val) => form.controls['addressType']
                                    ?.updateValue(val.optvalue),
                            selItem: () {
                              if (state.addressData != null) {
                                Lov? lov = state.lovList?.firstWhere(
                                  (lov) =>
                                      lov.Header == 'AddressType' &&
                                      lov.optvalue ==
                                          state.addressData?.addressType,
                                );
                                form.controls['addressType']?.updateValue(
                                  lov?.optvalue,
                                );
                                return lov;
                              } else {
                                return null;
                              }
                            },
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
                              context.read<AddressDetailsBloc>().add(
                                OnStateCityChangeEvent(stateCode: val.code),
                              );
                            },
                            selItem: () {
                              if (addressDetailsState.addressData != null) {
                                String? stateCode =
                                    addressDetailsState.addressData?.state!;

                                GeographyMaster? geographyMaster = state
                                    .stateCityMaster
                                    ?.firstWhere(
                                      (val) => val.code == stateCode,
                                    );
                                print(geographyMaster);
                                if (geographyMaster != null) {
                                  form.controls['state']?.updateValue(
                                    geographyMaster.code,
                                  );
                                  return geographyMaster;
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          SearchableDropdown(
                            controlName: 'cityDistrict',
                            label: 'City',
                            items: state.cityMaster!,
                            onChangeListener: (GeographyMaster val) {
                              form.controls['cityDistrict']?.updateValue(
                                val.code,
                              );
                              globalLoadingBloc.add(
                                ShowLoading(message: "Fetching district..."),
                              );
                              context.read<AddressDetailsBloc>().add(
                                OnStateCityChangeEvent(
                                  stateCode:
                                      form.controls['state']?.value as String,
                                  cityCode: val.code,
                                ),
                              );
                            },
                            selItem: () {
                              final value = form.control('cityDistrict').value;
                              if (value == null || value.toString().isEmpty) {
                                return null;
                              }
                              if (addressDetailsState.addressData != null) {
                                String? cityCode =
                                    addressDetailsState
                                        .addressData
                                        ?.cityDistrict!;

                                GeographyMaster? geographyMaster = state
                                    .cityMaster
                                    ?.firstWhere((val) => val.code == cityCode);
                                print(geographyMaster);
                                if (geographyMaster != null) {
                                  form.controls['cityDistrict']?.updateValue(
                                    geographyMaster.code,
                                  );
                                  return geographyMaster;
                                } else {
                                  return <GeographyMaster>[];
                                }
                              } else if (state.cityMaster!.isEmpty) {
                                form.controls['cityDistrict']?.updateValue("");
                                return <GeographyMaster>[];
                              }
                            },
                          ),
                          SearchableDropdown(
                            controlName: 'area',
                            label: 'District',
                            items: state.districtMaster!,
                            onChangeListener: (GeographyMaster val) {
                              form.controls['area']?.updateValue(val.code);
                            },
                            selItem: () {
                              final value = form.control('area').value;
                              if (value == null || value.toString().isEmpty) {
                                return null;
                              }
                              if (addressDetailsState.addressData != null) {
                                String? districtCode =
                                    addressDetailsState.addressData?.area!;

                                GeographyMaster? geographyMaster = state
                                    .districtMaster
                                    ?.firstWhere(
                                      (val) => val.code == districtCode,
                                    );
                                print(geographyMaster);
                                if (geographyMaster != null) {
                                  form.controls['area']?.updateValue(
                                    geographyMaster.code,
                                  );
                                  return geographyMaster;
                                } else {
                                  return <GeographyMaster>[];
                                }
                              } else if (state.cityMaster!.isEmpty ||
                                  state.districtMaster!.isEmpty) {
                                form.controls['area']?.updateValue("");
                                return <GeographyMaster>[];
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
                          SizedBox(height: 20),
                          // ElevatedButton(onPressed: () {}, child: Text("ADD")),
                          // SizedBox(height: 50),
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
                                print("Address Details value ${form.value}");
                                if (form.valid) {
                                  AddressData addressData = AddressData.fromMap(
                                    form.value,
                                  );
                                  context.read<AddressDetailsBloc>().add(
                                    AddressDetailsSaveEvent(
                                      addressData: addressData,
                                    ),
                                  );
                                } else {
                                  form.markAllAsTouched();
                                }
                              },
                              child: Text('Next'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (state.status == SaveStatus.loading)
                //   const Center(child: CustomLoading()),
              ],
            );
          },
        ),
      ),
    );
  }
}
