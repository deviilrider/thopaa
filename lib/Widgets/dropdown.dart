import 'package:flutter/material.dart';
import 'package:thopaa/export.dart';

class MyAdvancedDropdown extends StatelessWidget {
  final List<DropdownMenuItem<String>>? items;
  final String? labeltext;
  final String? selectedItem;
  final Function(String?) onChanged;

  const MyAdvancedDropdown(
      {super.key,
      this.items,
      this.labeltext,
      this.selectedItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonFormField<String>(
          value: selectedItem,
          onChanged: onChanged,
          decoration: inputDecoration(context, labelText: labeltext),
          items: items),
    );
  }
}
