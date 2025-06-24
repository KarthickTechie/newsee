// ignore_for_file: public_member_api_docs, sort_constructors_first
/* 
@author     : karthick.d  20/06/2025
@desc       :  SaveStatus - init,success,update,failure
               List<CoapplicantData> coAppList - conatins all the saved coapp
               CoapplicantData selectedCoApp   - select the coapp from bottomsheet to update the details

 */
part of 'coapp_details_bloc.dart';

class CoappDetailsState extends Equatable {
  final SaveStatus? status;
  final List<CoapplicantData>? coAppList;
  final CoapplicantData? selectedCoApp;
  final List<Lov>? lovList;
  final List<GeographyMaster>? stateCityMaster;
  final List<GeographyMaster>? districtMaster;
  final List<GeographyMaster>? cityMaster;

  CoappDetailsState({
    required this.lovList,
    this.status = SaveStatus.init,
    required this.coAppList,
    required this.selectedCoApp,
    required this.stateCityMaster,
    required this.cityMaster,
    required this.districtMaster,
  });

  factory CoappDetailsState.initial() => CoappDetailsState(
    lovList: [],
    coAppList: [],
    selectedCoApp: null,
    stateCityMaster: [],
    cityMaster: [],
    districtMaster: [],
  );

  CoappDetailsState copyWith({
    List<Lov>? lovList,
    SaveStatus? status,
    List<CoapplicantData>? coAppList,
    CoapplicantData? selectedCoApp,
    List<GeographyMaster>? stateCityMaster,
    List<GeographyMaster>? cityMaster,
    List<GeographyMaster>? districtMaster,
  }) {
    return CoappDetailsState(
      lovList: lovList ?? this.lovList,
      status: status ?? this.status,
      coAppList: coAppList ?? this.coAppList,
      selectedCoApp: selectedCoApp ?? this.selectedCoApp,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
      cityMaster: cityMaster ?? this.cityMaster,
      districtMaster: districtMaster ?? this.districtMaster,
    );
  }

  @override
  List<Object?> get props => [
    status,
    coAppList,
    selectedCoApp,
    lovList,
    stateCityMaster,
    cityMaster,
    districtMaster,
  ];
}
