/* 
@author    :  ganeshkumar.b 04/06/2025
@desc      :  Event Registers for Dedupe Search feature
@param     :  Pass Dedupe Reqest for Fetching Event
 */

part of 'dedupe_bloc.dart';

class DedupeEvent {}

class FetchDedupeEvent extends DedupeEvent {
  DedupeRequest request;
  FetchDedupeEvent({required this.request});    
}

class ValiateAadharEvent extends DedupeEvent {
  final AadharvalidateRequest request;
  ValiateAadharEvent({required this.request});
}

class SearchCifEvent extends DedupeEvent {
  final CIFRequest request;
  SearchCifEvent({required this.request});
}

class OpenSheetEvent extends DedupeEvent {
  final Map<String, dynamic>  request;
  OpenSheetEvent({required this.request});
}