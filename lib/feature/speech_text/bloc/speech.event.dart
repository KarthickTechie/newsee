abstract class SpeechEvent {}

class StartListening extends SpeechEvent {}

class StopListening extends SpeechEvent {}

class RecognizedTextChanged extends SpeechEvent {
  final String text;
  RecognizedTextChanged(this.text);
}
