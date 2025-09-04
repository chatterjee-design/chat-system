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
    return InkWell(
      onTap: isRecording ? onRecordStop : onRecordStart,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isRecording ? 10 : 8.0,
          vertical: isRecording ? 10 : 8,
        ),
        // padding: EdgeInsets.all(isRecording ? 10 : 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.transparent,
          // border: isRecording
          //     ? Border.all(
          //         color: isRecording
          //             ? Theme.of(context).colorScheme.secondary
          //             : Colors.black54,
          //         width: 2,
          //       )
          // : null,
        ),
        child: Icon(
          isRecording ? Icons.stop : Icons.mic,
          color: isRecording
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondary,

          size: 26,
        ),
      ),
    );
  }
}
