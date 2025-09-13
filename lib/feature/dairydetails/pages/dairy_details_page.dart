import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/feature/dairydetails/widgets/Incomeand_expenses_form_widget.dart';
import 'package:newsee/feature/dairydetails/widgets/dairy_details_cost_calculator.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_bloc.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_event.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_state.dart';
import 'package:newsee/feature/dairydetails/widgets/dairy_eligibility_form_widget.dart';
import 'package:newsee/feature/dairydetails/widgets/livestockeligibility_form_widget.dart';
import 'package:newsee/widgets/cupertino_expansion_tile.dart';
import 'package:newsee/widgets/expansion_controller.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DairyDetailsPage extends StatelessWidget {
  final String leadId;

  DairyDetailsPage({super.key, required this.leadId});

  // Expansion controller to manage opening/closing expansion tiles
  final ExpansionController _expansionController = ExpansionController();

  @override
  Widget build(BuildContext context) {
    final liveStockEligibilityForm = AppForms.buildLiveStockEligibility();
    final dairyEligibilityForm = AppForms.buildDairyEligibility();
    final incomeandExpensesForm = AppForms.buildIncomeandExpenses();

    // Attach cost calculator logic to update fields automatically
    DairyCostCalculator.attachListener(
      liveStockForm: liveStockEligibilityForm,
      dairyForm: dairyEligibilityForm,
      incomeForm: incomeandExpensesForm,
    );

    return BlocProvider(
      create: (_) => DairyDetailsBloc()..add(LoadDetails(leadId: leadId)),
      child: BlocBuilder<DairyDetailsBloc, DairyDetailsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Dairy Details"),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // LiveStock Eligibility Form 
                  ReactiveForm(
                    formGroup: liveStockEligibilityForm,
                    child: CupertinoExpansionTile(
                      index: 0,
                      controller: _expansionController,
                      icon: Icons.agriculture,
                      title: "Live Stock Eligibility",
                      subtitle: "Add your Live Stock Eligibility details here",
                      child: const LiveStockEligibility(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  //  Dairy Eligibility Form 
                  ReactiveForm(
                    formGroup: dairyEligibilityForm,
                    child: CupertinoExpansionTile(
                      index: 1,
                      controller: _expansionController,
                      icon: Icons.shopping_cart,
                      title: "Dairy Eligibility",
                      subtitle: "Auto populated based on Live Stock data",
                      child: const DairyEligibility(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Income & Expenses Form
                  ReactiveForm(
                    formGroup: incomeandExpensesForm,
                    child: CupertinoExpansionTile(
                      index: 2,
                      controller: _expansionController,
                      icon: Icons.money,
                      title: "Income and Expenses",
                      subtitle: "Auto populated based on Live Stock data",
                      child: const IncomeandExpenses(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //  Save All Forms Button 
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.teal),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      // Validate all forms before saving
                      if (liveStockEligibilityForm.valid &&
                          dairyEligibilityForm.valid &&
                          incomeandExpensesForm.valid) {
                        // Collect all form values
                        final detail = {
                          "liveStock": liveStockEligibilityForm.value,
                          "dairy": dairyEligibilityForm.value,
                          "income": incomeandExpensesForm.value,
                        };

                        print('Opening DairyDetailsPage for leadId: $leadId');

                        //  BLoC for saving
                        context.read<DairyDetailsBloc>().add(
                              AddDetails(detail: detail, leadId: leadId),
                            );

                        // Reset forms after save
                        liveStockEligibilityForm.reset();
                        dairyEligibilityForm.reset();
                        incomeandExpensesForm.reset();

                        // Success alert
                        showDialog(
                          context: context,
                          builder: (_) => SysmoAlert.success(
                            message: 'All forms saved successfully!',
                            onButtonPressed: () => context.pop(),
                          ),
                        );
                      } else {
                        // Show warning if validation fails
                        showDialog(
                          context: context,
                          builder: (_) => SysmoAlert.warning(
                            message: 'Please fill all forms before proceeding',
                               onButtonPressed: () {
                                  context.pop();
                                  liveStockEligibilityForm.markAllAsTouched();
                                  dairyEligibilityForm.markAllAsTouched();
                                  incomeandExpensesForm.markAllAsTouched();
                                },
                            
                          ),
                        );
                      }
                    },
                    child: const Text("All"),
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
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    if (state.addedDetails.isNotEmpty) {
                      final parentContext = context;

                      // Show bottom sheet with saved records
                      showModalBottomSheet(
                        context: parentContext,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (bottomSheetContext) {
                          final bloc = parentContext.read<DairyDetailsBloc>();

                          return BlocProvider.value(
                            value: bloc,
                            child: DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.7,
                              minChildSize: 0.5,
                              maxChildSize: 0.95,
                              builder: (_, controller) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      // Bottom sheet drag indicator
                                      Container(
                                        width: 40,
                                        height: 4,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),

                                      // Title
                                      const Text(
                                        "Dairy Details",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // List of saved records
                                      Expanded(
                                        child: BlocBuilder<DairyDetailsBloc,
                                            DairyDetailsState>(
                                          builder: (context, modalState) {
                                            return ListView.builder(
                                              controller: controller,
                                              itemCount:
                                                  modalState.addedDetails.length,
                                              itemBuilder: (itemContext, index) {
                                                final detail = modalState
                                                    .addedDetails[index];
                                                final liveStock =
                                                    detail["liveStock"] ?? {};
                                                final dairy =
                                                    detail["dairy"] ?? {};
                                                final income =
                                                    detail["income"] ?? {};

                                                return GestureDetector(
                                                  onTap: () {
                                                    // Restore form values from saved record
                                                    liveStockEligibilityForm
                                                        .patchValue(liveStock);
                                                    dairyEligibilityForm
                                                        .patchValue(dairy);
                                                    incomeandExpensesForm
                                                        .patchValue(income);

                                                    Navigator.pop(
                                                        bottomSheetContext);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 12),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Row with title + delete button
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              "Dairy Details",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon:
                                                                  const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                // Confirm delete
                                                                showDialog(
                                                                  context:
                                                                      bottomSheetContext,
                                                                  builder: (_) =>
                                                                      SysmoAlert
                                                                          .warning(
                                                                    message:
                                                                        "Are you sure you want to delete this record?",
                                                                    onButtonPressed:
                                                                        () {
                                                                      bottomSheetContext
                                                                          .pop();
                                                                      parentContext.read<DairyDetailsBloc>().add(
                                                                          DeleteDetails(
                                                                              index:
                                                                                  index,
                                                                              leadId:
                                                                                  leadId));
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),

                                                        // Show key fields from record
                                                        buildTripleRow(
                                                          "Live Stock",
                                                          "Animal Type",
                                                          liveStock[
                                                                  "animalType"] ??
                                                              "-",
                                                        ),
                                                        buildTripleRow(
                                                          "Dairy Eligibility",
                                                          "Loan Amount",
                                                          dairy["loanAmountB"]
                                                                  ?.toString() ??
                                                              "-",
                                                        ),
                                                        buildTripleRow(
                                                          "Income & Expenses",
                                                          "Income Over Expenditure",
                                                          income["incomeOverExpenditure"]
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
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),

                // Badge counter for saved records
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

/// Utility widget to show a row with Title - Label - Value
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
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
