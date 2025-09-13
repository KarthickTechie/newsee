import 'package:equatable/equatable.dart';

enum DairyDetailsStatus {
  init, 
  loading,  
  success,  
  failure,  
}

class DairyDetailsState extends Equatable {
  final List<Map<String, dynamic>> addedDetails;

  final DairyDetailsStatus status;

  final String? error;

  const DairyDetailsState({
    required this.addedDetails,
    this.status = DairyDetailsStatus.init,
    this.error,
  });

  // Factory constructor for the initial state.
  factory DairyDetailsState.initial() =>
      const DairyDetailsState(addedDetails: []);

  // Returns a new state with updated values.
  DairyDetailsState copyWith({
    List<Map<String, dynamic>>? addedDetails,
    DairyDetailsStatus? status,
    String? error,
  }) {
    return DairyDetailsState(
      addedDetails: addedDetails ?? this.addedDetails,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [addedDetails, status, error];
}
