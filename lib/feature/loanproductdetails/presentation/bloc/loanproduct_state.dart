// ignore_for_file: public_member_api_docs, sort_constructors_first

/* 
@author     : karthick.d  05/06/2025
@desc       : loanproduct page associated state
@params     :       LoanDetailsState - should have states that serves as datasource for dropdowns
                         class LoanDetailsState 
                                List<ProductScheme> productSchemeList
                                ProductScheme selectedProductScheme 
                                List<MainCategory> mainCategoryList
                                MainCategory selectedMainCategory
                                List<SubCategory> subCategoryList
                                SubCategory selectedSubCategoryList
                                List<ProductMaster> productmasterList
                                ProductMaster selectedProduct

 */

part of 'loanproduct_bloc.dart';

class LoanproductState extends Equatable {
  final String? leadId;
  final List<ProductSchema> productSchemeList;
  final ProductSchema? selectedProductScheme;
  final List<Product> mainCategoryList;
  final Product? selectedMainCategory;
  final List<Product> subCategoryList;
  final Product? selectedSubCategoryList;
  final List<ProductMaster> productmasterList;
  final ProductMaster? selectedProduct;
  final bool? showBottomSheet;
  final SaveStatus? status;
  @override
  List<Object?> get props => [
    leadId,
    productSchemeList,
    selectedProductScheme,
    mainCategoryList,
    selectedMainCategory,
    subCategoryList,
    selectedSubCategoryList,
    productmasterList,
    showBottomSheet,
    status,
  ];

  const LoanproductState({
    this.leadId,
    required this.productSchemeList,
    this.selectedProductScheme,
    required this.mainCategoryList,
    this.selectedMainCategory,
    required this.subCategoryList,
    this.selectedSubCategoryList,
    required this.productmasterList,
    this.selectedProduct,
    this.showBottomSheet,
    this.status,
  });

  LoanproductState copyWith({
    String? leadId,
    List<ProductSchema>? productSchemeList,
    ProductSchema? selectedProductScheme,
    List<Product>? mainCategoryList,
    Product? selectedMainCategory,
    List<Product>? subCategoryList,
    Product? selectedSubCategoryList,
    List<ProductMaster>? productmasterList,
    ProductMaster? selectedProduct,
    bool? showBottomSheet,
    SaveStatus? status,
  }) {
    return LoanproductState(
      leadId: leadId ?? this.leadId,
      productSchemeList: productSchemeList ?? this.productSchemeList,
      selectedProductScheme:
          selectedProductScheme ?? this.selectedProductScheme,
      mainCategoryList: mainCategoryList ?? this.mainCategoryList,
      selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
      subCategoryList: subCategoryList ?? this.subCategoryList,
      selectedSubCategoryList:
          selectedSubCategoryList ?? this.selectedSubCategoryList,
      productmasterList: productmasterList ?? this.productmasterList,
      selectedProduct: selectedProduct,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'leadId': leadId,
      'productSchemeList': productSchemeList.map((x) => x.toMap()).toList(),
      'selectedProductScheme': selectedProductScheme?.toMap(),
      'mainCategoryList': mainCategoryList.map((x) => x.toMap()).toList(),
      'selectedMainCategory': selectedMainCategory?.toMap(),
      'subCategoryList': subCategoryList.map((x) => x.toMap()).toList(),
      'selectedSubCategoryList': selectedSubCategoryList?.toMap(),
      'productmasterList': productmasterList.map((x) => x.toMap()).toList(),
      'selectedProduct': selectedProduct?.toMap(),
      'showBottomSheet': showBottomSheet,
      'status': status,
    };
  }

  factory LoanproductState.init() => LoanproductState(
    productSchemeList: [],
    mainCategoryList: [],
    subCategoryList: [],
    productmasterList: [],
    selectedProduct: null,
    showBottomSheet: false,
    status: SaveStatus.init,
  );

  factory LoanproductState.fromMap(Map<String, dynamic> map) {
    return LoanproductState(
      leadId: map['leadId'] != null ? map['leadId'] as String : null,
      productSchemeList: List<ProductSchema>.from(
        (map['productSchemeList'] as List<int>).map<ProductSchema>(
          (x) => ProductSchema.fromMap(x as Map<String, dynamic>),
        ),
      ),
      selectedProductScheme:
          map['selectedProductScheme'] != null
              ? ProductSchema.fromMap(
                map['selectedProductScheme'] as Map<String, dynamic>,
              )
              : null,
      mainCategoryList: List<Product>.from(
        (map['mainCategoryList'] as List<int>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      selectedMainCategory:
          map['selectedMainCategory'] != null
              ? Product.fromMap(
                map['selectedMainCategory'] as Map<String, dynamic>,
              )
              : null,
      subCategoryList: List<Product>.from(
        (map['subCategoryList'] as List<int>).map<Product>(
          (x) => Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      selectedSubCategoryList:
          map['selectedSubCategoryList'] != null
              ? Product.fromMap(
                map['selectedSubCategoryList'] as Map<String, dynamic>,
              )
              : null,
      productmasterList: List<ProductMaster>.from(
        (map['productmasterList'] as List<int>).map<ProductMaster>(
          (x) => ProductMaster.fromMap(x as Map<String, dynamic>),
        ),
      ),
      selectedProduct:
          map['selectedProduct'] != null
              ? ProductMaster.fromMap(
                map['selectedProduct'] as Map<String, dynamic>,
              )
              : null,
      showBottomSheet:
          map['showBottomSheet'] != null
              ? map['showBottomSheet'] as bool
              : null,
      status: map['status'] != null ? map['status'] as SaveStatus : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanproductState.fromJson(String source) =>
      LoanproductState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
