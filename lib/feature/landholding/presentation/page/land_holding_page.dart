import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';

class LandHoldingPage extends StatelessWidget {
  final String proposalNumber;
  final String applicantName;
  final String title;

  final form = AppForms.buildLandHoldingDetailsForm();

  LandHoldingPage({
    super.key,
    required this.title,
    required this.applicantName,
    required this.proposalNumber,
  });

  void handleSubmit(BuildContext context, LandHoldingState state) async {
    if (form.valid) {
      // final globalLoadingBloc = context.read<GlobalLoadingBloc>();
      // globalLoadingBloc.add(ShowLoading(message: "Land Holding Details Submitting..."));
      context.read<LandHoldingBloc>().add(
        LandDetailsSaveEvent(
          landData: form.value,
          proposalNumber: proposalNumber,
        ),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void showBottomSheet(BuildContext context, LandHoldingState state) {
    final entries = state.landData ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
            return  BlocProvider<LandHoldingBloc>.value(
              value: context.read<LandHoldingBloc>(),
              child: SafeArea(
              child: SizedBox(
                height: 500,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Note: Scroll left or right to delete land detail",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Expanded(
                      child:
                          entries.isEmpty
                              ? const Center(child: Text('No saved entries.'))
                              : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: entries.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (ctx, index) {
                                  final item = entries[index];
                                  return Slidable(
                                    key: ValueKey(item.lslLandRowid),
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      extentRatio: 0.25, // Controls width of action pane
                                      children: [
                                        SlidableAction(
                                          onPressed: (slidableContext) {
                                            try {
                                              // await Future.delayed(Duration(seconds: 1));
                                              // final globalLoadingBloc = slidableContext.read<GlobalLoadingBloc>();
                                              // globalLoadingBloc.add(ShowLoading(message: "please Wait..."));
                                              slidableContext.read<LandHoldingBloc>().add(
                                                LandDetailsDeleteEvent(landData: item, index: index),
                                              );
                                            } catch(error) {
                                              print("deleteLandData-error $error");
                                            }
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: OptionsSheet(
                                      icon: Icons.grass,
                                      title: item.lslLandApplicantName.toString(),
                                      details: [
                                        item.lslLandSurveyNo.toString(),
                                        item.lslLandVillage.toString(),
                                        item.lslLandTotAcre.toString(),
                                      ],
                                      detailsName: [
                                        "Survey No",
                                        "Village",
                                        "Total Acreage",
                                      ],
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<LandHoldingBloc>().add(
                                          LandDetailsLoadEvent(landData: item),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
                        ),
            );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    print(' Received  proposalNumber: $proposalNumber');

    final globalLoadingBloc = context.read<GlobalLoadingBloc>();

    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.15,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Proposal Id: ",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold) ,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            proposalNumber ?? 'N/A',
                            style: TextStyle(color: Colors.white, fontSize: 14,  fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create:
              (_) =>
                  LandHoldingBloc()
                    ..add(LandHoldingInitEvent(proposalNumber: proposalNumber)),
          child: BlocConsumer<LandHoldingBloc, LandHoldingState>(
            listener: (context, state) {
              if (state.status == SaveStatus.loading) {
                globalLoadingBloc.add(ShowLoading(message: 'Please wait...'));
              }
              if (state.status == SaveStatus.success) {
                globalLoadingBloc.add(HideLoading());
                form.reset();
              }
              if (state.selectedLandData != null &&
                  state.status == SaveStatus.update) {
                var selectedFormArrayData = state.selectedLandData!.mapForm();
                print("selectedFormArrayData $selectedFormArrayData");
                form.patchValue(selectedFormArrayData);
              }
              if (state.status == SaveStatus.mastersucess ||
                  state.status == SaveStatus.masterfailure) {
                if (state.status == SaveStatus.masterfailure) {
                   showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert.failure(
                      message: "Failed to Fetch Masters...",
                      onButtonPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              );
                }

                print('city list => ${state.cityMaster}');
                globalLoadingBloc.add(HideLoading());
              }
              if (state.status == SaveStatus.delete && state.errorMessage != null) {
                globalLoadingBloc.add(HideLoading());
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage.toString())));
              }
            },
            builder: (context, state) {
              if (state.status == SaveStatus.init) {
                form.control('applicantName').updateValue(applicantName);
              }
              return ReactiveForm(
                formGroup: form,
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Dropdown(
                                      controlName: 'applicantName',
                                      label: 'Applicant Name / Guarantor',
                                      items: [applicantName],
                                    ),
                                    SearchableDropdown(
                                      controlName: 'state',
                                      label: 'State',
                                      items: state.stateCityMaster!,
                                      onChangeListener: (GeographyMaster val) {
                                        form.controls['state']?.updateValue(
                                          val.code,
                                        );
                                        // globalLoadingBloc.add(
                                        //   ShowLoading(
                                        //     message: "Fetching city...",
                                        //   ),
                                        // );

                                        context.read<LandHoldingBloc>().add(
                                          OnStateCityChangeEvent(
                                            stateCode: val.code,
                                          ),
                                        );
                                      },
                                      selItem: () => null,
                                    ),
                                    SearchableDropdown(
                                      controlName: 'district',
                                      label: 'District',
                                      items: state.cityMaster!,
                                      onChangeListener: (GeographyMaster val) {
                                        form.controls['district']?.updateValue(
                                          val.code,
                                        );
                                      },
                                      selItem: () => null,
                                    ),
                                    CustomTextField(
                                      controlName: 'village',
                                      label: 'Village',
                                      mantatory: true,
                                    ),
                                    CustomTextField(
                                      controlName: 'taluk',
                                      label: 'Taluk',
                                      mantatory: true,
                                    ),
                                    CustomTextField(
                                      controlName: 'locationOfFarm',
                                      label: 'Location of Farm',
                                      mantatory: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'distanceFromBranch',
                                      label: 'Distance from Branch (in Kms)',
                                      mantatory: true,
                                      minlength: 1,
                                      maxlength: 3,
                                    ),

                                    IntegerTextField(
                                      controlName: 'surveyNo',
                                      label: 'Survey No.',
                                      mantatory: true,
                                    ),

                                    IntegerTextField(
                                      controlName: 'firka',
                                      label:
                                          'Firka (as per Adangal/Chitta/Patta)',
                                      mantatory: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'totalAcreage',
                                      label: 'Total Acreage (in Acres)',
                                      mantatory: true,
                                      maxlength: 2,
                                      minlength: 1,
                                    ),
                                    IntegerTextField(
                                      controlName: 'irrigatedLand',
                                      label: 'Total Irrigated Land (in Acres)',
                                      mantatory: true,
                                      maxlength: 2,
                                      minlength: 1,
                                    ),
                                    RadioButton(
                                      label: 'Lands situated in compact blocks',
                                      controlName: 'compactBlocks',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),
                                    RadioButton(
                                      label:
                                          'Do the particulars of the holdings given in the application tally with the particulars given in village officers certificate',
                                      controlName: 'villageOfficerCertified',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),
                                    RadioButton(
                                      label: 'Land owned by the Applicant',
                                      controlName: 'landOwnedByApplicant',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),
                                    // Dropdown(
                                    //   controlName: '',
                                    //   label: 'Nature of Right',
                                    //   items: [
                                    //     '--Select--',
                                    //     'Owned',natureOfRight
                                    //     'Leaseholder',
                                    //     'Ancestral',
                                    //   ],
                                    // ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'natureOfRight',
                                      label: 'Nature of Right',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header == 'NatureOfRight',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['natureOfRight']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('natureOfRight').value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NatureOfRight',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'NatureOfRight',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    // Dropdown(
                                    //   controlName: 'irrigationFacilities',
                                    //   label: 'Nature of Irrigation facilities',
                                    //   items: [
                                    //     '--Select--',
                                    //     'Canal',
                                    //     'Well',
                                    //     'Tube Wells',
                                    //   ],
                                    // ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'irrigationFacilities',
                                      label: 'Nature of Irrigation facilities',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header ==
                                                    'NatureOfIrrFac',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['irrigationFacilities']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form
                                                .control('irrigationFacilities')
                                                .value;
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return null;
                                        }
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NatureOfIrrFac',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'NatureOfIrrFac',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    RadioButton(
                                      label:
                                          'Are the Holdings in any way affected by land ceiling enactments',
                                      controlName: 'affectedByCeiling',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),
                                    RadioButton(
                                      label:
                                          'Whether Land Agriculturally Active',
                                      controlName: 'landAgriActive',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                    ),
                                    ElevatedButton.icon(
                                      onPressed:
                                          () => handleSubmit(context, state),
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          212,
                                          5,
                                          8,
                                          205,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   bottom: 5,
                      //   left: 0,
                      //   right: 0,
                      //   child: Center(
                      //     child: ElevatedButton.icon(
                      //       onPressed: () => handleSubmit(context, state),
                      //       icon: const Icon(Icons.save, color: Colors.white),
                      //       label: const Text(
                      //         'Save',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: const Color.fromARGB(
                      //           212,
                      //           5,
                      //           8,
                      //           205,
                      //         ),
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 32,
                      //           vertical: 14,
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // FAB with badge on top
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            FloatingActionButton(
                              heroTag: 'view_button',
                              backgroundColor: Colors.white,
                              tooltip: 'View Saved Data',
                              onPressed: () => showBottomSheet(context, state),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                            if (state.landData != null)
                              Positioned(
                                top: -10,
                                right: -4,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${state.landData?.length ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
