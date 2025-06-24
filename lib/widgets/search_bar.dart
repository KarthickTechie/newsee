import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const SearchBarWidget({required this.onChanged,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16,
        16,
        8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, TextEditingValue value, _) {
                return TextField(
                  controller: controller,
                  autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: controller.text.isNotEmpty?
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                      FocusScope.of(context).unfocus();
                    },)
                    : null,
                ),
                onChanged: onChanged,
              );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
