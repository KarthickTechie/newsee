import 'package:dio/src/response.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/masters/domain/repository/masters_response_parser.dart';

class ProductMasterParserImpl extends MastersResponseParser<ProductMaster> {
  @override
  List<ProductMaster> parseResponse(Response response) {
    final setupmaster = response.data['Setupmaster'];
    if (setupmaster != null && setupmaster['ProductMaster'] != null) {
      List productMasterData = setupmaster['ProductMaster'];

      List<ProductMaster> productMasterList =
          productMasterData.map((e) => ProductMaster.fromMap(e)).toList();
      print("productMasterList $productMasterList");
      return productMasterList;
    } else {
      List<ProductMaster> productMasterList = [];
      return productMasterList;
    }
  }
}
