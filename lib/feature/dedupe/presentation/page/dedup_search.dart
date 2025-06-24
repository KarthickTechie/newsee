// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
// import 'package:newsee/feature/dedupe/domain/model/deduperequest.dart';
// // import 'package:newsee/feature/dedupe/domain/repositoy/deduperepository.dart';
// import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
// import 'package:newsee/widgets/custom_text_field.dart';
// import 'package:newsee/widgets/drop_down.dart';
// import 'package:newsee/widgets/integer_text_field.dart';
// import 'package:newsee/widgets/response_widget.dart';
// // import 'package:newsee/widgets/response_widget.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:newsee/widgets/build_in_row.dart';

// class DedupeSearch extends StatelessWidget {
//   final FormGroup dedupeForm;
//   final TabController tabController;
//   DedupeSearch({
//     super.key,
//     required this.dedupeForm,
//     required this.tabController,
//   });

//   disposeResponse(context, state) {
//     print("Welcome here for you $state");
//     dedupeForm.reset();
//     Navigator.of(context).pop();
//     // if (state['dedupeResponse']['remarksFlag']) {
//     Navigator.of(context).pop();
//     if (tabController.index < tabController.length - 1) {
//       tabController.animateTo(tabController.index + 1);
//     }
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> dataList;
//     return BlocProvider(
//       create: (context) => DedupeBloc(),
//       child: BlocConsumer<DedupeBloc, DedupeState>(
//         listener:
//             (context, state) => {
//               if (state.status == DedupeFetchStatus.success)
//                 {
//                   /* If aadharvalidateResponse is not null, show the response(name,dob,address etc)
//                   in card */
//                   if (state.aadharvalidateResponse != null)
//                     {
//                       dataList = [
//                         {
//                           "icon": Icons.person,
//                           "label": "Name",
//                           "value": state.aadharvalidateResponse?.name as String,
//                         },
//                         {
//                           "icon":
//                               state.aadharvalidateResponse?.gender == "MALE"
//                                   ? Icons.male
//                                   : Icons.female,
//                           "label": "Gender",
//                           "value":
//                               state.aadharvalidateResponse?.gender as String,
//                         },
//                         {
//                           "icon": Icons.calendar_month,
//                           "label": "DOB",
//                           "value":
//                               state.aadharvalidateResponse?.dateOfBirth
//                                   as String,
//                         },
//                         {
//                           "icon": Icons.contact_phone,
//                           "label": "Mobile",
//                           "value": "",
//                         },
//                         {
//                           "icon": Icons.home,
//                           "label": "Address",
//                           "value":
//                               '${state.aadharvalidateResponse?.house} ${state.aadharvalidateResponse?.street} ${state.aadharvalidateResponse?.locality} ${state.aadharvalidateResponse?.vtcName} ${state.aadharvalidateResponse?.postOfficeName}',
//                         },
//                       ],
//                     }
//                   else
//                     {
//                       dataList = [
//                         {
//                           "icon": Icons.currency_rupee,
//                           "label": "CBS",
//                           "value": "true",
//                         },
//                         {
//                           "icon": Icons.assignment_add,
//                           "label": "Remarks",
//                           "value": state.dedupeResponse?.remarks as String,
//                         },
//                       ],
//                     },
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ResponseWidget(
//                           heightSize:
//                               state.aadharvalidateResponse != null
//                                   ? 0.50
//                                   : 0.32,
//                           dataList: dataList,
//                           onpressed: () => {disposeResponse(context, state)},
//                         ),
//                       );
//                     },
//                   ),
//                 }
//               else if (state.status == DedupeFetchStatus.failure)
//                 {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text(state.errorMsg!))),
//                 },
//             },
//         builder: (context, state) {
//           return ReactiveForm(
//             formGroup: dedupeForm,
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                       child: Text(
//                         "Dedupe Search",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Dropdown(
//                           controlName: 'title',
//                           label: 'Title',
//                           items: ['Mr', 'Mrs', 'Miss', 'Others'],
//                         ),
//                         CustomTextField(
//                           controlName: 'firstname',
//                           label: 'First Name',
//                         ),
//                         CustomTextField(
//                           controlName: 'lastname',
//                           label: 'Last Name',
//                         ),
//                         IntegerTextField('mobilenumber', 'Mobile Number'),
//                         CustomTextField(
//                           controlName: 'pan',
//                           label: 'PAN Number',
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: IntegerTextField(
//                                 'aadhaar',
//                                 'Aadhaar Number',
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             if (state.dedupeResponse?.remarksFlag == false)
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color.fromARGB(
//                                     255,
//                                     3,
//                                     9,
//                                     110,
//                                   ),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   final AadharvalidateRequest
//                                   aadharvalidateRequest = AadharvalidateRequest(
//                                     aadhaarNumber:
//                                         dedupeForm.control('aadhaar').value,
//                                   );
//                                   context.read<DedupeBloc>().add(
//                                     ValiateAadharEvent(
//                                       request: aadharvalidateRequest,
//                                     ),
//                                   );
//                                   print(state.aadharvalidateResponse);
//                                 },
//                                 child: const Text("Validate"),
//                               ),
//                           ],
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color.fromARGB(255, 3, 9, 110),
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             print("Click function passed ${dedupeForm.value}");
//                             if (dedupeForm.valid) {
//                               print(
//                                 "Click function passed go here, ${dedupeForm.valid}",
//                               );
//                               final DedupeRequest
//                               request = DedupeRequest().copyWith(
//                                 aadharCard: dedupeForm.control('aadhaar').value,
//                                 panCard: dedupeForm.control('pan').value,
//                                 mobileno:
//                                     dedupeForm.control('mobilenumber').value,
//                               );

//                               context.read<DedupeBloc>().add(
//                                 FetchDedupeEvent(request: request),
//                               );
//                             } else {
//                               print(
//                                 "Click function passed go here, ${dedupeForm.valid}",
//                               );
//                               dedupeForm.markAllAsTouched();
//                             }
//                           },
//                           // child: Text("click"),
//                           child:
//                               state.status == DedupeFetchStatus.loading
//                                   ? CircularProgressIndicator()
//                                   : Text("Search"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// need for Dedupe Page Response show

// SizedBox(
//   child: BlocBuilder<DedupeBloc, DedupeState>(
//     builder: (context, state) {
//       if (state.status == DedupeFetchStatus.success && state.aadharvalidateResponse == null) {
//         dataList = [
//           {"icon": Icons.currency_rupee, "label": "CBS", "value": "true"},
//           {"icon": Icons.assignment_add, "label": "Remarks", "value": state.dedupeResponse?.remarks as String},
//         ];
//         return Column(
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Text("Dedupe Response", style: TextStyle(fontWeight: FontWeight.bold),),
//             ResponseWidget(heightSize: 0.32, dataList: dataList, buttonshow: false, onpressed: () {})
//           ],
//         );
//       } else if (state.status == DedupeFetchStatus.success && state.aadharvalidateResponse != null) {
//         dataList = [
//           {
//             "icon": Icons.person,
//             "label": "Name",
//             "value": state.aadharvalidateResponse?.name as String,
//           },
//           {
//             "icon":
//                 state.aadharvalidateResponse?.gender == "MALE"
//                     ? Icons.male
//                     : Icons.female,
//             "label": "Gender",
//             "value":
//                 state.aadharvalidateResponse?.gender as String,
//           },
//           {
//             "icon": Icons.calendar_month,
//             "label": "DOB",
//             "value":
//                 state.aadharvalidateResponse?.dateOfBirth
//                     as String,
//           },
//           {
//             "icon": Icons.contact_phone,
//             "label": "Mobile",
//             "value": "",
//           },
//           {
//             "icon": Icons.home,
//             "label": "Address",
//             "value":
//                 '${state.aadharvalidateResponse?.house} ${state.aadharvalidateResponse?.street} ${state.aadharvalidateResponse?.locality} ${state.aadharvalidateResponse?.vtcName} ${state.aadharvalidateResponse?.postOfficeName}',
//           },
//         ];
//         return Column(
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Text("Aadhaar Response", style: TextStyle(fontWeight: FontWeight.bold),),
//             ResponseWidget(heightSize: 0.4, dataList: dataList, buttonshow: false, onpressed: () {})
//           ],
//         );
//       }
//       return SizedBox(height: 50) ;
//     }
//   ),
// ),

// BlocBuilder<DedupeBloc, DedupeState>(
//   builder: (context, state) {
//     if (state.status == DedupeFetchStatus.success && state.cifResponseModel != null) {
//       var formattedDate = getDateFormat(state.cifResponseModel?.lpretLeadDetails['lleaddob']),
//       dataList = [
//         {
//           "icon": Icons.person,
//           "label": "Name",
//           "value": [
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadfrstname'] ??
//                 '',
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadmidname'] ??
//                 '',
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadlastname'] ??
//                 '',
//           ].where((val) => val.isNotEmpty).join(' '),
//         },

//         {
//           "icon": Icons.date_range,
//           "label": "DOB",
//           "value": formattedDate,
//         },
//         {
//           "icon": Icons.call,
//           "label": "Mobile",
//           "value":
//               state
//                   .cifResponseModel
//                   ?.lpretLeadDetails['lleadmobno'],
//         },
//         {
//           "icon": Icons.chrome_reader_mode_rounded,
//           "label": "PAN",
//           "value":
//               state
//                   .cifResponseModel
//                   ?.lpretLeadDetails['lleadpanno'],
//         },
//         {
//           "icon": Icons.elevator_rounded,
//           "label": "AAdhaar",
//           "value":
//               state
//                   .cifResponseModel
//                   ?.lpretLeadDetails['lleadadharno'],
//         },
//         {
//           "icon": Icons.home,
//           "label": "Address",
//           "value": [
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadaddress'] ??
//                 '',
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadaddresslane1'] ??
//                 '',
//             state
//                     .cifResponseModel
//                     ?.lpretLeadDetails['lleadaddresslane2'] ??
//                 '',
//           ].where((val) => val.isNotEmpty).join(' '),
//         },
//         {
//           "icon": Icons.format_list_numbered_rtl_rounded,
//           "label": "Pinocode",
//           "value":
//               state
//                   .cifResponseModel
//                   ?.lpretLeadDetails['lleadpinno'],
//         },
//       ];
//       return Column(
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           Text("CiF Response", style: TextStyle(fontWeight: FontWeight.bold),),
//           ResponseWidget(heightSize: 0.32, dataList: dataList, buttonshow: false, onpressed: () {})
//         ]

//       );
//     }
//     return SizedBox(height: 50) ;
//   }
// )
