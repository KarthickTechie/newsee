/* 
@author     : gayatrhi  04/06/2025
@desc       : State Object for CIF Search
@param      : {CifStatus status} - enum for Fetch status 
              {String errorMessage} - error message when service failure
              {CifResponseModel cifResponseModel} - return CifResponseModel
 */

part of 'cif_bloc.dart';

// we need following state status which is defines http init , loading
// success and failure

enum CifStatus { initial, loading, success, failure }

class CifState extends Equatable {
  final CifStatus? status;
  final CifResponseModel? cifResponseModel;
  final String? errorMessage;

  // private constructor for instance initialisation
  const CifState({this.status, this.cifResponseModel, this.errorMessage});

  factory CifState.init() => const CifState(status: CifStatus.initial);
  // setting state of instance variable On CifEvents

  CifState copyWith({
    CifStatus? status,
    CifResponseModel? cifResponseModel,
    String? errorMessage,
  }) {
    return CifState(
      status: status ?? this.status,
      cifResponseModel: cifResponseModel ?? this.cifResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cifResponseModel, errorMessage];
}
