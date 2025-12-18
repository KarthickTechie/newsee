import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/pages/map_polygon.dart';
import 'package:newsee/widgets/google_maps_card.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandHoldingPage extends StatefulWidget {
  final String proposalNumber;
  final String applicantName;
  final String custId;
  final String title;
  final bool isCompleted;

  const LandHoldingPage({
    super.key,
    required this.title,
    required this.custId,
    required this.applicantName,
    required this.proposalNumber,
    required this.isCompleted,
  });

  @override
  State<LandHoldingPage> createState() => _LandHoldingPageState();
}

class _LandHoldingPageState extends State<LandHoldingPage> {
  final form = AppForms.buildLandHoldingDetailsForm();
  bool _dialogShown = false;
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  String status = 'Not Submit';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isCompleted == false && !_dialogShown) {
        _dialogShown = true;
        showFetchAlert(context);
      }
    });
  }

  void handleSubmit(BuildContext context, LandHoldingState state) async {
    if (form.valid) {
      // final globalLoadingBloc = context.read<GlobalLoadingBloc>();
      // globalLoadingBloc.add(ShowLoading(message: "Land Holding Details Submitting..."));
      List<Map<String, dynamic>> pointsList = [];

      final asyncPrefs = await SharedPreferences.getInstance();
      String? polygonData = asyncPrefs.getString('polygon_points');

      print('${form.value}, $polygonData');

      if (polygonData != null) {
        final points = json.decode(polygonData);

        print("finally get Points $points");

        pointsList =
            points
                .map<Map<String, dynamic>>(
                  (p) => {"longitude": p[0], "latitude": p[1]},
                )
                .toList();

        print("finally get pointsList $pointsList");

        context.read<LandHoldingBloc>().add(
          LandDetailsSaveEvent(
            landData: form.rawValue,
            polygonData: pointsList,
            custId: widget.custId,
            proposalNumber: widget.proposalNumber,
          ),
        );
      } else {
        showSnack(context, message: 'Please get location ploygons');
      }
    } else {
      form.markAllAsTouched();
    }
  }

  void showFetchAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("RBIH Landholding Details?"),
          content: Text("Do you want to fetch landholding Details from RBIH?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => RbIHLandCrop()),
                // );
                showRBIHBottomSheet(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void showRBIHBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Details',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _field1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Village code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _field2Controller,
                    decoration: const InputDecoration(
                      labelText: 'ulpin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  status == 'loading'
                      ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            50, // Fixed height
                          ),
                          maximumSize: Size(
                            MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            50, // Fixed height
                          ),
                        ),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              status =
                                  'loading'; // Update status in parent state
                            });
                            bottomSheetSetState(() {
                              // Ensure bottom sheet rebuilds to show loading
                            });
                            Future.delayed(
                              const Duration(seconds: 3),
                              () async {
                                // await loadRBIHData(); // Call _loadData
                                parentContext.read<LandHoldingBloc>().add(
                                  RBIHDetailsLoadEvent(
                                    rbihFormData: {
                                      'applicant': widget.applicantName,
                                    },
                                  ),
                                );
                                setState(() {
                                  status = 'loaded';
                                });
                                bottomSheetSetState(() {
                                  // Ensure bottom sheet rebuilds after loading
                                });
                                if (mounted) {
                                  Navigator.pop(
                                    context,
                                  ); // Close the bottom sheet
                                }
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width *
                                  0.8, // 80% of screen width
                              50, // Fixed height
                            ),
                            maximumSize: Size(
                              MediaQuery.of(context).size.width *
                                  0.8, // 80% of screen width
                              50, // Fixed height
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showGoogleMapsDailog(
    BuildContext context,
    double latitude,
    double longitude,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GoogleMapsCard(location: LatLng(latitude, longitude)),
    );
  }

  void showBottomSheet(BuildContext context, LandHoldingState state) {
    final entries = state.landData ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider<LandHoldingBloc>.value(
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
                      fontWeight: FontWeight.bold,
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
                                    extentRatio:
                                        0.25, // Controls width of action pane
                                    children: [
                                      SlidableAction(
                                        onPressed: (slidableContext) {
                                          try {
                                            slidableContext
                                                .read<LandHoldingBloc>()
                                                .add(
                                                  LandDetailsDeleteEvent(
                                                    landData: item,
                                                    index: index,
                                                    custId: widget.custId,
                                                  ),
                                                );
                                          } catch (error) {
                                            print(
                                              "deleteLandData-error $error",
                                            );
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
                                    title:
                                        item.lslLandApplicantName != null
                                            ? item.lslLandApplicantName
                                                .toString()
                                            : widget.applicantName,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(' Received  proposalNumber: ${widget.proposalNumber}');

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
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.proposalNumber ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
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
        body: BlocConsumer<LandHoldingBloc, LandHoldingState>(
          listener: (context, state) {
            if (state.status == SaveStatus.loading) {
              globalLoadingBloc.add(ShowLoading(message: 'Please wait...'));
            }

            if (state.status == SaveStatus.failure) {
              globalLoadingBloc.add(HideLoading());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage.toString())),
              );
            }

            if (state.status == SaveStatus.success) {
              globalLoadingBloc.add(HideLoading());
              form.reset();

              form.control('applicantName').updateValue(widget.applicantName);
              // form.control('sumOfTotalAcreage').markAsDisabled();
              showSuccessBottomSheet(
                context: context,
                headerTxt: ApiConstants.api_response_success,
                lead: "",
                message: "Landholding details successfully submitted",
                leftButtonLabel: 'Go To Crop Details',
                rightButtonLabel: 'Cancel',
                onPressedLeftButton: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                    context.pushNamed(
                      'cropdetails',
                      extra: {
                        'proposal': widget.proposalNumber,
                        'isCompleted': false,
                      },
                    );
                  }
                },
                onPressedRightButton: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }, // OnPressedRightButton,
              );
            }
            if (state.selectedLandData != null &&
                state.status == SaveStatus.update) {
              var selectedFormArrayData = state.selectedLandData!.mapForm();
              print("selectedFormArrayData $selectedFormArrayData");
              if (state.cityMaster!.isEmpty) {
                context.read<LandHoldingBloc>().add(
                  OnStateCityChangeEvent(
                    stateCode: selectedFormArrayData['state'],
                  ),
                );
              }
              if (selectedFormArrayData['applicantName'] == null) {
                selectedFormArrayData['applicantName'] = widget.applicantName;
              }
              form.patchValue(selectedFormArrayData);
            }
            if (state.status == SaveStatus.mastersucess ||
                state.status == SaveStatus.masterfailure) {
              if (state.status == SaveStatus.masterfailure) {
                showSnack(context, message: 'Failed to Fetch Masters...');
              }

              print('city list => ${state.cityMaster}');
              globalLoadingBloc.add(HideLoading());
            }
            if (state.status == SaveStatus.delete &&
                state.errorMessage != null) {
              globalLoadingBloc.add(HideLoading());
              form.reset();

              form.control('applicantName').updateValue(widget.applicantName);
              form.control('sumOfTotalAcreage').markAsDisabled();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage.toString())),
              );
            }
          },
          builder: (context, state) {
            if (state.status == SaveStatus.init) {
              form.control('applicantName').updateValue(widget.applicantName);
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
                                  // Dropdown(
                                  //   controlName: 'applicantName',
                                  //   label: 'Applicant Name / Guarantor',
                                  //   items: [applicantName],
                                  // ),
                                  CustomTextField(
                                    controlName: 'applicantName',
                                    label: 'Applicant Name / Guarantor',
                                    mantatory: true,
                                  ),
                                  SearchableDropdown(
                                    controlName: 'state',
                                    label: 'State',
                                    items: state.stateCityMaster!,
                                    onChangeListener: (GeographyMaster val) {
                                      form.controls['state']?.updateValue(
                                        val.code,
                                      );

                                      context.read<LandHoldingBloc>().add(
                                        OnStateCityChangeEvent(
                                          stateCode: val.code,
                                        ),
                                      );
                                    },
                                    selItem: () {
                                      final value = form.control('state').value;
                                      if (value == null ||
                                          value.toString().isEmpty) {
                                        return null;
                                      }
                                      // if (state.status == SaveStatus.update &&
                                      //     state
                                      //             .selectedLandData
                                      //             ?.lslLandState !=
                                      //         null) {
                                      if (state
                                              .selectedLandData
                                              ?.lslLandState !=
                                          null) {
                                        String? stateCode =
                                            state
                                                .selectedLandData
                                                ?.lslLandState;

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
                                          return <GeographyMaster>[];
                                        }
                                      } else if (state
                                          .stateCityMaster!
                                          .isEmpty) {
                                        form.controls['state']?.updateValue("");
                                        return <GeographyMaster>[];
                                      }
                                    },
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
                                    selItem: () {
                                      final value =
                                          form.control('district').value;
                                      if (value == null ||
                                          value.toString().isEmpty) {
                                        return null;
                                      }
                                      if (state
                                              .selectedLandData
                                              ?.lslLandState !=
                                          null) {
                                        String? cityCode =
                                            state
                                                .selectedLandData
                                                ?.lslLandDistrict;

                                        GeographyMaster? geographyMaster = state
                                            .cityMaster
                                            ?.firstWhere(
                                              (val) => val.code == cityCode,
                                              orElse:
                                                  () => GeographyMaster(
                                                    stateParentId: '0',
                                                    cityParentId: '0',
                                                    code: '0',
                                                    value: '',
                                                  ),
                                            );
                                        print(geographyMaster);
                                        if (geographyMaster != null) {
                                          form.controls['district']
                                              ?.updateValue(
                                                geographyMaster.code,
                                              );
                                          return geographyMaster;
                                        } else {
                                          return <GeographyMaster>[];
                                        }
                                      } else if (state
                                          .stateCityMaster!
                                          .isEmpty) {
                                        form.controls['district']?.updateValue(
                                          "",
                                        );
                                        return <GeographyMaster>[];
                                      }
                                    },
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

                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          controlName: 'locationOfFarm',
                                          label: 'Location of Farm',
                                          mantatory: false,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // OutlinedButton.icon(
                                      //   onPressed: () async {
                                      //     if (form
                                      //             .control('locationOfFarm')
                                      //             .value !=
                                      //         null) {
                                      //       final position =
                                      //           form
                                      //                   .control(
                                      //                     'locationOfFarm',
                                      //                   )
                                      //                   .value
                                      //               as String;
                                      //       if (position.contains(',')) {
                                      //         final parts = position.split(",");
                                      //         final latitude = double.tryParse(
                                      //           parts[0].trim(),
                                      //         );
                                      //         final longitude = double.tryParse(
                                      //           parts[1].trim(),
                                      //         );
                                      //         if (latitude != null &&
                                      //             longitude != null) {
                                      //           showGoogleMapsDailog(
                                      //             context,
                                      //             latitude,
                                      //             longitude,
                                      //           );
                                      //         }
                                      //       }
                                      //     } else {
                                      //       globalLoadingBloc.add(
                                      //         ShowLoading(
                                      //           message: 'Fetching location',
                                      //         ),
                                      //       );
                                      //       try {
                                      //         final curposition =
                                      //             await MediaService()
                                      //                 .getLocation(context);
                                      //         globalLoadingBloc.add(
                                      //           HideLoading(),
                                      //         );
                                      //         if (curposition.position !=
                                      //             null) {
                                      //           form
                                      //               .control('locationOfFarm')
                                      //               .updateValue(
                                      //                 '${curposition.position!.latitude},${curposition.position!.longitude}',
                                      //               );
                                      //           showGoogleMapsDailog(
                                      //             context,
                                      //             curposition
                                      //                 .position!
                                      //                 .latitude,
                                      //             curposition
                                      //                 .position!
                                      //                 .longitude,
                                      //           );
                                      //           double calculateDistance =
                                      //               Geolocator.distanceBetween(
                                      //                 12.9483,
                                      //                 80.2546,
                                      //                 curposition
                                      //                     .position!
                                      //                     .latitude,
                                      //                 curposition
                                      //                     .position!
                                      //                     .longitude,
                                      //               );
                                      //           print(calculateDistance);
                                      //           String value =
                                      //               (calculateDistance / 1000)
                                      //                   .round()
                                      //                   .toString();
                                      //           print(
                                      //             'calculateDistance----->$value',
                                      //           );
                                      //           form
                                      //               .control(
                                      //                 'distanceFromBranch',
                                      //               )
                                      //               .updateValue(value);
                                      //         } else {
                                      //           showDialog(
                                      //             context: context,
                                      //             builder:
                                      //                 (_) => SysmoAlert.warning(
                                      //                   message:
                                      //                       curposition.error
                                      //                           .toString(),
                                      //                   onButtonPressed: () {
                                      //                     context.pop();
                                      //                   },
                                      //                 ),
                                      //           );
                                      //         }
                                      //       } catch (error) {
                                      //         SysmoAlert.warning(
                                      //           message: error.toString(),
                                      //         );
                                      //       }
                                      //     }
                                      //   },
                                      //   icon: Icon(Icons.map), // Your icon here
                                      //   label: Text(
                                      //     "location",
                                      //   ), // Your text here
                                      //   style: OutlinedButton.styleFrom(
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: 16,
                                      //       vertical: 12,
                                      //     ),
                                      //     textStyle: TextStyle(fontSize: 16),
                                      //   ),
                                      // ),
                                      Ink(
                                        decoration: ShapeDecoration(
                                          color: Colors.lightBlue.withOpacity(
                                            0.3,
                                          ),
                                          shape: CircleBorder(),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            if (form
                                                    .control('locationOfFarm')
                                                    .value !=
                                                null) {
                                              final position =
                                                  form
                                                          .control(
                                                            'locationOfFarm',
                                                          )
                                                          .value
                                                      as String;
                                              if (position.contains(',')) {
                                                final parts = position.split(
                                                  ",",
                                                );
                                                final latitude =
                                                    double.tryParse(
                                                      parts[0].trim(),
                                                    );
                                                final longitude =
                                                    double.tryParse(
                                                      parts[1].trim(),
                                                    );
                                                if (latitude != null &&
                                                    longitude != null) {
                                                  showGoogleMapsDailog(
                                                    context,
                                                    latitude,
                                                    longitude,
                                                  );
                                                }
                                              }
                                            } else {
                                              globalLoadingBloc.add(
                                                ShowLoading(
                                                  message: 'Fetching location',
                                                ),
                                              );
                                              try {
                                                final curposition =
                                                    await MediaService()
                                                        .getLocation(context);
                                                globalLoadingBloc.add(
                                                  HideLoading(),
                                                );
                                                if (curposition.position !=
                                                    null) {
                                                  form
                                                      .control('locationOfFarm')
                                                      .updateValue(
                                                        '${curposition.position!.latitude},${curposition.position!.longitude}',
                                                      );

                                                  showGoogleMapsDailog(
                                                    context,
                                                    curposition
                                                        .position!
                                                        .latitude,
                                                    curposition
                                                        .position!
                                                        .longitude,
                                                  );
                                                  double calculateDistance =
                                                      Geolocator.distanceBetween(
                                                        12.9483,
                                                        80.2546,
                                                        curposition
                                                            .position!
                                                            .latitude,
                                                        curposition
                                                            .position!
                                                            .longitude,
                                                      );
                                                  print(
                                                    'calculateDistance, $calculateDistance',
                                                  );
                                                  String value =
                                                      (calculateDistance / 1000)
                                                          .round()
                                                          .toString();
                                                  print(
                                                    'calculateDistance----->$value',
                                                  );
                                                  value != null
                                                      ? form
                                                          .control(
                                                            'distanceFromBranch',
                                                          )
                                                          .updateValue(value)
                                                      : form
                                                          .control(
                                                            'distanceFromBranch',
                                                          )
                                                          .updateValue(0);
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (
                                                          _,
                                                        ) => SysmoAlert.warning(
                                                          message:
                                                              curposition.error
                                                                  .toString(),
                                                          onButtonPressed: () {
                                                            context.pop();
                                                          },
                                                        ),
                                                  );
                                                }
                                              } catch (error) {
                                                SysmoAlert.warning(
                                                  message: error.toString(),
                                                );
                                              }
                                            }
                                          },
                                          icon: Icon(Icons.map),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Ink(
                                        decoration: ShapeDecoration(
                                          color: Colors.lightBlue.withOpacity(
                                            0.3,
                                          ),
                                          shape: CircleBorder(),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MapPolygon(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.format_shapes_rounded,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: IntegerTextField(
                                          controlName: 'distanceFromBranch',
                                          label: 'Farm Distance (km)',
                                          mantatory: true,
                                          maxlength: 3,
                                        ),
                                      ),
                                    ],
                                  ),

                                  IntegerTextField(
                                    controlName: 'surveyNo',
                                    label: 'Survey No.',
                                    mantatory: true,
                                    maxlength: 10,
                                  ),

                                  IntegerTextField(
                                    controlName: 'firka',
                                    label:
                                        'Firka (as per Adangal/Chitta/Patta)',
                                    mantatory: true,
                                    maxlength: 10,
                                  ),
                                  // IntegerTextField(
                                  //   controlName: 'khasraNo',
                                  //   label: 'Khasra No',
                                  //   mantatory: true,
                                  //   maxlength: 10,
                                  // ),
                                  // IntegerTextField(
                                  //   controlName: 'uccCode',
                                  //   label: 'No of Land Owners',
                                  //   mantatory: true,
                                  //   maxlength: 2,
                                  // ),
                                  IntegerTextField(
                                    controlName: 'totalAcreage',
                                    label: 'Total Acreage (in Acres)',
                                    mantatory: true,
                                    maxlength: 6,
                                    minlength: 1,
                                    decimal: true,
                                  ),

                                  IntegerTextField(
                                    controlName: 'irrigatedLand',
                                    label: 'Total Irrigated Land (in Acres)',
                                    mantatory: true,
                                    maxlength: 6,
                                    minlength: 1,
                                    decimal: true,
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
                                      // final totAcre =
                                      //     form.control('totAcre').value;
                                      // form.controls['sumOfTotalAcreage']
                                      //     ?.updateValue(totAcre);
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
                                            (v) => v.Header == 'NatureOfRight',
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

                                  SearchableDropdown<Lov>(
                                    controlName: 'irrigationFacilities',
                                    label: 'Source of Irrigation',
                                    items:
                                        state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NatureOfIrrFac',
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
                                            (v) => v.Header == 'NatureOfIrrFac',
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
                                    label: 'Whether Land Agriculturally Active',
                                    controlName: 'landAgriActive',
                                    optionOne: 'Yes',
                                    optionTwo: 'No',
                                  ),

                                  // SearchableDropdown<Lov>(
                                  //   controlName: 'particulars',
                                  //   label: 'Particulars Of Land',
                                  //   items:
                                  //       state.lovlist!
                                  //           .where(
                                  //             (v) =>
                                  //                 v.Header == 'LandIrrigation',
                                  //           )
                                  //           .toList(),
                                  //   onChangeListener: (Lov val) {
                                  //     form.controls['particulars']?.updateValue(
                                  //       val.optvalue,
                                  //     );
                                  //   },
                                  //   selItem: () {
                                  //     final value =
                                  //         form.control('particulars').value;
                                  //     if (value == null ||
                                  //         value.toString().isEmpty) {
                                  //       return null;
                                  //     }
                                  //     return state.lovlist!
                                  //         .where(
                                  //           (v) => v.Header == 'LandIrrigation',
                                  //         )
                                  //         .firstWhere(
                                  //           (lov) => lov.optvalue == value,
                                  //           orElse:
                                  //               () => Lov(
                                  //                 Header: 'LandIrrigation',
                                  //                 optDesc: '',
                                  //                 optvalue: '',
                                  //                 optCode: '',
                                  //               ),
                                  //         );
                                  //   },
                                  // ),
                                  // SearchableDropdown<Lov>(
                                  //   controlName: 'farmercategory',
                                  //   label: 'Farmer Category',
                                  //   items:
                                  //       state.lovlist!
                                  //           .where(
                                  //             (v) => v.Header == 'FarmerType',
                                  //           )
                                  //           .toList(),
                                  //   onChangeListener: (Lov val) {
                                  //     form.controls['farmercategory']
                                  //         ?.updateValue(val.optvalue);
                                  //   },
                                  //   selItem: () {
                                  //     final value =
                                  //         form.control('farmercategory').value;
                                  //     if (value == null ||
                                  //         value.toString().isEmpty) {
                                  //       return null;
                                  //     }
                                  //     return state.lovlist!
                                  //         .where(
                                  //           (v) => v.Header == 'FarmerType',
                                  //         )
                                  //         .firstWhere(
                                  //           (lov) => lov.optvalue == value,
                                  //           orElse:
                                  //               () => Lov(
                                  //                 Header: 'FarmerType',
                                  //                 optDesc: '',
                                  //                 optvalue: '',
                                  //                 optCode: '',
                                  //               ),
                                  //         );
                                  //   },
                                  // ),

                                  // RadioButton(
                                  //   label: 'Mortgage Other Banks',
                                  //   controlName: 'otherbanks',
                                  //   optionOne: 'Yes',
                                  //   optionTwo: 'No',
                                  // ),

                                  // SearchableDropdown<Lov>(
                                  //   controlName: 'primaryoccupation',
                                  //   label: 'Primary Occupation',
                                  //   items:
                                  //       state.lovlist!
                                  //           .where(
                                  //             (v) => v.Header == 'AgricultType',
                                  //           )
                                  //           .toList(),
                                  //   onChangeListener: (Lov val) {
                                  //     form.controls['primaryoccupation']
                                  //         ?.updateValue(val.optvalue);
                                  //   },
                                  //   selItem: () {
                                  //     final value =
                                  //         form
                                  //             .control('primaryoccupation')
                                  //             .value;
                                  //     if (value == null ||
                                  //         value.toString().isEmpty) {
                                  //       return null;
                                  //     }
                                  //     return state.lovlist!
                                  //         .where(
                                  //           (v) => v.Header == 'AgricultType',
                                  //         )
                                  //         .firstWhere(
                                  //           (lov) => lov.optvalue == value,
                                  //           orElse:
                                  //               () => Lov(
                                  //                 Header: 'AgricultType',
                                  //                 optDesc: '',
                                  //                 optvalue: '',
                                  //                 optCode: '',
                                  //               ),
                                  //         );
                                  //   },
                                  // ),
                                  // IntegerTextField(
                                  //   controlName: 'sumOfTotalAcreage',
                                  //   label: 'Sum Of Total Acreage',
                                  //   mantatory: true,
                                  // ),
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
                                        borderRadius: BorderRadius.circular(8),
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
    );
  }
}
