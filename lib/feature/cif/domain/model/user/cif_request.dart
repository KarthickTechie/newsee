// ignore_for_file: public_member_api_docs, sort_constructors_first
// CIF Request Data Class

/*
  @author     : gayathri.b 05/06/2025
 @description: Represents the request payload for the lead search API.
   */
import 'dart:convert';

import 'package:newsee/core/api/api_config.dart';

class CIFRequest {
  String? custId;
  String? uniqueId;
  String cifId;
  String? type;
  String? token;
  CIFRequest({
    this.custId,
    this.uniqueId,
    required this.cifId,
    this.type,
    this.token,
  });

  CIFRequest copyWith({
    String? custId,
    String? uniqueId,
    String? cifId,
    String? type,
    String? token,
  }) {
    return CIFRequest(
      custId: "902534",
      uniqueId: "3",
      cifId: cifId ?? this.cifId,
      type: "borrower",
      token: ApiConfig.AUTH_TOKEN,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'custId': custId,
      'uniqueId': uniqueId,
      'cifId': cifId,
      'type': type,
      'token': token,
    };
  }

  factory CIFRequest.fromMap(Map<String, dynamic> map) {
    return CIFRequest(
      custId: map['custId'] != null ? map['custId'] as String : null,
      uniqueId: map['uniqueId'] != null ? map['uniqueId'] as String : null,
      cifId: map['cifId'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CIFRequest.fromJson(String source) =>
      CIFRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
