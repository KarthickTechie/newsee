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
  final CoapplicantData coapplicantData;
  CoAppDetailsDedupeEvent({required this.coapplicantData});
}

// this event will save coapp details from form

class CoAppDetailsSaveEvent extends CoappDetailsEvent {
  final CoapplicantData coapplicantData;
  CoAppDetailsSaveEvent({required this.coapplicantData});
}

class OnStateCityChangeEvent extends CoappDetailsEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}

class SearchCifEvent extends CoappDetailsEvent {
  final CIFRequest request;
  SearchCifEvent({required this.request});
}
