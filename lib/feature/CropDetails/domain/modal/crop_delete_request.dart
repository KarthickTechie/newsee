// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CropDeleteRequest {
 final String proposalNumber;
 final String rowId;
 final String token;
 CropDeleteRequest({
  required this.proposalNumber,
  required this.rowId,
  required this.token
 });

  CropDeleteRequest copyWith({
    String? proposalNumber,
    String? rowId,
    String? token,
  }) {
    return CropDeleteRequest(
      proposalNumber: proposalNumber ?? this.proposalNumber,
      rowId: rowId ?? this.rowId,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proposalNumber': proposalNumber,
      'rowId': rowId,
      'token': token,
    };
  }

  factory CropDeleteRequest.fromMap(Map<String, dynamic> map) {
    return CropDeleteRequest(
      proposalNumber: map['proposalNumber'] as String,
      rowId: map['rowId'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropDeleteRequest.fromJson(String source) => CropDeleteRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CropDeleteRequest(proposalNumber: $proposalNumber, rowId: $rowId, token: $token)';

  @override
  bool operator ==(covariant CropDeleteRequest other) {
    if (identical(this, other)) return true;
  
    return 
      other.proposalNumber == proposalNumber &&
      other.rowId == rowId &&
      other.token == token;
  }

  @override
  int get hashCode => proposalNumber.hashCode ^ rowId.hashCode ^ token.hashCode;
}
