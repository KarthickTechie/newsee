import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/productcard.dart';
import 'package:newsee/widgets/searchable_drop_down.dart';
import 'package:reactive_forms/reactive_forms.dart';

/* 
  @author      :  karthick.d  05/06/2025
  @desc         :
      Function Logic Implementation step 1: 
      init data for typeofloan must be set at first
      setup bloc , LoanDetailsBloc<LoanDetailsEvent,LoanDetailsState>
      LoanDetailsState - should have states that serves as datasource for dropdowns
                         class LoanDetailsState 
                                List<ProductScheme> productSchemeList
                                ProductScheme selectedProductScheme 
                                List<MainCategory> mainCategoryList
                                MainCategory selectedMainCategory
                                List<SubCategory> subCategoryList
                                SubCategory selectedSubCategoryList
                                List<ProductMaster> productmasterList
                                ProductMaster selectedProduct
                                
      LoanDetailsEvent 
            -init             - this event will set initial data for typeofproduct dropdown
            -loading
            -onDropdownChange - this event will be triggered for any dropdownchange
                                optiontype - scheme - change of typeofloan dropdown
                                
                                LoanProductOptionChange({optionType:'scheme'})
                                context.read<LoanDetailsBloc>().add(LoanProductOptionChange)

                                emit(LoanProductState.copyWith())
            -onLoading        - this event handle loading progress
            

  below the json we need to set for leaddetails submission request
        "chooseProduct": {
            "mainCategory": "1",
            "subCategory": "426",
            "producrId": "10"
    },
  step 2:
  step 3:
 */

class Loan extends StatelessWidget {
  final String title;
  final ValueNotifier<bool> isFormDirty = ValueNotifier<bool>(false);
  Loan({super.key, required this.title});

  final form = FormGroup({
    'typeofloan': FormControl<String>(validators: [Validators.required]),
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
  });
  @override
  Widget build(BuildContext context) {
    final _context = context;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (x,y) async {
        if (isFormDirty.value) {
          final shouldLeave = await showExitConfirmationDialog(context);
          if (shouldLeave ?? false) {
                await SystemNavigator.pop();
                // context.go('/'); // Navigate back using GoRouter
              }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loan Details"),
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<LoanproductBloc, LoanproductState>(
          listener: (context, state) {
            BuildContext ctxt = context;
            print('LoanProductBlocListener:: log =>  ${state.showBottomSheet}');
      
              if (state.showBottomSheet == true) {
                openBottomSheet(
                  context,
                  0.7,
                  0.5,
                  0.9,
                  (context, scrollController) => Expanded(
                    child: ListView.builder(
                      itemCount: state.productmasterList.length,
                      itemBuilder: (context, index) {
                        final product = state.productmasterList[index];
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: InkWell(
                            // card widget for showing products
                            onTap: () {
                              ProductMaster selectedProduct = product;
                              ctxt.read<LoanproductBloc>().add(
                                ResetShowBottomSheet(
                                  selectedProduct: selectedProduct,
                                ),
                              );
                            },
                            child: ProductCard(productId:product.prdCode,productDescription: product.prdDesc, amountFrom: product.prdamtFromRange, amountTo: product.prdamtToRange)
                          ),
                      );
                    },
                  ),
                ),
              );
            }
      
      
            if (state.selectedProduct != null && state.showBottomSheet == false) {
              print('poping current route');
              LoanproductState.init();
              Navigator.of(_context).pop();
            }
          },
          // child: BlocBuilder<LoanproductBloc, LoanproductState>(
          builder: (context, state) {
            return ReactiveForm(
              formGroup: form,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SearchableDropdown<ProductSchema>(
                        controlName: 'typeofloan',
                        label: 'Type Of Loan',
                        items: state.productSchemeList,
                        onChangeListener: (ProductSchema val) {
                          isFormDirty.value = true;
                          form.controls['typeofloan']?.updateValue(
                            val.optionDesc,
                          );
      
                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'maincategory',
                        label: 'Main Category',
                        items: state.mainCategoryList,
                        onChangeListener: (Product val) {
                          isFormDirty.value = true;
                          form.controls['maincategory']?.updateValue(
                            val.lsfFacDesc,
                          );
      
                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'subcategory',
                        label: 'Sub Category',
                        items: state.subCategoryList,
                        onChangeListener: (Product val) {
                          isFormDirty.value = true;
                          form.controls['subcategory']?.updateValue(
                            val.lsfFacDesc,
                          );
      
                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                      ),
      
                      Column(
                        children:
                            state.selectedProduct != null
                                ? [
                                  ProductCard(
                                    productId:state.selectedProduct!.prdCode,
                                    productDescription:
                                        state.selectedProduct!.prdDesc,
                                    amountFrom:
                                        state.selectedProduct!.prdamtFromRange,
                                    amountTo:
                                        state.selectedProduct!.prdamtToRange,
                                  ),
                                ]
                                : [Text('No product')],
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 3, 9, 110),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (form.valid) {
                              final tabController = DefaultTabController.of(
                                context,
                              );
                              if (tabController.index <
                                  tabController.length - 1) {
                                tabController.animateTo(tabController.index + 1);
                              }
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text('Form not saved,Do you want to go back?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Leave'),
            ),
          ],
        );
      },
    );
  }
