import 'dart:async';
import 'package:flutter/material.dart';

class RecordingWaveformWidget extends StatefulWidget {
  final bool isRecording;
  final List<double> waveForm;
  final VoidCallback onDelete;

  const RecordingWaveformWidget({
    super.key,
    required this.isRecording,
    required this.waveForm,
    required this.onDelete,
  });

  @override
  State<RecordingWaveformWidget> createState() =>
      _RecordingWaveformWidgetState();
}

class _RecordingWaveformWidgetState extends State<RecordingWaveformWidget> {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isRecording) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant RecordingWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && _timer == null) {
      _startTimer();
    } else if (!widget.isRecording && _timer != null) {
      _stopTimer();
    }

    // Auto-scroll to the start since reverse = true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _stopTimer();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waveformWidth = widget.waveForm.length * 6;

    return Row(
      children: [
        InkWell(
          onTap: widget.onDelete,
          child: Icon(
            Icons.delete_outline_outlined,
            size: 30,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: CustomPaint(
                      size: Size(waveformWidth.toDouble(), 22),
                      painter: WaveformPainter(
                        waveform: widget.waveForm,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _formatDuration(_elapsed),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveform;
  final Color color;
  WaveformPainter({required this.waveform, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / (waveform.isNotEmpty ? waveform.length : 1);
    final midY = size.height / 2;

    for (int i = 0; i < waveform.length; i++) {
      final x = i * barWidth;
      final barHeight = waveform[i] * size.height;
      canvas.drawLine(
        Offset(x, midY - barHeight / 2),
        Offset(x, midY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
