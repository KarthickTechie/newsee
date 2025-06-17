import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/widgets/custom_loading.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
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

  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    return Scaffold(
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
              state.status == SaveStatus.failure) {
            globalLoadingBloc.add(HideLoading());
          }
        },
        builder: (context, state) {
          if (state.cityMaster != null && state.cityMaster!.isEmpty) {
            form.controls['city']?.updateValue(null);
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
    );
  }
}
