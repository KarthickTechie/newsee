import 'package:flutter/material.dart';
import 'package:newsee/feature/cif/presentation/page/cif_search.dart';
import 'package:newsee/feature/dedupe/presentation/page/dedupe_search.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BottomSheetContainer extends StatelessWidget {
  final bool isNewCustomer;
  final FormGroup form;
  final TabController tabController;
  BottomSheetContainer({required this.isNewCustomer, required this.form, required this.tabController});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: isNewCustomer ? 0.9 : 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            border: Border.all(
              width: 3,
              color: Color(0x00FFFFFF),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 9, 110),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: isNewCustomer ? 
                    DedupeSearch(
                      dedupeForm: form,
                      tabController: tabController,
                    )
                    : 
                    CIFSearch(
                      cifForm: form,
                      tabController: tabController,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}