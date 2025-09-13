import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/dynamic_form/dynamic_form_widget.dart';
import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:newsee/feature/dynamic_form/presentation/dynamic_form_bloc.dart';
import 'package:newsee/feature/dynamic_form/presentation/dynamic_form_event.dart';
import 'package:newsee/feature/dynamic_form/presentation/dynamic_form_state.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DynamicForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formGroup = FormGroup({
      for (var field in formMapper)
        field.formName: FormControl<String>(validators: [Validators.required]),
    });

    return BlocProvider(
      create: (context) => DynamicFormBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dynamic Form"),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 2,
        ),
        body: BlocConsumer<DynamicFormBloc, DynamicFormState>(
          listener: (context, state) {
            if (state.status == DynamicFormstatus.success) {
              showSnack(context, message: 'Details Saved Successfully');
              formGroup.reset();
            } 
            else if (state.status == DynamicFormstatus.failure) {
              showSnack(context, message: 'Failed to Save  Details');
            }
          },
          builder: (context, state) {
            final isLoading = state.status == DynamicFormstatus.loading;
                        return ReactiveForm(
              formGroup: formGroup,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ...formMapper.map((field) {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [buildField(field, formGroup)],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          onPressed: isLoading ? null :() {
                            
                            if (formGroup.valid) {
                       final details = formGroup.value;
                     
                              context.read<DynamicFormBloc>().add(
                                AddDynamicFormDetails(details),
                              );
                              showDialog(
                                context: context,
                                builder:
                                    (_) => SysmoAlert.success(
                                      message: "Save Successfully",
                                      onButtonPressed: () {
                                        context.pop();
                                        formGroup.reset();
                                        int i;
                                        for( i = 0; i < formMapper.length; i++) {
                                          if (formMapper[i].formType == 'SearchableDropdown') {
                                            
                                          }
                                        }
                                      },
                                    ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => SysmoAlert.warning(
                                      message:
                                          "Please fill all forms before adding details",
                                      onButtonPressed: () {
                                        context.pop();
                                        formGroup.markAllAsTouched();
                                      },
                                    ),
                              );
                            }
                          },
                          icon: isLoading ? SizedBox(
                            width: 24,height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ):
                           const Icon(Icons.check, color: Colors.black),
                          label:
                           isLoading? SizedBox.shrink():
                          
                          
                          const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.black),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<DynamicFormBloc, DynamicFormState>(
          builder: (context, state) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove_red_eye, color: Colors.teal),
                  onPressed: () {
                    if (state.addDetails.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (bottomContext) {
                          return BlocProvider.value(
                            value: context.read<DynamicFormBloc>(),
                            child: BlocBuilder<
                              DynamicFormBloc,
                              DynamicFormState
                            >(
                              builder: (context, state) {
                                return DraggableScrollableSheet(
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
                                              "Dynamic Form Details",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: controller,
                                                itemCount:
                                                    state.addDetails.length,
                                                itemBuilder: (_, index) {
                                                  final detail =
                                                      state.addDetails[index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      formGroup.patchValue(
                                                        detail,
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
                                                                Colors.black12,
                                                            blurRadius: 8,
                                                            offset: Offset(
                                                              0,
                                                              4,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                buildRow(
                                                                  'Title',
                                                                  detail['title']
                                                                      .toString(),
                                                                ),
                                                                buildRow(
                                                                  'FirstName',
                                                                  detail['firstName']
                                                                      .toString(),
                                                                ),
                                                                buildRow(
                                                                  'PrimaryMobileNumber',
                                                                  detail['primaryMobileNumber']
                                                                      .toString(),
                                                                ),
                                                                buildRow(
                                                                  'Email',
                                                                  detail['email']
                                                                      .toString(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    bottomContext,
                                                                builder:
                                                                    (
                                                                      dialogContext,
                                                                    ) => SysmoAlert.warning(
                                                                      message:
                                                                          "Are you sure you want to delete this record?",
                                                                      onButtonPressed: () {
                                                                        Navigator.pop(
                                                                          dialogContext,
                                                                        );
                                                                        context
                                                                            .read<
                                                                              DynamicFormBloc
                                                                            >()
                                                                            .add(
                                                                              RemoveDynamicFormDetails(
                                                                                index,
                                                                              ),
                                                                            );
                                                                      },
                                                                    ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
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
                if (state.addDetails.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        state.addDetails.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget buildRow(String title, String value) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
      SizedBox(width: 50),
      Expanded(flex: 2, child: Text(value, style: TextStyle(fontSize: 14))),
    ],
  );
}
