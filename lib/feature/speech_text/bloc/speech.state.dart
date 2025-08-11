import 'package:equatable/equatable.dart';

class SpeechState extends Equatable {
  final String recognizedText;
  final String? error;
  final bool isListening;

  const SpeechState({
    required this.recognizedText,
    this.error,
    required this.isListening,
  });

  @override
  List<Object?> get props => [recognizedText, error, isListening];

  SpeechState copyWith({
    String? recognizedText,
    String? error,
    bool? isListening,
  }) {
    return SpeechState(
      recognizedText: recognizedText ?? this.recognizedText,
      error: error ?? this.error,
      isListening: isListening ?? this.isListening,
    );
  }
}
