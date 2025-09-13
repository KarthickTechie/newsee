import 'package:flutter/material.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReferenceWidget extends StatelessWidget {
  final FormGroup form;
  final List<GeographyMaster> stateMaster;
  final Map<String, String> formfields;
  ReferenceWidget({
    required this.form,
    required this.stateMaster,
    required this.formfields
  });

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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controlName: formfields['name']!,
          label: 'Name',
          mantatory: true,
        ),
        CustomTextField(
          controlName: formfields['address']!,
          label: 'Address',
          mantatory: true,
        ),
        IntegerTextField(
          controlName: formfields['pincode']!, 
          label: 'Pincode', 
          mantatory: true,
          maxlength: 6,
          minlength: 6,
        ),
        SearchableDropdown(
            controlName: formfields['state']!,
            label: 'State',
            items: stateMaster,
            onChangeListener: (GeographyMaster val) {
              form.controls[formfields['state']]?.updateValue(
                val.code,
              );
            },
            selItem: () {},
          ),
        IntegerTextField(
          controlName: formfields['contactnumber']!, 
          label: 'Contact Number', 
          mantatory: true,
          maxlength: 10,
          minlength: 10,
        ),
        SearchableDropdown(
          controlName: formfields['relationship']!,
          label: 'Relationship',
          items: otherDetailsLov,
          onChangeListener: (Lov val) => {
            form.controls[formfields['relationship']]?.updateValue(
              val.optvalue,
            )
          },
          selItem: () {},
        ),
      ],
    );
  }
}