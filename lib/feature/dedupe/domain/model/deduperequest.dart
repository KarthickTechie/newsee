import 'dart:convert';

import 'package:newsee/core/api/api_config.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DedupeRequest {
  // final payload = {
  //   "panCard": "GIBPD5981W",
  //   "aadharCard": "123456789012",
  //   "uaadhar": "121214543532",
  //   "gst": "12421412142112",
  //   "mobileno": "9025434524",
  //   "vertical": "7",
  //   "userid": "1234",
  //   "token": "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3"
  // };

  String? panCard;
  String? aadharCard;
  String? uaadhar;
  String? gst;
  String? mobileno;
  String? vertical;
  String? userid;
  String? token;
  DedupeRequest({
    this.panCard,
    this.aadharCard,
    this.uaadhar,
    this.gst,
    this.mobileno,
    this.vertical,
    this.userid,
    this.token,
  });

  DedupeRequest copyWith({
    String? panCard,
    String? aadharCard,
    String? uaadhar,
    String? gst,
    String? mobileno,
    String? vertical,
    String? userid,
    String? token,
  }) {
    return DedupeRequest(
      panCard: panCard ?? this.panCard,
      aadharCard: aadharCard ?? this.aadharCard,
      uaadhar: "121214543532",
      gst: "12421412142112",
      mobileno: mobileno ?? this.mobileno,
      vertical: "7",
      userid: "1234",
      token: ApiConfig.AUTH_TOKEN,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'panCard': panCard,
      'aadharCard': aadharCard,
      'uaadhar': uaadhar,
      'gst': gst,
      'mobileno': mobileno,
      'vertical': vertical,
      'userid': userid,
      'token': token,
    };
  }

  factory DedupeRequest.fromMap(Map<String, dynamic> map) {
    return DedupeRequest(
      panCard: map['panCard'] != null ? map['panCard'] as String : null,
      aadharCard:
          map['aadharCard'] != null ? map['aadharCard'] as String : null,
      uaadhar: map['uaadhar'] != null ? map['uaadhar'] as String : null,
      gst: map['gst'] != null ? map['gst'] as String : null,
      mobileno: map['mobileno'] != null ? map['mobileno'] as String : null,
      vertical: map['vertical'] != null ? map['vertical'] as String : null,
      userid: map['userid'] != null ? map['userid'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DedupeRequest.fromJson(String source) =>
      DedupeRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DedupeRequest(panCard: $panCard, aadharCard: $aadharCard, uaadhar: $uaadhar, gst: $gst, mobileno: $mobileno, vertical: $vertical, userid: $userid, token: $token)';
  }

  @override
  bool operator ==(covariant DedupeRequest other) {
    if (identical(this, other)) return true;

    return other.panCard == panCard &&
        other.aadharCard == aadharCard &&
        other.uaadhar == uaadhar &&
        other.gst == gst &&
        other.mobileno == mobileno &&
        other.vertical == vertical &&
        other.userid == userid &&
        other.token == token;
  }

  @override
  int get hashCode {
    return panCard.hashCode ^
        aadharCard.hashCode ^
        uaadhar.hashCode ^
        gst.hashCode ^
        mobileno.hashCode ^
        vertical.hashCode ^
        userid.hashCode ^
        token.hashCode;
  }
}
