/*
 @created on : May 16,2025
 @author : Akshayaa 
 Description : A reusable widget that provides a searchable dropdown integrated with the reactive form.
               controlName is the name of the form control tied to this dropdown. label is displayed as the input label.
               items are the list of selectable string options.
*/

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String controlName;
  final String label;
  final List<T> items;
  final bool? mantatory;
  final T? Function() selItem;
  final Key? fieldKey;
  /*
   @modifiedby   : karthick.d  05/06/2025
   @desc         : this is a changelister function that handle dropdown option change
   */
  final Function? onChangeListener;

  const SearchableDropdown({
    this.fieldKey,
    required this.controlName,
    required this.label,
    required this.items,
    required this.selItem,
    this.mantatory,
    this.onChangeListener,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final FocusNode _focusNode = FocusNode();

  String itemvalueMapper(T item) {
    if (item is ProductSchema) return item.optionDesc.toString();
    if (item is Product) return item.lsfFacDesc.toString();
    if (item is Lov) return item.optDesc.toString();
    if (item is GeographyMaster) return item.value.toString();
    return '';
  }

  _onChangeListener(T? val) => widget.onChangeListener?.call(val);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<String, T>(
      key: widget.fieldKey,
      formControlName: widget.controlName,
      validationMessages: {
        ValidationMessage.required: (error) => '${widget.label} is required',
      },
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownSearch<T>(
            items: widget.items,
            selectedItem: widget.selItem(),
            itemAsString: (item) => itemvalueMapper(item),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      if (widget.mantatory == null)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                errorText: field.errorText,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              if (val != null) {
                print('field value => ${itemvalueMapper(val)}');
              }
              _onChangeListener(val);
            },
          ),
        );
      },
    );
  }
}
