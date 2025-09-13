import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/presentation/bloc/cropyieldpage_bloc.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';

class CropDetailsPage extends StatelessWidget {
  final String title;
  final String proposalnumber;
  final form = AppForms.buildCropDetailsForm();

  final TextEditingController irrigatedController = TextEditingController();
  final TextEditingController rainfedController = TextEditingController();
  final ValueNotifier<int> totalNotifier = ValueNotifier<int>(0);

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  final ValueNotifier<bool> formEdit = ValueNotifier<bool>(false);

  CropDetailsPage({
    super.key,
    required this.title,
    required this.proposalnumber,
  }) {
    irrigatedController.addListener(_updateTotal);
    rainfedController.addListener(_updateTotal);
  }

  void _updateTotal() {
    final irrigated = int.tryParse(irrigatedController.text) ?? 0;
    final rainfed = int.tryParse(rainfedController.text) ?? 0;
    totalNotifier.value = irrigated + rainfed;
  }

  bool isFormCompletelyEmpty(FormGroup form) {
    return form.rawValue.values.every((value) {
      return value == null || value.toString().trim().isEmpty;
    });
  }

  backHandler(context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Unsaved Changes'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),

              TextButton(
                onPressed: () {
                  context.goNamed('home');
                },
                child: Text('Yes'),
              ),
            ],
          ),
    );
  }

  void handleSave(BuildContext context, CropyieldpageState state) {
    if (irrigatedController.text.isNotEmpty &&
        rainfedController.text.isNotEmpty) {
      if (form.valid) {
        var scaleOfFinance = removeSpecialCharacters(
          form.control('lasScaloffin').value,
        );
        var reqScaleOfFinance = removeSpecialCharacters(
          form.control('lasReqScaloffin').value,
        );
        var prePerAcre = removeSpecialCharacters(
          form.control('lasPrePerAcre').value,
        );
        var premiumCollecte = removeSpecialCharacters(
          form.control('lasPreToCollect').value,
        );

        form.control('lasScaloffin').updateValue(scaleOfFinance);
        form.control('lasReqScaloffin').updateValue(reqScaleOfFinance);
        form.control('lasPrePerAcre').updateValue(prePerAcre);
        form.control('lasPreToCollect').updateValue(premiumCollecte);

        print("handleSave =>  ${form.value}");

        final cropFormData = CropDetailsModal.fromForm(form.rawValue);
        context.read<CropyieldpageBloc>().add(
          CropFormSaveEvent(cropData: cropFormData),
        );
      } else {
        form.markAllAsTouched();
      }
    } else {
      showSnack(context, message: 'Please Enter Irrigated and Rainfed fields');
    }
  }

  void handleSubmit(BuildContext context) async {
    final irrigated = int.tryParse(irrigatedController.text) ?? 0;
    final rainfed = int.tryParse(rainfedController.text) ?? 0;
    UserDetails? userDetails = await loadUser();

    context.read<CropyieldpageBloc>().add(
      CropDetailsSubmitEvent(
        proposalNumber: proposalnumber,
        userid: userDetails!.LPuserID,
        irrigated: irrigated,
        rainfed: rainfed,
        total: totalNotifier.value,
      ),
    );
  }

  void handleReset(BuildContext context, CropyieldpageState state) {
    context.read<CropyieldpageBloc>().add(CropDetailsResetEvent());
  }

  void handleUpdate(BuildContext context, CropyieldpageState state) {
    if (form.valid) {
      var scaleOfFinance = removeSpecialCharacters(
        form.control('lasScaloffin').value,
      );
      var reqScaleOfFinance = removeSpecialCharacters(
        form.control('lasReqScaloffin').value,
      );
      var prePerAcre = removeSpecialCharacters(
        form.control('lasPrePerAcre').value,
      );
      var premiumCollecte = removeSpecialCharacters(
        form.control('lasPreToCollect').value,
      );

      form.control('lasScaloffin').updateValue(scaleOfFinance);
      form.control('lasReqScaloffin').updateValue(reqScaleOfFinance);
      form.control('lasPrePerAcre').updateValue(prePerAcre);
      form.control('lasPreToCollect').updateValue(premiumCollecte);

      final cropFormData = CropDetailsModal.fromForm(form.rawValue);
      context.read<CropyieldpageBloc>().add(
        CropDetailsUpdateEvent(
          cropData: cropFormData,
          index: currentIndex.value,
        ),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void showBottomSheet(BuildContext context, CropyieldpageState state) {
    final entries = state.cropData ?? [];
    final lovlist = state.lovlist;
    // final showSubmitButton = state.showSubmit;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final showSubmitButton = state.showSubmit;
        print("showSubmitButton $showSubmitButton");
        return BlocProvider<CropyieldpageBloc>.value(
          value: context.read<CropyieldpageBloc>(),
          child: SafeArea(
            child: SizedBox(
              height: 400,
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
                                print("full item data $item");
                                final landname = lovlist!.firstWhere(
                                  (v) =>
                                      v.Header == 'TypeOfLand' &&
                                      v.optvalue == item.lasTypOfLand,
                                );
                                print("landname $landname");
                                final cropname = lovlist.firstWhere(
                                  (v) =>
                                      v.Header == 'NameOfTheCrop' &&
                                      v.optvalue == item.lasCrop,
                                );
                                print("cropname $cropname");
                                return Slidable(
                                  key: ValueKey(item.lasSeqno),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    extentRatio:
                                        0.25, // Controls width of action pane
                                    children: [
                                      SlidableAction(
                                        onPressed: (slidableContext) {
                                          try {
                                            if (item.lasSeqno != '') {
                                              slidableContext
                                                  .read<CropyieldpageBloc>()
                                                  .add(
                                                    CropDetailsDeleteEvent(
                                                      proposalNumber:
                                                          proposalnumber,
                                                      rowId:
                                                          item.lasSeqno ?? '',
                                                      index: index,
                                                    ),
                                                  );
                                            } else {
                                              slidableContext
                                                  .read<CropyieldpageBloc>()
                                                  .add(
                                                    CropDetailsRemoveEvent(
                                                      index: index,
                                                    ),
                                                  );
                                            }
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
                                    icon: Icons.agriculture,
                                    title: 'LandType - ${landname.optDesc}',
                                    details: [cropname.optDesc],
                                    detailsName: ["Name of the Crop"],
                                    onTap: () {
                                      currentIndex.value = index;
                                      Navigator.pop(context);
                                      context.read<CropyieldpageBloc>().add(
                                        CropDetailsSetEvent(cropData: item),
                                      );
                                    },
                                  ),
                                  // ListTile(
                                  //   leading: Icon(
                                  //     Icons.agriculture,
                                  //     size: 30,
                                  //     color: Colors.teal,
                                  //   ),
                                  //   title: Text('LandType - ${landname.optDesc}'),
                                  //   subtitle: Text(
                                  //     'Name of the Crop - ${cropname.optDesc}',
                                  //   ),
                                  //   trailing: const Icon(
                                  //     Icons.arrow_forward_ios,
                                  //     size: 16,
                                  //   ),
                                  //   onTap: () {
                                  //     currentIndex.value = index;
                                  //     Navigator.pop(context);
                                  //     context.read<CropyieldpageBloc>().add(
                                  //       CropDetailsSetEvent(cropData: item),
                                  //     );
                                  //   },
                                  // ),
                                );
                              },
                            ),
                  ),
                  // (entries.isNotEmpty &&
                  //         context.read<CropyieldpageBloc>().state.showSubmit)
                  //     ? Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(10),
                  //         child: ElevatedButton.icon(
                  //           onPressed: () {
                  //             handleSubmit(context);
                  //           },
                  //           icon: Icon(Icons.send, color: Colors.white),
                  //           label: RichText(
                  //             text: TextSpan(
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 16,
                  //               ),
                  //               children: [
                  //                 TextSpan(text: 'Push to '),
                  //                 TextSpan(
                  //                   text: 'LEND',
                  //                   style: TextStyle(color: Colors.white),
                  //                 ),
                  //                 TextSpan(
                  //                   text: 'perfect',
                  //                   style: TextStyle(
                  //                     fontStyle: FontStyle.italic,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           style: ButtonStyle(
                  //             minimumSize: MaterialStateProperty.all(
                  //               Size(double.infinity, 50),
                  //             ),
                  //             backgroundColor: MaterialStateProperty.all(
                  //               const Color.fromARGB(255, 75, 33, 83),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //           : SizedBox.shrink(),
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
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => {backHandler(context)},
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 02),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
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
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              proposalnumber ?? 'N/A',

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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Irrigated: ",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextField(
                          controller: irrigatedController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      const Text(
                        "Rainfed: ",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextField(
                          controller: rainfedController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ValueListenableBuilder<int>(
                        valueListenable: totalNotifier,
                        builder:
                            (context, value, _) => Text(
                              "Total: $value (Acres)",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
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
                  CropyieldpageBloc()
                    ..add(CropPageInitialEvent(proposalNumber: proposalnumber)),
          // lazy: true,
          child: BlocConsumer<CropyieldpageBloc, CropyieldpageState>(
            listener: (context, state) {
              if (state.status == SaveStatus.loading) {
                globalLoadingBloc.add(ShowLoading(message: 'Please wait...'));
              }

              if (state.status == SaveStatus.delete) {
                globalLoadingBloc.add(HideLoading());
                showSnack(
                  context,
                  message: 'Crop Details Deleted Successfully',
                );
              }

              if (state.status == SaveStatus.init) {
                globalLoadingBloc.add(HideLoading());
                if ((state.cropData != null && state.cropData!.isNotEmpty) &&
                    (state.landDetails != null &&
                        state.landDetails!.isNotEmpty)) {
                  irrigatedController.text =
                      state.landDetails!['lpAgriPcIrrigated'].toString();
                  rainfedController.text =
                      state.landDetails!['lpAgriPcRainfed'].toString();
                }
              } else if (state.status == SaveStatus.mastersucess) {
                form.reset();
              } else if (state.status == SaveStatus.reset) {
                form.reset();
              } else if (state.status == SaveStatus.success) {
                form.reset();
                context.pop();
                globalLoadingBloc.add(HideLoading());
                showSnack(
                  context,
                  message: 'Crop Details Submitted Successfully',
                );
              } else if (state.status == SaveStatus.failure &&
                  state.errorMessage != null) {
                globalLoadingBloc.add(HideLoading());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage.toString())),
                );
              }
            },
            builder: (context, state) {
              print("state.showSubmit-builer ${state.showSubmit}");
              if (state.status == SaveStatus.update &&
                  state.selectedCropData != null) {
                print(
                  "currently current selected cropdetails index is ${currentIndex.value}",
                );
                print("state.selectedCropData is => ${state.selectedCropData}");
                form.patchValue(state.selectedCropData!.toForm());
                if (state.selectedCropData!.notifiedCropFlag!) {
                  form.control('lasPrePerAcre').markAsEnabled();
                  form.control('lasPrePerAcre').setValidators([
                    Validators.required,
                  ]);

                  form.control('lasPreToCollect').markAsEnabled();
                  form.control('lasPreToCollect').setValidators([
                    Validators.required,
                  ]);
                } else {
                  form.control('lasPrePerAcre').updateValue(null);
                  form.control('lasPrePerAcre').markAsDisabled();
                  form.control('lasPrePerAcre').clearValidators();

                  form.control('lasPreToCollect').updateValue(null);
                  form.control('lasPreToCollect').markAsDisabled();
                  form.control('lasPreToCollect').clearValidators();
                }
                form.updateValueAndValidity();
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
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text('Proposal Number: '),
                                    //     SizedBox(width: 20,),
                                    //     Text(
                                    //       proposalnumber,
                                    //       style: TextStyle(
                                    //         color: Colors.teal
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // Dropdown(
                                    //   controlName: 'serveynumber',
                                    //   label: 'Survey Number',
                                    //   items: state.landData.lslLandSurveyNo
                                    // ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'lasSeason',
                                      label: 'Season',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'Season',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['lasSeason']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('lasSeason').value;
                                        return state.lovlist!
                                            .where((v) => v.Header == 'Season')
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'Season',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'lasCrop',
                                      label: 'Name of the Crop',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) =>
                                                    v.Header == 'NameOfTheCrop',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['lasCrop']?.updateValue(
                                          val.optvalue,
                                        );
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('lasCrop').value;
                                        return state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NameOfTheCrop',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'NameOfTheCrop',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'lasAreaofculti',
                                      label: 'Acres Cultivated ',
                                      mantatory: true,
                                    ),
                                    SearchableDropdown<Lov>(
                                      controlName: 'lasTypOfLand',
                                      label: 'Type of Land',
                                      items:
                                          state.lovlist!
                                              .where(
                                                (v) => v.Header == 'TypeOfLand',
                                              )
                                              .toList(),
                                      onChangeListener: (Lov val) {
                                        form.controls['lasTypOfLand']
                                            ?.updateValue(val.optvalue);
                                      },
                                      selItem: () {
                                        final value =
                                            form.control('lasTypOfLand').value;
                                        return state.lovlist!
                                            .where(
                                              (v) => v.Header == 'TypeOfLand',
                                            )
                                            .firstWhere(
                                              (lov) => lov.optvalue == value,
                                              orElse:
                                                  () => Lov(
                                                    Header: 'TypeOfLand',
                                                    optDesc: '',
                                                    optvalue: '',
                                                    optCode: '',
                                                  ),
                                            );
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'lasScaloffin',
                                      label:
                                          'Scale of Finance (including crop insurance)',
                                      mantatory: true,
                                      isRupeeFormat: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'lasReqScaloffin',
                                      label:
                                          'Requirement as per Scale of Finance',
                                      mantatory: true,
                                      isRupeeFormat: true,
                                    ),
                                    RadioButton(
                                      label: 'Notified Crop',
                                      controlName: 'notifiedCropFlag',
                                      optionOne: 'Yes',
                                      optionTwo: 'No',
                                      onChangeListener: (bool val) {
                                        print("Radiobutton onchangedata $val");
                                        if (val) {
                                          form
                                              .control('lasPrePerAcre')
                                              .updateValue('');
                                          form
                                              .control('lasPreToCollect')
                                              .updateValue('');
                                          form
                                              .control('lasPrePerAcre')
                                              .markAsEnabled();
                                          form
                                              .control('lasPreToCollect')
                                              .markAsEnabled();
                                          form
                                              .control('lasPrePerAcre')
                                              .setValidators([
                                                Validators.required,
                                              ]);
                                          form
                                              .control('lasPreToCollect')
                                              .setValidators([
                                                Validators.required,
                                              ]);
                                        } else {
                                          form
                                              .control('lasPrePerAcre')
                                              .updateValue('');
                                          form
                                              .control('lasPreToCollect')
                                              .updateValue('');
                                          form
                                              .control('lasPrePerAcre')
                                              .markAsDisabled();
                                          form
                                              .control('lasPreToCollect')
                                              .markAsDisabled();
                                          form
                                              .control('lasPrePerAcre')
                                              .clearValidators();
                                          form
                                              .control('lasPreToCollect')
                                              .clearValidators();
                                        }
                                      },
                                    ),
                                    IntegerTextField(
                                      controlName: 'lasPrePerAcre',
                                      label: 'Premium Per Acre',
                                      mantatory: true,
                                      isRupeeFormat: true,
                                    ),
                                    IntegerTextField(
                                      controlName: 'lasPreToCollect',
                                      label: 'Premium to be collected',
                                      mantatory: true,
                                      isRupeeFormat: true,
                                    ),
                                    Center(
                                      child:
                                          state.status == SaveStatus.update ||
                                                  state.status ==
                                                      SaveStatus.edit
                                              ? ElevatedButton.icon(
                                                onPressed:
                                                    () => handleUpdate(
                                                      context,
                                                      state,
                                                    ),
                                                icon: const Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  // backgroundColor: const Color.fromARGB(
                                                  //   212,
                                                  //   5,
                                                  //   8,
                                                  //   205,
                                                  // ),
                                                  backgroundColor: Colors.teal,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              )
                                              : ElevatedButton.icon(
                                                onPressed: () {
                                                  if (form.valid) {
                                                    handleSave(context, state);
                                                  } else {
                                                    form.markAllAsTouched();
                                                    SysmoAlert.warning(
                                                      message:
                                                          "Please fill all mandatory fields",
                                                      onButtonPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                    );
                                                  }
                                                },
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
                                                  backgroundColor: Colors.teal,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                            if (state.cropData != null)
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
                                    '${state.cropData?.length ?? 0}',
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
