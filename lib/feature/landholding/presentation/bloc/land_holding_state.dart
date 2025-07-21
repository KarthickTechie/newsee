// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'land_holding_bloc.dart';

class LandHoldingState extends Equatable {
  final SaveStatus? status;
  final List<Lov>? lovlist;
  final List<LandData>? landData;
  String? errorMessage;
  final LandData? selectedLandData;
  final List<GeographyMaster>? stateCityMaster;
  final List<GeographyMaster>? districtMaster;
  final List<GeographyMaster>? cityMaster;

  LandHoldingState({
    required this.status,
    required this.lovlist,
    required this.landData,
    required this.errorMessage,
    required this.selectedLandData,
    required this.stateCityMaster,
    required this.cityMaster,
    required this.districtMaster,
  });

  LandHoldingState copyWith({
    SaveStatus? status,
    List<Lov>? lovlist,
    List<LandData>? landData,
    String? errorMessage,
    LandData? selectedLandData,
    List<GeographyMaster>? stateCityMaster,
    List<GeographyMaster>? cityMaster,
    List<GeographyMaster>? districtMaster,
  }) {
    return LandHoldingState(
      status: status ?? this.status,
      lovlist: lovlist ?? this.lovlist,
      landData: landData ?? this.landData,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLandData: selectedLandData ?? this.selectedLandData,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
      cityMaster: cityMaster ?? this.cityMaster,
      districtMaster: districtMaster ?? this.districtMaster,
    );
  }

  factory LandHoldingState.init() => LandHoldingState(
    status: SaveStatus.init,
    lovlist: [],
    landData: [],
    errorMessage: null,
    selectedLandData: null,
    stateCityMaster: [],
    cityMaster: [],
    districtMaster: [],
  );

  @override
  List<Object?> get props => [
    status,
    lovlist,
    landData,
    errorMessage,
    selectedLandData,
    stateCityMaster,
    cityMaster,
    districtMaster,
  ];
}
