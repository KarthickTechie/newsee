import 'dart:convert';
import 'package:flutter/foundation.dart';

/*
  @author      : gayathri.b 11/06/2025
  @description : Represents the response payload returned from the lead search API.
                 This model contains lead list data, types of loans, and sourcing channel LOVs,
                 and supports JSON serialization, deep equality, and immutability.
 @param       : leadlists - List of leads returned from the API.
                 typeofloan - List of available loan types.
                 sourcingChannelLov - List of sourcing channels (LOVs).
  @return      : JSON serializable object used across data and domain layers.
                
*/

class LeadResponseModel {
  final List<Map<String, dynamic>> leadlists;
  final List<Map<String, dynamic>> typeofloan;
  final List<Map<String, dynamic>> sourcingChannelLov;

  LeadResponseModel({
    required this.leadlists,
    required this.typeofloan,
    required this.sourcingChannelLov,
  });

  LeadResponseModel copyWith({
    List<Map<String, dynamic>>? leadlists,
    List<Map<String, dynamic>>? typeofloan,
    List<Map<String, dynamic>>? sourcingChannelLov,
  }) {
    return LeadResponseModel(
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

  factory LeadResponseModel.fromMap(Map<String, dynamic> map) {
    return LeadResponseModel(
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

  factory LeadResponseModel.fromJson(String source) =>
      LeadResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LeadResponseModel(leadlists: $leadlists, typeofloan: $typeofloan, sourcingChannelLov: $sourcingChannelLov)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeadResponseModel &&
        listEquals(other.leadlists, leadlists) &&
        listEquals(other.typeofloan, typeofloan) &&
        listEquals(other.sourcingChannelLov, sourcingChannelLov);
  }

  @override
  int get hashCode =>
      leadlists.hashCode ^ typeofloan.hashCode ^ sourcingChannelLov.hashCode;
}
