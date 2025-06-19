import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PermanentAddress extends StatelessWidget {
  final String title;

  PermanentAddress({required this.title, super.key});
  
  final form = AppForms.PERMANENT_ADDRESS_FORM;

  void showSnack(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void goToNextTab(BuildContext context) {
    showSnack(context, message: 'Address Details Saved Successfully');
    final tabController = DefaultTabController.of(context);
    if (tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
    }
  }

  void mapCifResponse(CifResponse val, FormGroup form) {
    try {
      form.control('address1').updateValue(val.lleadaddress!);
      form.control('address2').updateValue(val.lleadaddresslane1!);
      form.control('address3').updateValue(val.lleadaddresslane2!);
      form.control('pincode').updateValue(val.lleadpinno!);
    } catch(error) {
      print('address.dart - mapCifResponse => $error');
    }
  }

  void mapAadhaarResponse(AadharvalidateResponse val, FormGroup form) {
    try {
      String fullAddress = '${val.house} ${val.street} ${val.locality} ${val.vtcName} ${val.postOfficeName}';
      print("fullAddress $fullAddress");
      print("fullAddresslength ${fullAddress.length}");
      String? lineOne = addressSplit(fullAddress);
      print("lineOne $lineOne");
      print("lineOne.length ${lineOne!.length}");
      form.control('address1').updateValue(lineOne);
      String? lineTwo = addressSplit(fullAddress.substring(lineOne.length));
      print("lineTwo $lineTwo");
      print("lineTwo.length ${lineTwo!.length}");
      form.control('address2').updateValue(lineTwo);
      int twolinelength = lineOne.length + lineTwo.length + 1;
      print("twolinelength $twolinelength");
      if (fullAddress.length > twolinelength) {
        String? lineThree = addressSplit(
          fullAddress.substring(lineOne.length + lineTwo.length),
        );
        print("lineThree $lineThree");
        form.control('address3').updateValue(lineThree);
      }
      form.control('pincode').updateValue(val.pincode);
    } catch(error) {
      print('address.dart - mapCifResponse => $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text("Permanent Address "),
      //   automaticallyImplyLeading: false,
      // ),
      body: BlocConsumer<AddressDetailsBloc, AddressDetailsState>(
        listener: (context, state) {
          print(
            'permanentAddress::BlocConsumer:listen => ${state.lovList} ${state.addressData} ${state.status?.name}',
          );
          if (state.status == SaveStatus.permanentsave && state.addressData != null) {
            goToNextTab(context);
          }
          if (state.status == SaveStatus.mastersucess ||
              state.status == SaveStatus.failure) {
            globalLoadingBloc.add(HideLoading());
          }
        },
        builder: (context, state) {
          DedupeState? dedupeState;
          if (state.status == null) {
            form.reset();
          }
          if (state.cityMaster != null && state.cityMaster!.isEmpty) {
            form.controls['city']?.updateValue(null);
          }
          if (state.status == SaveStatus.init) {
            dedupeState = context.watch<DedupeBloc>().state;
            if (dedupeState.cifResponse != null) {
              CifResponse cifResponse =  dedupeState.cifResponse!;
              mapCifResponse(cifResponse, form);
            } else if (dedupeState.aadharvalidateResponse != null) {
              AadharvalidateResponse aadhaarResponse = dedupeState.aadharvalidateResponse!;
              mapAadhaarResponse(aadhaarResponse, form);
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
                          selItem: () => null,
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
                          selItem: () => null,
                        ),
                        SearchableDropdown(
                          controlName: 'area',
                          label: 'District',
                          items: state.districtMaster!,
                          onChangeListener: (GeographyMaster val) {
                            form.controls['area']?.updateValue(val.code);
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
                              print(
                                "permanentAddress Details value ${form.value}",
                              );
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
    );
  }
}
