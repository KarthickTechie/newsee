import 'dart:convert';
import 'package:flutter/foundation.dart';

class LandHoldingResponceModel {
  final List<Map<String, dynamic>> agriLandHoldingsList;

  LandHoldingResponceModel({required this.agriLandHoldingsList});

  LandHoldingResponceModel copyWith({
    List<Map<String, dynamic>>? agriLandHoldingsList,
  }) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: agriLandHoldingsList ?? this.agriLandHoldingsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {'agriLandHoldingsList': agriLandHoldingsList};
  }

  factory LandHoldingResponceModel.fromMap(Map<String, dynamic> map) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: List<Map<String, dynamic>>.from(
        (map['agriLandHoldingsList'] ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingResponceModel.fromJson(dynamic source) {
    if (source is String) {
      return LandHoldingResponceModel.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return LandHoldingResponceModel.fromMap(source);
    } else {
      throw Exception("Invalid source type for fromJson");
    }
  }

  @override
  String toString() =>
      'LandHoldingResponceModel(agriLandHoldingsList: $agriLandHoldingsList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LandHoldingResponceModel &&
        listEquals(other.agriLandHoldingsList, agriLandHoldingsList);
  }

  @override
  int get hashCode => agriLandHoldingsList.hashCode;
}
