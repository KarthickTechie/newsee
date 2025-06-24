// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GroupLeadInbox {
  final List<Map<String, dynamic>> finalList;
  GroupLeadInbox({required this.finalList});

  GroupLeadInbox copyWith({List<Map<String, dynamic>>? finalList}) {
    return GroupLeadInbox(finalList: finalList ?? this.finalList);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'finalList': finalList};
  }

  factory GroupLeadInbox.fromMap(Map<String, dynamic> map) {
    return GroupLeadInbox(
      finalList: List<Map<String, dynamic>>.from(
        (map['finalList'] as List<dynamic>).map<Map<String, dynamic>>((x) => x),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupLeadInbox.fromJson(String source) =>
      GroupLeadInbox.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupLeadInbox(finalList: $finalList)';

  @override
  bool operator ==(covariant GroupLeadInbox other) {
    if (identical(this, other)) return true;

    return listEquals(other.finalList, finalList);
  }

  @override
  int get hashCode => finalList.hashCode;
}
