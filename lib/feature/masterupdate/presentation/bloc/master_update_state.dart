// ignore_for_file: public_member_api_docs, sort_constructors_first

/* 
@author     : karthick.d  23/05/2025
@desc       : State Object for Master Download
@param      : {MasterdownloadStatus status} - enum for download serice status 
              {String errorMsg} - error message when service failure
              {MasterResponse<T> response} - return MasterResponse<T>
                T - Lov | InterestMaster | ProductMaster | DocumentMaster etc
 */

part of 'master_update_bloc.dart';


final class MasterUpdateState extends Equatable {
  final SaveStatus? status;
  final bool masterDifferent;
  final List<MasterVersion>? listOfMaster;
  final String? errorMessage;
  MasterUpdateState({
    this.status,
    this.masterDifferent = false,
    this.listOfMaster,
    this.errorMessage
  });

  MasterUpdateState copyWith({
    SaveStatus? status,
    bool? masterDifferent,
    List<MasterVersion>? listOfMaster,
    String? errorMessage
  }) {
    return MasterUpdateState(
      status: status ?? this.status,
      masterDifferent: masterDifferent ?? this.masterDifferent,
      listOfMaster: listOfMaster ?? this.listOfMaster,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

   factory MasterUpdateState.init() => MasterUpdateState(
    status: SaveStatus.init,
    masterDifferent: false,
    listOfMaster: [],
    errorMessage: null
  );

  @override
  List<Object?> get props => [status, masterDifferent, listOfMaster, errorMessage];
}
