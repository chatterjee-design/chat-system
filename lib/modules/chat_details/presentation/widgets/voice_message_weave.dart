import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_waveform/just_waveform.dart';

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

  List<double> waveform = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateWaveform();

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

  Future<void> _generateWaveform() async {
    final audioFile = File(widget.filePath);
    final waveOutFile = File('${audioFile.path}.waveform');

    try {
      final progressStream = JustWaveform.extract(
        audioInFile: audioFile,
        waveOutFile: waveOutFile,
      );

      final waveformData = await progressStream.last;
      final wf = waveformData.waveform;
      if (wf == null) {
        setState(() => isLoading = false);
        return;
      }

      final maxAmp = (wf.flags & 1) == 0 ? 32768.0 : 128.0;

      final samples = List<double>.generate(wf.length, (i) {
        final min = wf.getPixelMin(i).toDouble();
        final max = wf.getPixelMax(i).toDouble();
        return (max.abs() > min.abs() ? max.abs() : min.abs()) / maxAmp;
      });

      // 🔑 Downsample based on container width (fit bars nicely)
      final targetBars = 60; // about WhatsApp-like density
      final simplified = _downsample(samples, targetBars);

      setState(() {
        waveform = simplified;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Waveform generation error: $e");
      setState(() => isLoading = false);
    }
  }

  List<double> _downsample(List<double> data, int targetLength) {
    if (data.isEmpty) return [];
    if (data.length <= targetLength) return data;

    final ratio = data.length / targetLength;
    return List.generate(targetLength, (i) {
      final start = (i * ratio).floor();
      final end = ((i + 1) * ratio).floor().clamp(0, data.length);
      final slice = data.sublist(start, end);
      return slice.reduce((a, b) => a + b) / slice.length;
    });
  }

  Future<void> _togglePlayPause() async {
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
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _togglePlayPause(),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    weight: 100,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                // 🔥 Real waveform painter
                isLoading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 22,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width * 0.42,
                          22,
                        ), // fixed width
                        painter: BoldProgressWaveformPainter(
                          waveform: waveform,
                          progress: progress,
                          playedColor: Theme.of(context).colorScheme.secondary,
                          unplayedColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.4),
                        ),
                      ),

                SizedBox(width: 8),
                Text(
                  _formatDuration(totalDuration),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
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
    if (waveform.isEmpty) return;

    final totalBars = waveform.length;
    final barWidth = size.width / totalBars;

    final playedPaint = Paint()
      ..color = playedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth * 0.8;

    final unplayedPaint = Paint()
      ..color = unplayedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth * 0.8;

    for (int i = 0; i < totalBars; i++) {
      final x = i * barWidth + barWidth / 2;

      final barHeight = (waveform[i] * size.height * 10).clamp(
        4.0,
        size.height,
      );

      final isActive = i / totalBars <= progress;

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
