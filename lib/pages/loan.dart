import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/widgets/k_willpopscope.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
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
  Loan({super.key, required this.title});

  final form = FormGroup({
    'typeofloan': FormControl<String>(validators: [Validators.required]),
    'maincategory': FormControl<String>(validators: [Validators.required]),
    'subcategory': FormControl<String>(validators: [Validators.required]),
  });
  @override
  Widget build(BuildContext context) {
    final _context = context;
    return Kwillpopscope(
      routeContext: context,
      form: form,
      widget: Scaffold(
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
                // (context, scrollController) => Expanded(
                (context, scrollController) => ListView.builder(
                  controller: scrollController,
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
                        child: ProductCard(
                          productId: product.prdCode,
                          productDescription: product.prdDesc,
                          amountFrom: formatAmount(product.prdamtFromRange),
                          amountTo: formatAmount(product.prdamtToRange),
                        ),
                      ),
                    );
                  },
                ),
                // ),
              );
            }

            if (state.selectedProduct != null &&
                state.showBottomSheet == false &&
                state.status != SaveStatus.success) {
              print('poping current route');
              LoanproductState.init();
              Navigator.of(_context).pop();
            }

            if (state.status == SaveStatus.success && state.getLead == false) {
              Globalconfig.loanAmountMaximum = int.parse(
                state.selectedProduct?.prdamtToRange ?? '0',
              );
              print(
                'loan details saved success =>prodscheme ${state.selectedProductScheme}  maincat ${state.selectedMainCategory} subCat ${state.selectedSubCategoryList} status ${state.status} Globalconfig.loanAmountMaximum ${Globalconfig.loanAmountMaximum}',
              );
              showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert.success(
                      message: "Loan Details Saved Successfully",
                      onButtonPressed: () {
                        Navigator.pop(context);
                        goToNextTab(context: context);
                      },
                    ),
              );
            } else if (state.status == SaveStatus.failure) {
              showDialog(
                context: context,
                builder:
                    (_) => SysmoAlert.failure(
                      message: "Failed to save loan details",
                      onButtonPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              );
            }
          },
          // child: BlocBuilder<LoanproductBloc, LoanproductState>(
          builder: (context, state) {
            if (state.getLead!) {
              form.controls['typeofloan']?.updateValue(
                state.selectedProductScheme?.optionValue.toString(),
              );
              form.controls['maincategory']?.updateValue(
                state.selectedMainCategory?.lsfFacId.toString(),
              );
              form.controls['subcategory']?.updateValue(
                state.selectedSubCategoryList?.lsfFacId.toString(),
              );
              form.markAsDisabled();
            } else {
              form.markAsEnabled();
            }
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
                          form.controls['typeofloan']?.updateValue(
                            val.optionValue,
                          );

                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                        selItem: () {
                          final value = form.control('typeofloan').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.productSchemeList.firstWhere(
                            (element) => element.optionValue == value,
                            orElse:
                                () => ProductSchema(
                                  optionId: '',
                                  optionDesc: '',
                                  optionValue: '',
                                ),
                          );

                          // if (state.selectedProductScheme != null) {
                          //   form.controls['typeofloan']?.updateValue(
                          //     state.selectedProductScheme?.optionValue,
                          //   );
                          //   return state.selectedProductScheme;
                          // } else {
                          //   return null;
                          // }
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'maincategory',
                        label: 'Main Category',
                        items: state.mainCategoryList,
                        onChangeListener: (Product val) {
                          form.controls['maincategory']?.updateValue(
                            val.lsfFacId,
                          );

                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                        selItem: () {
                          final value = form.control('maincategory').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.mainCategoryList.firstWhere(
                            (element) => element.lsfFacId == value,
                            orElse:
                                () => Product(
                                  lsfFacId: '',
                                  lsfFacDesc: '',
                                  lsfFacType: '',
                                  lsfFacParentId: '',
                                  lsfBizVertical: '',
                                ),
                          );

                          // if (state.selectedMainCategory != null) {
                          //   form.controls['maincategory']?.updateValue(
                          //     state.selectedMainCategory?.lsfFacId,
                          //   );
                          //   return state.selectedMainCategory;
                          // } else {
                          //   return null;
                          // }
                        },
                      ),
                      SearchableDropdown(
                        controlName: 'subcategory',
                        label: 'Sub Category',
                        items: state.subCategoryList,
                        onChangeListener: (Product val) {
                          form.controls['subcategory']?.updateValue(
                            val.lsfFacId,
                          );

                          context.read<LoanproductBloc>().add(
                            LoanProductDropdownChange(field: val),
                          );
                        },
                        selItem: () {
                          final value = form.control('subcategory').value;
                          if (value == null || value.toString().isEmpty) {
                            return null;
                          }
                          return state.subCategoryList.firstWhere(
                            (element) => element.lsfFacId == value,
                            orElse:
                                () => Product(
                                  lsfFacId: '',
                                  lsfFacDesc: '',
                                  lsfFacType: '',
                                  lsfFacParentId: '',
                                  lsfBizVertical: '',
                                ),
                          );

                          // if (state.selectedSubCategoryList != null) {
                          //   form.controls['subcategory']?.updateValue(
                          //     state.selectedSubCategoryList?.lsfFacId,
                          //   );
                          //   return state.selectedSubCategoryList;
                          // } else {
                          //   return null;
                          // }
                        },
                      ),

                      Column(
                        children:
                            state.selectedProduct != null
                                ? [
                                  ProductCard(
                                    productId: state.selectedProduct!.prdCode,
                                    productDescription:
                                        state.selectedProduct!.prdDesc,
                                    amountFrom: formatAmount(
                                      state.selectedProduct!.prdamtFromRange,
                                    ),
                                    amountTo: formatAmount(
                                      state.selectedProduct!.prdamtToRange,
                                    ),
                                  ),
                                ]
                                : [Text('')],
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
                            if (state.getLead == null ||
                                state.getLead == false) {
                              final blocState =
                                  context.read<LoanproductBloc>().state;
                              final selectedProduct = blocState.selectedProduct;

                              if (form.valid) {
                                if (selectedProduct == null) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.info,
                                                color: Colors.teal,
                                              ),
                                              SizedBox(width: 8),

                                              Text(
                                                'Alert',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            'Please choose a product before processing..',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(ctx).pop(),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                  );
                                  return;
                                }
                                print(
                                  'loan product form value => ${form.value}',
                                );
                                context.read<LoanproductBloc>().add(
                                  SaveLoanProduct(choosenProduct: form.value),
                                );
                              } else {
                                form.markAllAsTouched();
                              }
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
