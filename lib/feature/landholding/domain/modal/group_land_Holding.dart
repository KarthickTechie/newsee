// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class GroupLandHolding {
  final List<Map<String, dynamic>> finalList;

  GroupLandHolding({required this.finalList});

  GroupLandHolding copyWith({List<Map<String, dynamic>>? finalList}) {
    return GroupLandHolding(finalList: finalList ?? this.finalList);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'finalList': finalList};
  }

  factory GroupLandHolding.fromMap(Map<String, dynamic> map) {
    return GroupLandHolding(
      finalList: List<Map<String, dynamic>>.from(
        (map['finalList'] as List<dynamic>).map<Map<String, dynamic>>((x) => x),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupLandHolding.fromJson(String source) =>
      GroupLandHolding.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupLandHolding(finalList: $finalList)';

  @override
  bool operator ==(covariant GroupLandHolding other) {
    if (identical(this, other)) return true;
    return listEquals(other.finalList, finalList);
  }

  @override
  int get hashCode => finalList.hashCode;
}
