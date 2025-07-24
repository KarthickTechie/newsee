import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SearchableMultiSelectDropdown<T> extends StatelessWidget {
  final ValueNotifier<List<T>> selectedItemsNotifier = ValueNotifier<List<T>>(
    [],
  );
  final String controlName;
  final String label;
  final List<T> items;
  final bool? mandatory;
  final List<T> Function() selItems;
  final Function(List<T>?)? onChangeListener;
  final Key? fieldKey;

  SearchableMultiSelectDropdown({
    this.fieldKey,
    required this.controlName,
    required this.label,
    required this.items,
    required this.selItems,
    this.mandatory,
    this.onChangeListener,
  });

  String itemValueMapper(T item) {
    if (item is Lov) {
      return item.optDesc;
    } else {
      return item.toString();
    }
  }

  _onChangeListener(List<T> val) {
    selectedItemsNotifier.value = val;
    if (onChangeListener != null)
      onChangeListener!(selectedItemsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<String, T>(
      key: fieldKey,
      formControlName: controlName,
      validationMessages: {
        ValidationMessage.required: (error) => '$label is required',
      },
      builder: (field) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownSearch<T>.multiSelection(
            items: items,
            selectedItems: selItems(),
            itemAsString: (item) => itemValueMapper(item),
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      if (mandatory == null || mandatory == true)
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
                border: UnderlineInputBorder(),
              ),
            ),
            onChanged: (val) {
              _onChangeListener(val);
            },
          ),
        );
      },
    );
  }
}
