// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'field_investigation_bloc.dart';

class FieldInvestigationState extends Equatable {
  final SaveStatus? status;
  final List<Lov>? lovlist;
  String? errorMessage;
  final List<GeographyMaster>? stateCityMaster;

  FieldInvestigationState({
    required this.status,
    required this.lovlist,
    this.errorMessage,
    required this.stateCityMaster
  });

  FieldInvestigationState copyWith({
    SaveStatus? status,
    List<Lov>? lovlist,
    String? errorMessage,
    List<GeographyMaster>? stateCityMaster,
  }) {
    return FieldInvestigationState(
      status: status ?? this.status,
      lovlist: lovlist ?? this.lovlist,
      errorMessage: errorMessage ?? this.errorMessage,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
    );
  }

  factory FieldInvestigationState.init() => FieldInvestigationState(
    status: SaveStatus.init,
    lovlist: [],
    errorMessage: null,
    stateCityMaster: [],
  );

  @override
  List<Object?> get props => [status, lovlist, errorMessage, stateCityMaster];
}
