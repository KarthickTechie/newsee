import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PresentAddress extends StatelessWidget {
  final String title;
  final BuildContext parentContext;
  PresentAddress({required this.title, required this.parentContext, super.key});

  final form = AppForms.PRESENT_ADDRESS_FORM;

  void showSnack(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void goToNextTab(BuildContext context) {
    showSnack(context, message: 'Present Address Details Saved Successfully');;
    final tabController = DefaultTabController.of(parentContext);
    if (tabController.index < tabController.length - 1) {
      tabController.animateTo(tabController.index + 1);
    }
  }

  void mapPermanentAddress(val) {
    try {
      form.control('address1').updateValue(val.address1!);
      form.control('address2').updateValue(val.address2!);
      form.control('address3').updateValue(val.address3!);
      form.control('pincode').updateValue(val.pincode!);
    } catch(error) {
      print('address.dart - mapCifResponse => $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Padding(
      //     padding: const EdgeInsets.only(top: 12.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(top: 10,left: 5),
      //           // child: Text("Present Address"),
      //         ),
            
      //       ],
      //     ),
      //   ),
      // ),
      body: BlocConsumer<AddressDetailsBloc, AddressDetailsState>(
        listener: (context, state) {
          // print(
          //   'PresentAddress detail::BlocConsumer:listen => ${state.lovList} ${state.addressData} ${state.status?.name}',
          // );
          if (state.status == SaveStatus.success && state.presentAddrData != null && state.addressData != null) {
            goToNextTab(context);
          }
          if (state.status == SaveStatus.mastersucess ||
              state.status == SaveStatus.failure) {
            globalLoadingBloc.add(HideLoading());
          }
        },
        builder: (context, state) {
          if (state.status == null) {
            form.reset();
          }
          if (state.presentCityMaster != null && state.presentCityMaster!.isEmpty) {
            form.controls['city']?.updateValue(null);
          }
          if (state.status == SaveStatus.copy && state.presentAddrData != null) {
            mapPermanentAddress(state.addressData);
          } else if(state.status == SaveStatus.presenttreset) {
            print("form try to reset here");
            form.reset();
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 05),
                          child: Row(
                            
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ReactiveCheckbox(
                                  formControlName: 'sameAsPermanent',
                                  onChanged: (control) {
                                    print("check box change value is => ${control.value}");
                                    context.read<AddressDetailsBloc>().add(SameAsPermanentInPresentEvent(sameAspresent: control.value));
                                  },
                                ),
                              ),  
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text('Present Address same as Permanent Address',style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        ),
                        
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
                            if (state.status == SaveStatus.presenttreset) {
                              form.controls['addressType']
                                  ?.updateValue(null);
                              return null;
                            }
                            else if (state.presentAddrData != null) {
                              Lov? lov = state.lovList?.firstWhere(
                                (lov) =>
                                    lov.Header == 'AddressType' &&
                                    lov.optvalue ==
                                        state.presentAddrData?.addressType,
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
                              OnPresentStateCityChangeEvent(stateCode: val.code),
                            );
                          },
                          selItem: () {
                            if (state.status == SaveStatus.copy && state.presentAddrData != null) {
                              var statename = state.presentAddrData?.state;
                              print("statename is $statename");
                              GeographyMaster? statedata = state.stateCityMaster?.firstWhere(
                                (lov) =>
                                    lov.code == statename
                              );
                              print("personalAddress-stateData => $statedata");
                              form.controls['state']?.updateValue(
                                statedata?.value,
                              );
                              return statedata;
                            } else if (state.status == SaveStatus.presenttreset){
                              form.controls['state']?.updateValue(
                                null
                              );
                              return null;
                            } else  {
                              return null;
                            }
                          },
                        ),
                        SearchableDropdown(
                          controlName: 'cityDistrict',
                          label: 'City',
                          items: state.presentCityMaster!,
                          onChangeListener: (GeographyMaster val) {
                            form.controls['cityDistrict']?.updateValue(
                              val.code,
                            );
                            globalLoadingBloc.add(
                              ShowLoading(message: "Fetching district..."),
                            );
                            context.read<AddressDetailsBloc>().add(
                              OnPresentStateCityChangeEvent(
                                stateCode:
                                    form.controls['state']?.value as String,
                                cityCode: val.code,
                              ),
                            );
                          },
                          selItem: () {
                            if (state.status == SaveStatus.copy && state.presentAddrData != null) {
                              String? cityname = state.presentAddrData?.cityDistrict;
                              print("cityname is $cityname");
                              GeographyMaster? citydata = state.presentCityMaster?.firstWhere(
                                (lov) =>
                                    lov.code == cityname
                              );
                              print("personalAddress-citydata => $citydata");
                              form.controls['cityDistrict']?.updateValue(
                                citydata?.value as String
                              );
                              return citydata;
                            } else if (state.status == SaveStatus.presenttreset){
                              form.controls['cityDistrict']?.updateValue(
                                null
                              );
                              return null;
                            } else  {
                              return null;
                            }
                          },
                        ),
                        SearchableDropdown(
                          controlName: 'area',
                          label: 'District',
                          items: state.presentDistrictMaster!,
                          onChangeListener: (GeographyMaster val) {
                            form.controls['area']?.updateValue(val.code);
                          },
                          selItem: () {
                            if (state.status == SaveStatus.copy && state.presentAddrData != null) {
                              GeographyMaster? statedata = state.presentDistrictMaster?.firstWhere(
                                (lov) =>
                                    lov.code == state.presentAddrData?.area
                              );
                              form.controls['area']?.updateValue(
                                statedata?.code,
                              );
                              return statedata;
                            } else if (state.status == SaveStatus.presenttreset){
                              form.controls['area']?.updateValue(
                                null
                              );
                              return null;
                            } else {
                              return null;
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
                              print(
                                "PresentAddress Details value ${form.value}",
                              );
                              if (form.valid) {
                                AddressData presentAddressData = AddressData.fromMap(
                                  form.value,
                                );
                                context.read<AddressDetailsBloc>().add(
                                  PresentAddressDetailsSaveEvent(
                                    presentaddressData: presentAddressData,
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
