// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'deduperesponse.g.dart';

@JsonSerializable()
class DedupeResponse {
  final bool CBS;
  final bool remarksFlag;
  final String remarks;

  DedupeResponse({
    required this.CBS,
    required this.remarksFlag,
    required this.remarks,
  });

  DedupeResponse copyWith({bool? CBS, bool? remarksFlag, String? remarks}) {
    return DedupeResponse(
      CBS: CBS ?? this.CBS,
      remarksFlag: remarksFlag ?? this.remarksFlag,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'CBS': CBS,
      'remarksFlag': remarksFlag,
      'remarks': remarks,
    };
  }

  factory DedupeResponse.fromMap(Map<String, dynamic> map) {
    return DedupeResponse(
      CBS: map['CBS'] as bool,
      remarksFlag: map['remarksFlag'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$DedupeResponseToJson(this);

  factory DedupeResponse.fromJson(Map<String, dynamic> source) =>
      _$DedupeResponseFromJson(source);

  @override
  String toString() =>
      'DedupeResponse(CBS: $CBS, remarksFlag: $remarksFlag, remarks: $remarks)';

  @override
  bool operator ==(covariant DedupeResponse other) {
    if (identical(this, other)) return true;

    return other.CBS == CBS &&
        other.remarksFlag == remarksFlag &&
        other.remarks == remarks;
  }

  @override
  int get hashCode => CBS.hashCode ^ remarksFlag.hashCode ^ remarks.hashCode;
}
