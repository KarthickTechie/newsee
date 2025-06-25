import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/presentation/bloc/cropyieldpage_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/widgets/radio.dart';
import 'package:newsee/widgets/integer_text_field.dart';

class CropDetailsPage extends StatelessWidget {
  final String title;

  final form = AppForms.CROP_DETAILS_FORM;

  final TextEditingController irrigatedController = TextEditingController();
  final TextEditingController rainfedController = TextEditingController();
  final ValueNotifier<int> totalNotifier = ValueNotifier<int>(0);

  CropDetailsPage({super.key, required this.title}) {
    irrigatedController.addListener(_updateTotal);
    rainfedController.addListener(_updateTotal);
  }

  void _updateTotal() {
    final irrigated = int.tryParse(irrigatedController.text) ?? 0;
    final rainfed = int.tryParse(rainfedController.text) ?? 0;
    totalNotifier.value = irrigated + rainfed;
  }

  void handleSubmit(BuildContext context, CropyieldpageState state) {
    if (form.valid) {
      final cropFormData = CropDetailsModal.fromForm(form.value);
      context.read<CropyieldpageBloc>().add(
        CropFormSaveEvent(cropData: cropFormData),
      );
    } else {
      form.markAllAsTouched();
    }
  }

  void handleReset(BuildContext context, CropyieldpageState state) {
    context.read<CropyieldpageBloc>().add(CropDetailsResetEvent());
  }

  void showBottomSheet(BuildContext context, CropyieldpageState state) {
    print("CropyieldpageState-showBottomSheet $state");
    final entries = state.cropData ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SizedBox(
            height: 300,
            child:
                entries.isEmpty
                    ? const Center(child: Text('No saved entries.'))
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, index) {
                        final item = entries[index];
                        return ListTile(
                          title: Text('LandType - ${item.typeofland!}'),
                          subtitle: Text(
                            'Name of the Crop - ${item.nameOfCrop!}',
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            context.read<CropyieldpageBloc>().add(
                              CropDetailsSetEvent(cropData: item),
                            );
                          },
                        );
                      },
                    ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(decoration: BoxDecoration(color: Colors.teal)),
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
            // Text(
            //   'No of acres crops cultivated',
            //   style: TextStyle(
            //     fontSize: 16
            //   )
            // ),
            // SizedBox(height: 5),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Irrigated: ",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: TextField(
                      controller: irrigatedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Rainfed: ",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: TextField(
                      controller: rainfedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: totalNotifier,
                    builder:
                        (context, value, _) => Text(
                          "Total: $value",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => CropyieldpageBloc()..add(CropPageInitialEvent()),
        child: BlocConsumer<CropyieldpageBloc, CropyieldpageState>(
          listener: (context, state) {
            if (state.status == CropPageStatus.success) {
              print("CropyieldpageState ${state.cropData}");
              form.reset();
            } else if (state.status == CropPageStatus.reset) {
              print("CropyieldpageState ${state.cropData}");
              form.reset();
            }
          },
          builder: (context, state) {
            if (state.status == CropPageStatus.set &&
                state.selectedCropData != null) {
              form.patchValue(state.selectedCropData!.toMap());
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
                                  SearchableDropdown<Lov>(
                                    controlName: 'season',
                                    label: 'Season',
                                    items:
                                        state.lovlist!
                                            .where((v) => v.Header == 'Season')
                                            .toList(),
                                    onChangeListener: (Lov val) {
                                      form.controls['season']?.updateValue(
                                        val.optvalue,
                                      );
                                    },
                                    selItem: () {
                                      final value =
                                          form.control('season').value;
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
                                    controlName: 'nameOfCrop',
                                    label: 'Name of the Crop',
                                    items:
                                        state.lovlist!
                                            .where(
                                              (v) =>
                                                  v.Header == 'NameOfTheCrop',
                                            )
                                            .toList(),
                                    onChangeListener: (Lov val) {
                                      form.controls['nameOfCrop']?.updateValue(
                                        val.optvalue,
                                      );
                                    },
                                    selItem: () {
                                      final value =
                                          form.control('nameOfCrop').value;
                                      return state.lovlist!
                                          .where(
                                            (v) => v.Header == 'NameOfTheCrop',
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
                                    controlName: 'acrescultivated',
                                    label: 'Acres Cultivated',
                                    mantatory: true,
                                  ),
                                  SearchableDropdown<Lov>(
                                    controlName: 'typeofland',
                                    label: 'Type of Land',
                                    items:
                                        state.lovlist!
                                            .where(
                                              (v) => v.Header == 'TypeOfLand',
                                            )
                                            .toList(),
                                    onChangeListener: (Lov val) {
                                      form.controls['typeofland']?.updateValue(
                                        val.optvalue,
                                      );
                                    },
                                    selItem: () {
                                      final value =
                                          form.control('typeofland').value;
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
                                    controlName: 'scaleoffincance',
                                    label:
                                        'Scale of Finance (including crop insurance)',
                                    mantatory: true,
                                  ),
                                  IntegerTextField(
                                    controlName: 'reqasperscaleoffinace',
                                    label:
                                        'Requirement as per Scale of Finance',
                                    mantatory: true,
                                  ),
                                  RadioButton(
                                    label: 'Notified Crop',
                                    controlName: 'notifiedcrop',
                                    optionOne: 'Yes',
                                    optionTwo: 'No',
                                  ),
                                  IntegerTextField(
                                    controlName: 'premiumperacre',
                                    label: 'Premium Per Acre',
                                    mantatory: true,
                                  ),
                                  IntegerTextField(
                                    controlName: 'premiumcollected',
                                    label: 'Premium to be collected',
                                    mantatory: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child:
                            state.status == CropPageStatus.set
                                ? ElevatedButton.icon(
                                  onPressed: () => handleReset(context, state),
                                  icon: const Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Reset',
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
                                )
                                : ElevatedButton.icon(
                                  onPressed: () => handleSubmit(context, state),
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
                              Icons.remove_red_eye,
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
    );
  }
}
