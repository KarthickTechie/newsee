import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;

  final SpeechToText _speech = SpeechToText();
  final ValueNotifier<bool> isListening = ValueNotifier(false);

  SpeechService._internal();

  Future<void> toggleListening(Function(String) onTextResult) async {
    if (!isListening.value) {
      bool available = await _speech.initialize(
        onStatus: (status) => debugPrint('Status: $status'),
        onError: (error) => debugPrint('Error: $error'),
      );

      if (available) {
        isListening.value = true;
        _speech.listen(
          onResult: (result) {
            onTextResult(result.recognizedWords);
          },
        );
      }
    } else {
      _speech.stop();
      isListening.value = false;
    }
  }
}
