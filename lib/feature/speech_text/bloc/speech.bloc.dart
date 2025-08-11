import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/speech_text/bloc/speech.event.dart';
import 'package:newsee/feature/speech_text/bloc/speech.state.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final SpeechToText _speech;

  SpeechBloc(this._speech)
    : super(SpeechState(isListening: false, recognizedText: '')) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<RecognizedTextChanged>(_onRecognizedTextChanged);
  }

  void _onRecognizedTextChanged(
    RecognizedTextChanged event,
    Emitter<SpeechState> emit,
  ) {
    emit(state.copyWith(recognizedText: event.text));
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<SpeechState> emit,
  ) async {
    final available = await _speech.initialize(
      onStatus: (val) {
        print('Speech status: $val');
        // if (val == 'done') {
        //   add(StopListening());
        // }
      },
      onError: (val) {
        add(StopListening());
        emit(state.copyWith(error: val.errorMsg));
      },
    );

    if (available) {
      emit(state.copyWith(isListening: true, error: null));

      _speech.listen(
        onResult: (val) {
          final newText = val.recognizedWords;
          print('Speech Result: $newText');
          add(RecognizedTextChanged(newText));
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 8),
        partialResults: true,
        localeId: 'en_IN',
      );
    } else {
      emit(state.copyWith(isListening: false, error: 'Speech unavailable'));
    }
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<SpeechState> emit,
  ) async {
    await _speech.stop();
    emit(state.copyWith(isListening: false));
  }
}
