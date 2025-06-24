// import 'dart:convert';

// class LandHoldingRequest {
//   String userid;
//   String? token;

//   LandHoldingRequest({required this.userid, this.token});

//   LandHoldingRequest copyWith({String? userid, String? token}) {
//     return LandHoldingRequest(
//       userid: userid ?? this.userid,
//       token: token ?? this.token,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'userid': userid, 'token': token};
//   }

//   factory LandHoldingRequest.fromMap(Map<String, dynamic> map) {
//     return LandHoldingRequest(
//       userid: map['userid'] as String,
//       token: map['token'] as String?,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory LandHoldingRequest.fromJson(String source) =>
//       LandHoldingRequest.fromMap(json.decode(source));
// }
