import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chat_system/screens/chat_details/components/voice_message_weave.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../audio_rec.dart';
import 'show_emojie_picker.dart';
import 'voice_rec_button.dart';

class ChatInputBar extends StatefulWidget {
  final Function scrollToBottom;
  const ChatInputBar({super.key, required this.scrollToBottom});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool hasText = false;
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  // final AudioPlayer _audioPlayer = AudioPlayer();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;

  List<double> waveform = [];
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await _recorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        waveform.clear();
        _recordedFilePath = path;
      });

      // Listen to amplitude changes for real-time waveform
      _amplitudeSubscription = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
            final normalized = (amp.current + 45) / 45;
            setState(() {
              waveform.add(max(0, min(normalized, 1)));
              if (waveform.length > 100) waveform.removeAt(0);
            });
          });
    }
  }

  Future<String?> _stopRecording() async {
    final path = await _recorder.stop();
    await _amplitudeSubscription?.cancel();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });
    return path;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        hasText = _controller.text.trim().isNotEmpty;
      });
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus && showEmojiPicker) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    _recorder.dispose();
    _amplitudeSubscription?.cancel();
    super.dispose();
  }

  void sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      _controller.clear();
      widget.scrollToBottom();
    }
  }

  void _toggleEmojiPicker(BuildContext context) {
    if (showEmojiPicker) {
      Navigator.of(context).pop();
      setState(() {
        showEmojiPicker = false;
      });
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
      setState(() {
        showEmojiPicker = true;
      });
      showEmojiPickerBottomSheet(context, _controller).whenComplete(() {
        setState(() {
          showEmojiPicker = false;
        });
        focusNode.requestFocus();
      });
    }
  }

  Future<void> pickImageFromGalary() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 13),
      color: _recordedFilePath != null
          ? const Color.fromARGB(136, 193, 206, 215)
          : Colors.transparent,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          // decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_recordedFilePath == null)
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.teal,
                  ),
                  onPressed: () {},
                ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isRecording
                      ? RecordingWaveformWidget(
                          isRecording: _isRecording,
                          waveForm: waveform,
                          onDelete: () {},
                        )
                      : _recordedFilePath != null
                      ? VoiceMessageWidget(
                          key: const ValueKey('voice_message'),
                          // isRecording: _isRecording,
                          // waveForm: waveform,
                          filePath: _recordedFilePath!,
                          onDelete: () {
                            setState(() => _recordedFilePath = null);
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  TextField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Type a message...',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                        right: _image == null ? 22 : 22,
                                        left: _image == null ? 0 : 4,
                                        top: _image == null ? 0 : 4,
                                        bottom: _image == null ? 0 : 4,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () => _toggleEmojiPicker(context),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: _image == null ? 0 : 5,
                                        ),
                                        child: Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (_image != null) ...[
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 114,
                                  width: 114,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            File(_image!.path),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => _image = null),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4,
                                              ),
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                  // your existing input field
                ),
              ),

              const SizedBox(width: 8),

              // Show send button if we have text or voice message,
              // else show image picker + record buttons (only if no voice message recorded)
              _isRecording
                  ? RecordButton(
                      isRecording: true,
                      onRecordStart: () async {
                        setState(() {
                          _isRecording = true;
                          _recordedFilePath = null;
                        });
                        await _startRecording();
                      },
                      onRecordStop: () async {
                        final path = await _stopRecording();
                        setState(() {
                          _isRecording = false;
                          _recordedFilePath = path;
                        });
                      },
                    )
                  : (_recordedFilePath != null || hasText)
                  ? InkWell(
                      onTap: () => sendMessage(),
                      child: const Icon(Icons.send, color: Colors.black),
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.image_outlined,
                            color: Colors.teal,
                          ),
                          onPressed: pickImageFromGalary,
                        ),
                        RecordButton(
                          isRecording: false,
                          onRecordStart: () async {
                            setState(() {
                              _isRecording = true;
                              _recordedFilePath = null;
                            });
                            await _startRecording();
                          },
                          onRecordStop: () async {
                            final path = await _stopRecording();
                            setState(() {
                              _isRecording = false;
                              _recordedFilePath = path;
                            });
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
