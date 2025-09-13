import 'package:flutter/material.dart';
import 'package:newsee/feature/dynamic_form/form_mapper.dart';
import 'package:newsee/widgets/alpha_text_field.dart';
import 'package:newsee/widgets/custom_text_field.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/integer_text_field.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

Widget buildField(
  FormMapper field, 
  FormGroup formGroup, 
  // void Function(dynamic)? onItemSelected,
) {
  switch (field.formType) {
    case "AlphaTextField":
      return AlphaTextField(
        controlName: field.formName,
        label: field.label,
        mantatory: true,
      );

    case "IntegerTextField":
      return IntegerTextField(
        controlName: field.formName,
        label: field.label,
        mantatory: true,
        maxlength: 10,
      );

    case "Dropdown":
      return Dropdown(
        controlName: field.formName,
        label: field.label,
        items: field.options!.map((e) => e as String).toList(),
      );

    case "SearchableDropdown":
      List<dynamic> optionsList = (field.options as List<dynamic>).map((e) => e).toList();
      return SearchableDropdown<dynamic>(
        controlName: field.formName,
        label: field.label,
        selItem: () => null,
        // onItemSelected!,
        items: optionsList,
        onChangeListener: (value) {
          formGroup.controls[field.formName]?.updateValue(value.optvalue);
        },
      );

    case "CustomTextField":
      return CustomTextField(
        controlName: field.formName,
        label: field.label,
        mantatory: true,
      
      );

    default:
      return const SizedBox();

  }

  
}