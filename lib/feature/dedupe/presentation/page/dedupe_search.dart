import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/response_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DedupeSearch extends StatelessWidget {
  final FormGroup dedupeForm;
  final TabController tabController;
  DedupeSearch({super.key, required this.dedupeForm, required this.tabController});

  disposeResponse(context, state) {
    print("Welcome here for you $state");
    Navigator.of(context).pop();
    if (state.dedupeResponse?.remarksFlag) {
      dedupeForm.reset();
      Navigator.of(context).pop();
      if (tabController.index < tabController.length - 1) {
        tabController.animateTo(tabController.index + 1);
      }
    } else if (state.aadharvalidateResponse != null){
      dedupeForm.reset();
      Navigator.of(context).pop();
      if (tabController.index < tabController.length - 1) {
        tabController.animateTo(tabController.index + 1);
      }
    }
  }

  @override
  Widget build(context) {
    List<Map<String, dynamic>> dataList;
    return BlocConsumer<DedupeBloc, DedupeState>(
      listener: (context, state) => {
        print('Dedupe final Response => $state '),
        if (state.status == DedupeFetchStatus.success)
          {
            /* If aadharvalidateResponse is not null, show the response(name,dob,address etc) 
            in card */
            if (state.aadharvalidateResponse != null)
              {
                dataList = [
                  {
                    "icon": Icons.person,
                    "label": "Name",
                    "value": state.aadharvalidateResponse?.name as String,
                  },
                  {
                    "icon":
                        state.aadharvalidateResponse?.gender == "MALE"
                            ? Icons.male
                            : Icons.female,
                    "label": "Gender",
                    "value":
                        state.aadharvalidateResponse?.gender as String,
                  },
                  {
                    "icon": Icons.calendar_month,
                    "label": "DOB",
                    "value":
                        state.aadharvalidateResponse?.dateOfBirth
                            as String,
                  },
                  {
                    "icon": Icons.contact_phone,
                    "label": "Mobile",
                    "value": "",
                  },
                  {
                    "icon": Icons.home,
                    "label": "Address",
                    "value":
                        '${state.aadharvalidateResponse?.house} ${state.aadharvalidateResponse?.street} ${state.aadharvalidateResponse?.locality} ${state.aadharvalidateResponse?.vtcName} ${state.aadharvalidateResponse?.postOfficeName}',
                  },
                ],
              }
            else
              {
                dataList = [
                  {
                    "icon": Icons.currency_rupee,
                    "label": "CBS",
                    "value": "true",
                  },
                  {
                    "icon": Icons.assignment_add,
                    "label": "Remarks",
                    "value": state.dedupeResponse?.remarks as String,
                  },
                ],
              },
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // child: ResponseWidget(
                  //   heightSize:
                  //       state.aadharvalidateResponse != null
                  //           ? 0.50
                  //           : 0.32,
                  //   dataList: dataList,
                  //   onpressed: () => {disposeResponse(context, state)},
                  // ),
                  child: ResponseWidget(heightSize: state.aadharvalidateResponse != null ? 0.5 : 0.32, dataList: dataList, buttonshow: true, onpressed: () => disposeResponse(context, state))
                );
              },
            ),
          }
        else if (state.status == DedupeFetchStatus.failure)
          {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMsg!))),
          },
      },
      builder: (context, state) { 
        return ReactiveForm(
        formGroup: dedupeForm, 
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0,0,0),
                    child: Text("Dedupe Search", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Dropdown(
                        controlName: 'title',
                        label: 'Title',
                        items: ['Mr', 'Mrs', 'Miss', 'Others'],
                      ),
                      CustomTextField(
                        controlName: 'firstname',
                        label: 'First Name',
                        mantatory: true
                      ),
                      CustomTextField(
                        controlName: 'lastname', 
                        label: 'Last Name',
                        mantatory: true
                      ),
                      IntegerTextField(
                        controlName: 'mobilenumber', 
                        label: 'Mobile Number', 
                        mantatory: false,
                        maxlength: 10,
                        minlength: 10,
                      ),
                      CustomTextField(
                        controlName: 'pan', 
                        label: 'PAN Number', 
                        mantatory: false,
                        maxlength: 10,
                        autoCapitalize: true
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: IntegerTextField(
                                controlName: 'aadhaar',
                                label: 'Aadhaar Number',
                                mantatory: true,
                                maxlength: 12,
                                minlength: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (state.dedupeResponse?.remarksFlag == false)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    3,
                                    9,
                                    110,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  final AadharvalidateRequest
                                  aadharvalidateRequest = AadharvalidateRequest(
                                    aadhaarNumber:
                                        dedupeForm.control('aadhaar').value,
                                  );
                                  context.read<DedupeBloc>().add(
                                    ValiateAadharEvent(
                                      request: aadharvalidateRequest,
                                    ),
                                  );
                                  print(state.aadharvalidateResponse);
                                },
                                child: const Text("Validate"),
                              ),
                          ],
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 3, 9, 110),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          print("Click function passed ${dedupeForm.value}");
                          if (dedupeForm.valid) {
                            print("Click function passed go here, ${dedupeForm.valid}");
                            final DedupeRequest request = DedupeRequest().copyWith(
                              aadharCard: dedupeForm.control('aadhaar').value,
                              panCard: dedupeForm.control('pan').value,
                              mobileno: dedupeForm.control('mobilenumber').value
                            );
                            
                            context.read<DedupeBloc>().add(FetchDedupeEvent(request: request));
                          } else {
                            print("Click function passed go here, ${dedupeForm.valid}");
                            dedupeForm.markAllAsTouched();
                          }
                        }, 
                        child: state.status == DedupeFetchStatus.loading ? CircularProgressIndicator() : Text("Search")
                      ),
                    ]
                  )
                ]
              )
            ) 
          )
        );
      }
    );
  }
}