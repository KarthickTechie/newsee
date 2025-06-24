import 'package:dio/dio.dart';
import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/masters/domain/repository/masters_response_parser.dart';

class ProductSchemaParserImpl implements MastersResponseParser<ProductSchema> {
  @override
  List<ProductSchema> parseResponse(Response response) {
    final setupmaster = response.data['Setupmaster'];
    if (setupmaster != null && setupmaster['ProductScheme'] != null) {
      List<dynamic> listofvalues = setupmaster['ProductScheme'];
      List<ProductSchema> productschemaList =
          listofvalues.map((e) => ProductSchema.fromMap(e)).toList();
      return productschemaList;
    } else {
      List<ProductSchema> productschemaList = [];
      return productschemaList;
    }
  }
}
