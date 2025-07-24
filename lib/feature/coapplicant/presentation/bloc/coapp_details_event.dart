/* 
@author   :   karthick.d  20/06/2025
@desc     :   CoAppDetailsInitEvent - set lov's for dropdowns
              CoAppDetailsSaveEvent - save coappdetails form

 */

part of 'coapp_details_bloc.dart';

abstract class CoappDetailsEvent {}

// this event will set lov , geography data to dropdown

class CoAppDetailsInitEvent extends CoappDetailsEvent {}

// this event will fetch coapp details from cif or dedupe
// set CoapplicantData from dedupe response and update coapplicant data state
class CoAppDetailsDedupeEvent extends CoappDetailsEvent {
  final AadharvalidateResponse coapplicantData;
  CoAppDetailsDedupeEvent({required this.coapplicantData});
}

// this event will save coapp details from form

class CoAppDetailsSaveEvent extends CoappDetailsEvent {
  final CoapplicantData coapplicantData;
  // final bool isEdit;
  final int? index;
  CoAppDetailsSaveEvent({
    required this.coapplicantData,
    // this.isEdit = false,
    this.index,
  });
}

class OnStateCityChangeEvent extends CoappDetailsEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}

class CoAppGurantorSearchCifEvent extends CoappDetailsEvent {
  final CIFRequest request;
  CoAppGurantorSearchCifEvent({required this.request});
}

class IsCoAppOrGurantorAdd extends CoappDetailsEvent {
  final String? addapplicants;
  IsCoAppOrGurantorAdd({required this.addapplicants});
}

class DeleteCoApplicantEvent extends CoappDetailsEvent {
  final CoapplicantData coapplicantData;

  DeleteCoApplicantEvent(this.coapplicantData);

  @override
  List<Object?> get props => [coapplicantData];
}

class CifEditManuallyEvent extends CoappDetailsEvent {
  final bool cifButton;
  CifEditManuallyEvent(this.cifButton);
}

class AadhaarValidateEvent extends CoappDetailsEvent {
  final AadharvalidateRequest request;
  AadhaarValidateEvent({required this.request});
}

class ScannerResponseEvent extends CoappDetailsEvent {
  final Map<String, dynamic> scannerResponse;
  ScannerResponseEvent({required this.scannerResponse});
}
