
import 'package:equatable/equatable.dart';
enum PoultryDetailsStatus {
  init, 
  loading,  
  success,  
  failure,  
}

class PoultryState extends Equatable {
  final List<Map<String, dynamic>> addedDetails;
  final PoultryDetailsStatus status;
    final String? error;


   PoultryState({required this.addedDetails,this.status = PoultryDetailsStatus.init,this.error,

});

  factory PoultryState.initial() =>  PoultryState(addedDetails: [],
);

  PoultryState copyWith({List<Map<String, dynamic>>? addedDetails,    String? error,PoultryDetailsStatus? status,

}) {
    return PoultryState(
      addedDetails: addedDetails ?? this.addedDetails,
      status: status ?? this.status,
      error: error,


    );
  }

  @override
  List<Object?> get props => [addedDetails,status, error];
}
