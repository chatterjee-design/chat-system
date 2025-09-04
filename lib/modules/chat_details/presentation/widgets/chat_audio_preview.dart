import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/extension.dart';
import '../../../../core/utils/file_icon_and_name.dart';
import '../../../../core/font/app_font.dart';
import '../../../../provider/chat_details_provider.dart';

class ChatAudioPreview extends StatelessWidget {
  ChatAudioPreview({
    super.key,
    // required this.filePath,
    required this.chat,
  });

  // final String filePath;
  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    final filePath = chat.audioFile?.path;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () async {
              // Open custom audio player screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AudioPlayerScreen(filePath: filePath),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.audiotrack, size: 30, color: Colors.blue),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      getFileName(filePath!),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appText(size: 13, weight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Close button
          Positioned(
            top: -12,
            right: -10,
            child: InkWell(
              onTap: () => chat.removeFile(FileCategory.audio),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 6,
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/materia

class AudioPlayerScreen extends StatefulWidget {
  final String filePath;
  const AudioPlayerScreen({super.key, required this.filePath});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  double speed = 1.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    await _player.setSource(DeviceFileSource(widget.filePath));

    _player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    _player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _player.onPlayerComplete.listen((_) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _seekBy(Duration offset) async {
    final newPos = position + offset;
    await _player.seek(
      newPos < Duration.zero
          ? Duration.zero
          : (newPos > duration ? duration : newPos),
    );
  }

  void _toggleSpeed() {
    if (speed == 1.0) {
      speed = 1.5;
    } else if (speed == 1.5) {
      speed = 2.0;
    } else {
      speed = 1.0;
    }
    _player.setPlaybackRate(speed);
    setState(() {});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.filePath.split('/').last,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.headphones, size: 120, color: Colors.white70),

          const SizedBox(height: 30),

          // Slider
          Slider(
            value: duration.inSeconds > 0
                ? position.inSeconds.clamp(0, duration.inSeconds).toDouble()
                : 0.0,
            max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
            onChanged: (value) async {
              final newPos = Duration(seconds: value.toInt());
              await _player.seek(newPos);
              setState(() => position = newPos);
            },
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
          // Duration text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
              IconButton(
                iconSize: 36,
                icon: const Icon(Icons.replay_10, color: Colors.white),
                onPressed: () => _seekBy(const Duration(seconds: -10)),
              ),

              // Play / Pause
              IconButton(
                iconSize: 64,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                ),
                onPressed: _togglePlayPause,
              ),

              // Forward 10s
              IconButton(
                iconSize: 36,
                icon: const Icon(Icons.forward_10, color: Colors.white),
                onPressed: () => _seekBy(const Duration(seconds: 10)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Speed control
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _toggleSpeed,
            child: Text(
              "${speed}x",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
