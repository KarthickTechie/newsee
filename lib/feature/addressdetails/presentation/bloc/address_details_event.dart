/* 
@author   : karthick.d  10/06/2025
@desc     : bloc events for saving updating address details page
@param    : 
 */

part of 'address_details_bloc.dart';

abstract class AddressDetailsEvent {}

class AddressDetailsInitEvent extends AddressDetailsEvent {
  final CifResponseModel? cifResponseModel;
  AddressDetailsInitEvent({required this.cifResponseModel});
}

class AddressDetailsSaveEvent extends AddressDetailsEvent {
  final AddressData? addressData;
  AddressDetailsSaveEvent({required this.addressData});
}

class OnStateCityChangeEvent extends AddressDetailsEvent {
  final String stateCode;
  final String? cityCode;
  OnStateCityChangeEvent({required this.stateCode, this.cityCode});
}

class OnPresentStateCityChangeEvent extends AddressDetailsEvent {
  final String stateCode;
  final String? cityCode;
  OnPresentStateCityChangeEvent({required this.stateCode, this.cityCode});
}

class PresentAddressDetailsSaveEvent extends AddressDetailsEvent {
  final AddressData? presentaddressData;
  PresentAddressDetailsSaveEvent({required this.presentaddressData});
}

class SameAsPermanentInPresentEvent extends AddressDetailsEvent {
  final bool? sameAspresent;
  SameAsPermanentInPresentEvent({this.sameAspresent});
}

// class OnCityChangeEvent<T> extends AddressDetailsEvent {
//   final T stateCode;
//   final T cityCode;
//   OnCityChangeEvent({required this.stateCode, required this.cityCode});
// }
