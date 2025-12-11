// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CropDetailsResponse extends Equatable {
  Map<String, dynamic>? responseData;
  String? ErrorMessage;
  bool? Success;
  CropDetailsResponse({this.responseData, this.ErrorMessage, this.Success});

  CropDetailsResponse copyWith({
    Map<String, dynamic>? responseData,
    String? ErrorMessage,
    bool? Success,
  }) {
    return CropDetailsResponse(
      responseData: responseData ?? this.responseData,
      ErrorMessage: ErrorMessage ?? this.ErrorMessage,
      Success: Success ?? this.Success,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'responseData': responseData,
      'ErrorMessage': ErrorMessage,
      'Success': Success,
    };
  }

  factory CropDetailsResponse.fromMap(Map<String, dynamic> map) {
    return CropDetailsResponse(
      responseData:
          map['responseData'] != null
              ? Map<String, dynamic>.from(
                (map['responseData'] as Map<String, dynamic>),
              )
              : null,
      ErrorMessage:
          map['ErrorMessage'] != null ? map['ErrorMessage'] as String : null,
      Success: map['Success'] != null ? map['Success'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropDetailsResponse.fromJson(String source) =>
      CropDetailsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [responseData, ErrorMessage, Success];
}
