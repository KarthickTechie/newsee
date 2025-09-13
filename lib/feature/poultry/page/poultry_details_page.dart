import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/poultry/widgets/poultry_cost_calculator.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_bloc.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_event.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_state.dart';
import 'package:newsee/feature/poultry/widgets/investment_form_widget.dart';
import 'package:newsee/feature/poultry/widgets/purchase_form_widget.dart';
import 'package:newsee/feature/poultry/widgets/maintenance_form_widget.dart';
import 'package:newsee/widgets/cupertino_expansion_tile.dart';
import 'package:newsee/widgets/expansion_controller.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

class PoultryDetailsPage extends StatelessWidget {
  final String leadId;
  const PoultryDetailsPage({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    final investmentForm = AppForms.buildInvesmentDetailsForm();
    final purchaseForm = AppForms.buildPurchaseDetailsForm();
    final maintenanceForm = AppForms.buildMaintenanceDetailsForm();
    // Expansion controller to manage opening/closing expansion tiles

    final controller = ExpansionController();
    // Attach cost calculator logic to update fields automatically

    PoultryCostCalculator.attachListener(
      investment: investmentForm,
      purchase: purchaseForm,
      maintenance: maintenanceForm,
    );

    return BlocProvider(
      create: (_) => PoultryBloc()..add(LoadPoultryDetails(leadId: leadId)),
      child: BlocBuilder<PoultryBloc, PoultryState>(
        builder: (context, state) {
          final bloc = context.read<PoultryBloc>();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Poultry Details"),
              backgroundColor: Colors.teal,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Investment Form
                  ReactiveForm(
                    formGroup: investmentForm,
                    child: CupertinoExpansionTile(
                      index: 0,
                      icon: Icons.agriculture,
                      controller: controller,
                      title: "Investment/Development Activity",
                      subtitle:
                          "Add your Investment and Development Activity details here",
                      child: const InvestmentFormWidget(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Purchase Form
                  ReactiveForm(
                    formGroup: purchaseForm,
                    child: CupertinoExpansionTile(
                      index: 1,
                      icon: Icons.shopping_cart,
                      controller: controller,
                      title: "Purchase Applicable",
                      subtitle: "Add your Purchase details here",
                      child: const PurchaseFormWidget(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Maintenance Form
                  ReactiveForm(
                    formGroup: maintenanceForm,
                    child: CupertinoExpansionTile(
                      index: 2,
                      icon: Icons.build,
                      controller: controller,
                      title: "Maintenance Applicable",
                      subtitle: "Add your Maintenance details here",
                      child: const MaintananceFormWidget(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  //  Save All Forms Button
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 2, 59, 105),
                      ),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      if (investmentForm.valid &&
                          purchaseForm.valid &&
                          maintenanceForm.valid) {
                        final details = {
                          "investment": investmentForm.value,
                          "purchase": purchaseForm.value,
                          "maintenance": maintenanceForm.value,
                        };
                        //  BLoC for saving

                        bloc.add(
                          AddPoultryDetails(details: details, leadId: leadId),
                        );
                        // Reset forms after save

                        investmentForm.reset();
                        purchaseForm.reset();
                        maintenanceForm.reset();

                        // Success alert
                        showDialog(
                          context: context,
                          builder:
                              (_) => SysmoAlert.success(
                                message: 'All forms saved successfully!',
                                onButtonPressed: () => context.pop(),
                              ),
                        );
                      } else {
                        // Show warning if validation fails

                        showDialog(
                          context: context,
                          builder:
                              (_) => SysmoAlert.warning(
                                message:
                                    "Please fill all forms before adding details",
                                onButtonPressed: () {
                                  context.pop();
                                  investmentForm.markAllAsTouched();
                                  purchaseForm.markAllAsTouched();
                                  maintenanceForm.markAllAsTouched();
                                },
                              ),
                        );
                      }
                    },
                    child: const Text("Add"),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Floating Action Button with Badge
            floatingActionButton: Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove_red_eye, color: Colors.teal),
                  onPressed: () {
                    if (state.addedDetails.isNotEmpty) {
                      // Show bottom sheet with saved records
                      
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder:
                            (bottomContext) => BlocProvider.value(
                              value: bloc,
                              child: DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.7,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                builder:
                                    (_, controller) => Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const Text(
                                            "Poultry Details",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Expanded(
                                            child: BlocBuilder<
                                              PoultryBloc,
                                              PoultryState
                                            >(
                                              builder: (_, modalState) {
                                                return ListView.builder(
                                                  controller: controller,
                                                  itemCount:
                                                      modalState
                                                          .addedDetails
                                                          .length,
                                                  itemBuilder: (_, index) {
                                                    final detail =
                                                        modalState
                                                            .addedDetails[index];
                                                    final investment =
                                                        detail["investment"] ??
                                                        {};
                                                    final purchase =
                                                        detail["purchase"] ??
                                                        {};
                                                    final maintenance =
                                                        detail["maintenance"] ??
                                                        {};

                                                    return GestureDetector(
                                                      onTap: () {
                                                        investmentForm
                                                            .patchValue(
                                                              investment,
                                                            );
                                                        purchaseForm.patchValue(
                                                          purchase,
                                                        );
                                                        maintenanceForm
                                                            .patchValue(
                                                              maintenance,
                                                            );
                                                        Navigator.pop(
                                                          bottomContext,
                                                        );
                                                      },
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                              bottom: 12,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                              16,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors
                                                                      .black12,
                                                              blurRadius: 8,
                                                              offset: Offset(
                                                                0,
                                                                4,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "Poultry Detail",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  onPressed: () {
                                                                    showDialog(
                                                                      context:
                                                                          bottomContext,
                                                                      builder:
                                                                          (
                                                                            _,
                                                                          ) => SysmoAlert.warning(
                                                                            message:
                                                                                "Are you sure you want to delete this record?",
                                                                            onButtonPressed: () {
                                                                              Navigator.pop(
                                                                                bottomContext,
                                                                              );
                                                                              bloc.add(
                                                                                RemovePoultryDetails(
                                                                                  index:
                                                                                      index,
                                                                                  leadId:
                                                                                      leadId,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            buildTripleRow(
                                                              "Investment",
                                                              "Cost XY",
                                                              investment["costXY"]
                                                                      ?.toString() ??
                                                                  "-",
                                                            ),
                                                            buildTripleRow(
                                                              "Purchase",
                                                              "Cost AB",
                                                              purchase["costAB"]
                                                                      ?.toString() ??
                                                                  "-",
                                                            ),
                                                            buildTripleRow(
                                                              "Maintenance",
                                                              "Cost DE",
                                                              maintenance["costDE"]
                                                                      ?.toString() ??
                                                                  "-",
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                      );
                    }
                  },
                ),
                if (state.addedDetails.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        state.addedDetails.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildTripleRow(String title, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
