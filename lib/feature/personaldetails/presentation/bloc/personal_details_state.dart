// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:json_annotation/json_annotation.dart';

// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/* 
@author   : karthick.d  10/06/2025
@desc     : state for PersonalDetails and lov masters
 */
part of 'personal_details_bloc.dart';

/* 

 */
enum SaveStatus { init, loading, success, failure }

class PersonalDetailsState extends Equatable {
  final List<Lov>? lovList;
  final AadharvalidateResponse? aadhaarData;
  final PersonalData? personalData;
  final SaveStatus? status;
  PersonalDetailsState({
    required this.lovList,
    this.aadhaarData,
    required this.personalData,
    required this.status,
  });

  factory PersonalDetailsState.init() => PersonalDetailsState(
    lovList: [],
    personalData: null,
    status: SaveStatus.init,
  );

  @override
  List<Object?> get props => [lovList, aadhaarData, personalData, status];

  PersonalDetailsState copyWith({
    List<Lov>? lovList,
    AadharvalidateResponse? aadhaarData,
    PersonalData? personalData,
    SaveStatus? status,
  }) {
    return PersonalDetailsState(
      lovList: lovList ?? this.lovList,
      aadhaarData: aadhaarData ?? this.aadhaarData,
      personalData: personalData ?? this.personalData,
      status: status ?? this.status,
    );
  }
}
