// ignore_for_file: public_member_api_docs, sort_constructors_first
part of './address_details_bloc.dart';

enum SaveStatus { init, loading, copy, permanentsave, presenttreset, success, failure, mastersucess }

class AddressDetailsState extends Equatable {
  final List<Lov>? lovList;
  final List<GeographyMaster>? stateCityMaster;
  final List<GeographyMaster>? cityMaster;
  final List<GeographyMaster>? districtMaster;
  final AddressData? addressData;
  final List<GeographyMaster>? presentCityMaster;
  final List<GeographyMaster>? presentDistrictMaster;
  final AddressData? presentAddrData;
  final SaveStatus? status;
  String? formname;

  AddressDetailsState({
    required this.addressData,
    required this.lovList,
    required this.stateCityMaster,
    required this.cityMaster,
    required this.districtMaster,
    required this.status,
    required this.presentAddrData,
    required this.presentCityMaster,
    required this.presentDistrictMaster,
    this.formname,
  });

  AddressDetailsState copyWith({
    List<Lov>? lovList,
    AddressData? addressData,
    SaveStatus? status,
    List<GeographyMaster>? stateCityMaster,
    List<GeographyMaster>? cityMaster,
    List<GeographyMaster>? districtMaster,
    AddressData? presentAddrData,
    List<GeographyMaster>? presentCityMaster,
    List<GeographyMaster>? presentDistrictMaster,
    String? formname,
  }) {
    return AddressDetailsState(
      lovList: lovList ?? this.lovList,
      addressData: addressData ?? this.addressData,
      status: status ?? this.status,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
      cityMaster: cityMaster ?? this.cityMaster,
      districtMaster: districtMaster ?? this.districtMaster,
      presentAddrData: presentAddrData ?? this.presentAddrData,
      presentCityMaster: presentCityMaster ?? this.presentCityMaster,
      presentDistrictMaster: presentDistrictMaster ?? this.presentDistrictMaster,
      formname: formname ?? this.formname
    );
  }

  factory AddressDetailsState.init() => AddressDetailsState(
    addressData: null,
    status: SaveStatus.init,
    lovList: [],
    stateCityMaster: [],
    cityMaster: [],
    districtMaster: [],
    presentAddrData: null,
    presentCityMaster: [],
    presentDistrictMaster: [],
    formname: null
  );

  @override
  List<Object?> get props => [
    lovList,
    addressData,
    status,
    stateCityMaster,
    cityMaster,
    districtMaster,
    presentAddrData,
    presentCityMaster,
    presentDistrictMaster,
    formname
  ];

  
}
