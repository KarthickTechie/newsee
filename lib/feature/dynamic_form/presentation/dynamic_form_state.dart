import 'package:equatable/equatable.dart';

enum DynamicFormstatus {init, loading, success, failure, delete}

class DynamicFormState extends Equatable {
  final DynamicFormstatus ?status ;
  final List<Map<String,dynamic>> addDetails;
  final String? errorMessage;
  
  DynamicFormState({this.status,required this.addDetails,this.errorMessage});

  DynamicFormState copyWith({
    DynamicFormstatus?status,
    List<Map<String,dynamic>>? addDetails,
    String ?errorMessage, 
  }){
    return DynamicFormState(addDetails: addDetails??this.addDetails,status: status??this.status, errorMessage: errorMessage??errorMessage);
  }

factory DynamicFormState.init()=> DynamicFormState(addDetails:[],status: DynamicFormstatus.init,errorMessage: '' );

  @override
  List<Object?> get props =>[status,addDetails,errorMessage];}
  
