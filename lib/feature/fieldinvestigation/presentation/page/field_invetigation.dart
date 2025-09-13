import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/fieldinvestigation/presentation/bloc/field_investigation_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/widgets/cupertino_expansion_tile.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/expansion_controller.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/reference_widget.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sqflite/sqflite.dart';

class FieldInvetigation extends StatelessWidget {
  final String proposalNumber;
  FieldInvetigation({
    required this.proposalNumber
  });

  final relationShipLov = [
    Lov(
      Header: 'relationship', 
      optvalue: '1', 
      optDesc: 'Customer 1', 
      optCode: '1'
    ),
    Lov(
      Header: 'relationship', 
      optvalue: '2', 
      optDesc: 'Customer 2', 
      optCode: '2'
    ),
    Lov(
      Header: 'relationship', 
      optvalue: '3', 
      optDesc: 'Customer 3', 
      optCode: '3'
    )
  ];

  final otherDetailsLov = [
    Lov(
      Header: 'otherDetails', 
      optvalue: '1', 
      optDesc: 'None Of Them Above', 
      optCode: '1'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '2', 
      optDesc: 'Others As Per Exclusion List', 
      optCode: '2'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '3', 
      optDesc: 'Political Connection', 
      optCode: '3'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '4', 
      optDesc: 'Journalist', 
      optCode: '4'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '5', 
      optDesc: 'Lawyer', 
      optCode: '5'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '6', 
      optDesc: 'Litigant', 
      optCode: '6'
    ),
    Lov(
      Header: 'otherDetails', 
      optvalue: '7', 
      optDesc: 'Alcoholic', 
      optCode: '7'
    )
  ];

  final typeOfHouseLov = [
    Lov(
      Header: 'typeOfHouse', 
      optvalue: '1', 
      optDesc: 'Pucca', 
      optCode: '1'
    ),
    Lov(
      Header: 'typeOfHouse', 
      optvalue: '2', 
      optDesc: 'Kaccha', 
      optCode: '2'
    )
  ];

  final referenceFields1 = {
    'name': 'name1',
    "address": 'address1',
    'pincode': 'pincode1',
    'state': 'state1',
    'contactnumber': 'contactnumber1', 
    'relationship': 'relationship1',
  };

  final referenceFields2 = {
    'name': 'name2',
    "address": 'address2',
    'pincode': 'pincode2',
    'state': 'state2',
    'contactnumber': 'contactnumber2', 
    'relationship': 'relationship2',
  };

  final form = AppForms.buildFieldInvestigationDetailsForm();
  late List<GeographyMaster> stateListMaster;

  final ExpansionController _controller = ExpansionController();

  handleSubmit(context) {
    try {
      if (form.valid) {
         showDialog(
                          context: context,
                          builder:
                              (_) => SysmoAlert.success(
                                message:
                                    "Field Investigation Saved Successfully",
                                onButtonPressed: () {
                                  context.pop();
                            
                                },
                              ),
                        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Field Investigation Saved Successfully')),
        // );
      } else {
          showDialog(
                          context: context,
                          builder:
                              (context) => SysmoAlert.warning(
                                message:
                                    "Please fill all forms before adding details",
                                onButtonPressed: () {
                                   context.pop();
                                  form.markAllAsTouched();
                            
                                },
                              ),
                        );
        form.markAllAsTouched();
      }
    } catch(error) {
      print("field-Investigation-handleSubmit-error=> $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
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
              'Field Investigation Details',
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
                          proposalNumber ?? 'N/A',
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
      body: BlocProvider(
        create:(context) => FieldInvestigationBloc()..add(FieldInvestigationInitEvent(proposalNumber: proposalNumber)),
        child: BlocConsumer<FieldInvestigationBloc, FieldInvestigationState>(
          listener: (context, state) => {},
          builder: (context, state) => ReactiveForm(
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
                                
                                AnimatedBuilder(
                                  animation: _controller, 
                                  builder: (context,_) {
                                    return Column(
                                      children: [
                                        CupertinoExpansionTile(
                                          icon: Icons.share_location_sharp, 
                                          index: 0,
                                          controller: _controller,
                                          title: "FI Details", 
                                          subtitle: "Field Investigation Details", 
                                          cardWidthValue: 0,
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                controlName: 'personMeet',
                                                label: 'Name of person met during FI',
                                                mantatory: true,
                                              ),
                                              IntegerTextField(
                                                controlName: 'contactNumber', 
                                                label: 'Contact No of person giving information', 
                                                mantatory: true,
                                                maxlength: 10,
                                                minlength: 10,
                                              ),
                                              Dropdown(
                                                controlName: 'FIDoneat', 
                                                label: 'Field inspection done at', 
                                                items: ['Both', 'House', 'Farm']
                                              ),
                                              SearchableDropdown(
                                                controlName: 'relationshipOfPerson',
                                                label: 'Relationship of person giving details',
                                                items: relationShipLov,
                                                onChangeListener: (Lov val) {
                                                  form.controls['relationshipOfPerson']?.updateValue(
                                                    val.optvalue,
                                                  );
                                                },
                                                selItem: () {},
                                              ),
                                              Dropdown(
                                                controlName: 'addrSameAsApplicatntAddr', 
                                                label: 'Residing address is same as applicant address', 
                                                items: ['Yes', 'No']
                                              ),
                                              CustomTextField(
                                                controlName: 'diffAddress',
                                                label: 'If different, mention the address, else mention NA',
                                                mantatory: true,
                                              ),
                                              Dropdown(
                                                controlName: 'originalKYCSeen', 
                                                label: 'Whether Original KYC seen & verified', 
                                                items: ['Yes', 'No']
                                              ),
                                              SearchableDropdown(
                                                controlName: 'typeOfHouse',
                                                label: 'Type of House',
                                                items: typeOfHouseLov,
                                                onChangeListener: (Lov val) {
                                                  form.controls['typeOfHouse']?.updateValue(
                                                    val.optvalue,
                                                  );
                                                },
                                                selItem: () {},
                                              ),
                                              CustomTextField(
                                                controlName: 'feedbackAndBackground',
                                                label: 'Market feedback & Background of Applicant',
                                                mantatory: true,
                                              ),
                                              SearchableDropdown(
                                                controlName: 'otherDetails',
                                                label: 'Other details / References',
                                                items: otherDetailsLov,
                                                onChangeListener: (Lov val) {
                                                  form.controls['otherDetails']?.updateValue(
                                                    val.optvalue,
                                                  );
                                                },
                                                selItem: () {},
                                              ),
                                              Dropdown(
                                                controlName: 'approachRoattoFarm', 
                                                label: 'Approach road to farm', 
                                                items: ['Yes', 'No']
                                              ),
                                              CustomTextField(
                                                controlName: 'cropObserved',
                                                label: 'If no crop observed, Narrate the reason for same',
                                                mantatory: true,
                                              ),
                                            ],

                                          )
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CupertinoExpansionTile(
                                          icon: Icons.person_add_alt_sharp, 
                                          index: 1,
                                          controller: _controller,
                                          title: "Reference 1", 
                                          subtitle: "Reference Details 1", 
                                          cardWidthValue: 0,
                                          child: ReferenceWidget(
                                            form: form, 
                                            stateMaster: state.stateCityMaster!,
                                            formfields: referenceFields1,
                                          )
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CupertinoExpansionTile(
                                          icon: Icons.group_add_sharp,
                                          index: 2,
                                          controller: _controller, 
                                          title: "Reference 2", 
                                          subtitle: "Reference Details 2", 
                                          cardWidthValue: 0,
                                          child: ReferenceWidget(
                                            form: form, 
                                            stateMaster: state.stateCityMaster!,
                                            formfields: referenceFields2,
                                          ),
                                        ),
                                      ],
                                    );
                                    
                                  }
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed:  () => {
                                    handleSubmit(context)
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
                                  backgroundColor: Color.fromARGB(255, 2, 59, 105),

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
                ]
              )
            )
          ),
        ),
      )
    );
  }
}