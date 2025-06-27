part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent {
  const LandHoldingEvent();
}

class LandHoldingInitEvent extends LandHoldingEvent {}

class LandDetailsSaveEvent extends LandHoldingEvent {
  final Map<String, dynamic> landData;

  const LandDetailsSaveEvent({required this.landData});
}

class LandDetailsLoadEvent extends LandHoldingEvent {
  final LandData landData;

  const LandDetailsLoadEvent({required this.landData});
}

class OnStateCityChangeEvent extends LandHoldingEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}
