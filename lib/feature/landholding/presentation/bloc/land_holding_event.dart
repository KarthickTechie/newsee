part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent {
  const LandHoldingEvent();
}

class LandHoldingInitEvent extends LandHoldingEvent {
  final String proposalNumber;
  final String custId;
  LandHoldingInitEvent({required this.proposalNumber, required this.custId});
}

class LandDetailsSaveEvent extends LandHoldingEvent {
  final String proposalNumber;
  final Map<String, dynamic> landData;
  final String custId;
  final List<Map<String, dynamic>>? polygonData;
  const LandDetailsSaveEvent({
    required this.proposalNumber,
    this.polygonData,
    required this.custId,
    required this.landData,
  });
}

class LandDetailsLoadEvent extends LandHoldingEvent {
  final LandData landData;
  const LandDetailsLoadEvent({required this.landData});
}

class LandDetailsDeleteEvent extends LandHoldingEvent {
  final LandData landData;
  final String custId;
  final int index;
  const LandDetailsDeleteEvent({
    required this.index,
    required this.landData,
    required this.custId,
  });
}

class OnStateCityChangeEvent extends LandHoldingEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}

class RBIHDetailsLoadEvent extends LandHoldingEvent {
  final Map<String, dynamic>? rbihFormData;
  const RBIHDetailsLoadEvent({this.rbihFormData});
}
