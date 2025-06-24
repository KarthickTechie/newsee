/* 
@author    :  gayathri 04/06/2025
@desc      :  Event Registers for CIF Search feature
@param     :  Pass CIF Reqest for Fetching Event
 */

part of 'cif_bloc.dart';

//create abstract class event extends Equatable

abstract class CifEvent {
  const CifEvent();
}

//Trigger First Event SearchCif

class SearchingCifEvent extends CifEvent {
  final CIFRequest request;
  const SearchingCifEvent({required this.request});
}
