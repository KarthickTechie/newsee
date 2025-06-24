import 'dart:convert';
import 'package:flutter/foundation.dart';

class LandHoldingResponceModel {
  final List<Map<String, dynamic>> leadlists;
  final List<Map<String, dynamic>> typeofloan;
  final List<Map<String, dynamic>> sourcingChannelLov;

  LandHoldingResponceModel({
    required this.leadlists,
    required this.typeofloan,
    required this.sourcingChannelLov,
  });

  LandHoldingResponceModel copyWith({
    List<Map<String, dynamic>>? leadlists,
    List<Map<String, dynamic>>? typeofloan,
    List<Map<String, dynamic>>? sourcingChannelLov,
  }) {
    return LandHoldingResponceModel(
      leadlists: leadlists ?? this.leadlists,
      typeofloan: typeofloan ?? this.typeofloan,
      sourcingChannelLov: sourcingChannelLov ?? this.sourcingChannelLov,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leadlists': leadlists,
      'typeofloan': typeofloan,
      'sourcingChannelLov': sourcingChannelLov,
    };
  }

  factory LandHoldingResponceModel.fromMap(Map<String, dynamic> map) {
    return LandHoldingResponceModel(
      leadlists: List<Map<String, dynamic>>.from(
        (map['leadlists'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      typeofloan: List<Map<String, dynamic>>.from(
        (map['typeofloan'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      sourcingChannelLov: List<Map<String, dynamic>>.from(
        (map['sourcingChannelLov'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingResponceModel.fromJson(String source) =>
      LandHoldingResponceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LeadResponseModel(leadlists: $leadlists, typeofloan: $typeofloan, sourcingChannelLov: $sourcingChannelLov)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LandHoldingResponceModel &&
        listEquals(other.leadlists, leadlists) &&
        listEquals(other.typeofloan, typeofloan) &&
        listEquals(other.sourcingChannelLov, sourcingChannelLov);
  }

  @override
  int get hashCode =>
      leadlists.hashCode ^ typeofloan.hashCode ^ sourcingChannelLov.hashCode;
}
