import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;

  const RecordButton({
    super.key,
    required this.isRecording,
    required this.onRecordStart,
    required this.onRecordStop,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRecording ? Colors.red.withOpacity(0.2) : Colors.transparent,
        boxShadow: isRecording
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ]
            : [],
      ),
      child: GestureDetector(
        onLongPress: onRecordStart,
        onLongPressUp: onRecordStop,
        child: Icon(
          isRecording ? Icons.mic : Icons.mic_none,
          color: isRecording ? Colors.red : Colors.black,
          size: 32,
        ),
      ),
    );
  }
}
