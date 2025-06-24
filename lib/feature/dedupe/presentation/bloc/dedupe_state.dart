/* 
@author     : ganeshkumar.b  04/06/2025
@desc       : State Object for Dedupe Search
@param      : {DedupeFetchStatus status} - enum for Fetch status 
              {String errorMsg} - error message when service failure
              {DedupeResponse dedupeResponse} - return DedupeResponse
 */

part of 'dedupe_bloc.dart';

enum DedupeFetchStatus { init, loading, change, success, failure }

class DedupeState extends Equatable {
  final DedupeFetchStatus? status;
  final String? errorMsg;
  final DedupeResponse? dedupeResponse;
  final AadharvalidateResponse? aadharvalidateResponse;
  final CifResponse? cifResponse;
  final bool? isNewCustomer;
  final String? constitution;
  final bool? dismissModal;
  DedupeState({
    this.status,
    this.errorMsg,
    this.dedupeResponse,
    this.aadharvalidateResponse,
    this.cifResponse,
    this.isNewCustomer,
    this.constitution,
    this.dismissModal,
  });

  DedupeState copyWith({
    DedupeFetchStatus? status,
    String? errorMsg,
    DedupeResponse? dedupeResponse,
    AadharvalidateResponse? aadharvalidateResponse,
    CifResponse? cifResponse,
    bool? isNewCustomer,
    String? constitution,
    bool? dismissModal,
  }) {
    return DedupeState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      dedupeResponse: dedupeResponse ?? this.dedupeResponse,
      aadharvalidateResponse:
          aadharvalidateResponse ?? this.aadharvalidateResponse,
      cifResponse: cifResponse ?? this.cifResponse,
      isNewCustomer: isNewCustomer ?? this.isNewCustomer,
      constitution: constitution ?? this.constitution,
      dismissModal: dismissModal ?? this.dismissModal,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    status,
    errorMsg,
    dedupeResponse,
    aadharvalidateResponse,
    cifResponse,
    isNewCustomer,
    constitution,
    dismissModal,
  ];
}
