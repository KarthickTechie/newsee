// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
  @desc     :   state object to keep salary map object extracted from ocr
*/



import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_constants.dart';

class PayslipState extends Equatable {

  final Map<String, dynamic> payslipData;
  final SaveStatus? saveStatus;
  PayslipState( { required this.payslipData , required this.saveStatus});
   
  @override
  // TODO: implement props
  List<Object?> get props => [payslipData,saveStatus];


  factory PayslipState.initial() {
    return PayslipState(
      payslipData: const {},
      saveStatus: SaveStatus.init,
    );
  }
  

  PayslipState copyWith({
    Map<String, dynamic>? payslipData,
    SaveStatus? saveStatus,
  }) {
    return PayslipState(
     payslipData:  payslipData ?? this.payslipData, saveStatus: saveStatus ?? this.saveStatus, 
    );
  }
}
