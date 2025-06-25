// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProposalCreationRequest {
  final String? leadId;
  final String? userid;
  final String? token;
  ProposalCreationRequest({this.leadId, this.userid, this.token});

  ProposalCreationRequest copyWith({
    String? leadId,
    String? userid,
    String? token,
  }) {
    return ProposalCreationRequest(
      leadId: leadId ?? this.leadId,
      userid: userid ?? this.userid,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'leadId': leadId,
      'userid': userid,
      'token': token,
    };
  }

  factory ProposalCreationRequest.fromMap(Map<String, dynamic> map) {
    return ProposalCreationRequest(
      leadId: map['leadId'] as String,
      userid: map['userid'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProposalCreationRequest.fromJson(String source) =>
      ProposalCreationRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'ProposalCreationRequest(leadId: $leadId, userid: $userid, token: $token)';

  @override
  bool operator ==(covariant ProposalCreationRequest other) {
    if (identical(this, other)) return true;

    return other.leadId == leadId &&
        other.userid == userid &&
        other.token == token;
  }

  @override
  int get hashCode => leadId.hashCode ^ userid.hashCode ^ token.hashCode;
}
