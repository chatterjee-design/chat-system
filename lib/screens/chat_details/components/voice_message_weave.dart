import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceMessageWidget extends StatefulWidget {
  final String filePath;
  final VoidCallback onDelete;

  const VoiceMessageWidget({
    super.key,
    required this.filePath,
    required this.onDelete,
  });

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration totalDuration = Duration.zero;

  late List<double> waveform;

  @override
  void initState() {
    super.initState();

    // Generate random waveform data for demo
    final rnd = Random();
    waveform = List.generate(50, (_) => rnd.nextDouble() * 0.9 + 0.1);

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => totalDuration = d);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  Future<void> _togglePlayPause() async {
    print('object');
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.filePath));
      setState(() => isPlaying = true);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = totalDuration.inMilliseconds == 0
        ? 0
        : position.inMilliseconds / totalDuration.inMilliseconds;

    return Row(
      children: [
        InkWell(
          onTap: () => widget.onDelete(),
          child: Icon(
            Icons.delete_outline_outlined,
            size: 30,
            weight: 100,
            color: Colors.red,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            // width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.white,
            ),

            // color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _togglePlayPause(),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    weight: 100,
                    color: Colors.teal,
                  ),
                ),

                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width * 0.42, 22),
                  painter: BoldProgressWaveformPainter(
                    waveform: waveform,
                    progress: progress,
                    playedColor: Colors.teal.shade800,
                    unplayedColor: Colors.teal.shade200,
                  ),
                ),
                SizedBox(width: 8),
                // Show total duration
                Text(
                  _formatDuration(totalDuration),
                  style: TextStyle(
                    color: Colors.black,
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

class BoldProgressWaveformPainter extends CustomPainter {
  final List<double> waveform;
  final double progress;
  final Color playedColor;
  final Color unplayedColor;

  BoldProgressWaveformPainter({
    required this.waveform,
    required this.progress,
    required this.playedColor,
    required this.unplayedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / waveform.length;
    final playedPaint = Paint()
      ..color = playedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    final unplayedPaint = Paint()
      ..color = unplayedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    for (int i = 0; i < waveform.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final barHeight = waveform[i] * size.height;
      final isActive = i / waveform.length <= progress;

      canvas.drawLine(
        Offset(x, (size.height - barHeight) / 2),
        Offset(x, (size.height + barHeight) / 2),
        isActive ? playedPaint : unplayedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
