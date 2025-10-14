import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

Future<Response> offlineDataProvider({required String path}) async {
  final String res = await rootBundle.loadString(path);
  return Response(data: json.decode(res), requestOptions: RequestOptions());
}
