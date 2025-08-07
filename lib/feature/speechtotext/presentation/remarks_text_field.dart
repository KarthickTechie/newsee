import 'package:flutter/material.dart';
import 'package:newsee/feature/speechtotext/presentation/utils.dart';

class RemarksTextField extends StatefulWidget {
  const RemarksTextField({super.key});

  @override
  State<RemarksTextField> createState() => _RemarksTextFieldState();
}

class _RemarksTextFieldState extends State<RemarksTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SpeechService().isListening,
      builder: (context, isListening, _) {
        return TextFormField(
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Remarks',
            hintText: 'Enter any remarks or notes here...',
            border: const OutlineInputBorder(),
            suffixIcon: GestureDetector(
              onTap: () {
                SpeechService().toggleListening((text) {
                  _controller.text = text;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isListening ? Colors.green : Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isListening ? Icons.graphic_eq : Icons.mic_none,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
