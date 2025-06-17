import 'package:equatable/equatable.dart';

class GlobalLoadingState extends Equatable {
  final bool isLoading;
  final String message;
  GlobalLoadingState({required this.isLoading, required this.message});

  @override
  List<Object> get props => [isLoading, message];

  GlobalLoadingState copyWith({bool? isLoading, String? message}) {
    return GlobalLoadingState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
