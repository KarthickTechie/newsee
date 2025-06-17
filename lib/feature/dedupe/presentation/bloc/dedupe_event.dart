/* 
@author    :  ganeshkumar.b 04/06/2025
@desc      :  Event Registers for Dedupe Search feature
@param     :  Pass Dedupe Reqest for Fetching Event
 */

part of 'dedupe_bloc.dart';

class DedupeEvent {}

class FetchDedupeEvent extends DedupeEvent {
  DedupeRequest request;
  final String constitution;
  FetchDedupeEvent({required this.request, required this.constitution});    
}

class ValiateAadharEvent extends DedupeEvent {
  final AadharvalidateRequest request;
  ValiateAadharEvent({required this.request});
}

class SearchCifEvent extends DedupeEvent {
  final CIFRequest request;
  final String constitution;
  SearchCifEvent({required this.request, required this.constitution});
}
