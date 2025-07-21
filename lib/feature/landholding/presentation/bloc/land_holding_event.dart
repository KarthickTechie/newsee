part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent {
  const LandHoldingEvent();
}

class LandHoldingInitEvent extends LandHoldingEvent {
  final String proposalNumber;
  LandHoldingInitEvent({required this.proposalNumber});
}

class LandDetailsSaveEvent extends LandHoldingEvent {
  final String proposalNumber;
  final Map<String, dynamic> landData;
  const LandDetailsSaveEvent({required this.proposalNumber, required this.landData});
}

class LandDetailsLoadEvent extends LandHoldingEvent {
  final LandData landData;
  const LandDetailsLoadEvent({ required this.landData});
}

class LandDetailsDeleteEvent extends LandHoldingEvent {
  final LandData landData;
  final int index;
  const LandDetailsDeleteEvent({required this.index, required this.landData});
}

class OnStateCityChangeEvent extends LandHoldingEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}