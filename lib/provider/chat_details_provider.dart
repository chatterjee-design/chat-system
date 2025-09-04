import 'dart:async';
import 'dart:developer' as devlog;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';

import '../core/constants/extension.dart';
import '../modules/chat_details/presentation/widgets/show_emojie_picker.dart';

class ChatDetailsProvider with ChangeNotifier {
  ChatDetailsProvider() {
    controller.addListener(() {
      hasText = controller.text.trim().isNotEmpty;
      notifyListeners();
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus && showEmojiPicker) {
        showEmojiPicker = false;
        notifyListeners();
      }
    });
  }

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ImagePicker picker = ImagePicker();
  final AudioRecorder recorder = AudioRecorder();

  bool hasText = false;
  bool showEmojiPicker = false;

  // Files picked from drive
  XFile? image;
  XFile? videoFile;
  XFile? audioFile;
  XFile? documentFile;
  XFile? archiveFile;
  XFile? otherFile;

  //recording
  String? recordedFilePath;
  bool isRecording = false;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  List<double> waveform = [];

  //reply
  double dx = 0.0;
  static const double maxDrag = 120;
  static const double swipeThreshold = 80;
  final Map<int, double> _dxValues = {};
  Map<String, dynamic>? replyingMessage;

  double getDx(int index) => _dxValues[index] ?? 0.0;

  void updateDx(int index, double newDx) {
    _dxValues[index] = newDx.clamp(-maxDrag, maxDrag);
    notifyListeners();
  }

  void snapBack(int index) {
    _dxValues[index] = 0.0;
    notifyListeners();
  }

  void handleHorizontalDragUpdate(
    DragUpdateDetails details,
    bool isSender,
    int index,
  ) {
    double currentDx = getDx(index);

    if (!isSender && details.delta.dx > 0) {
      updateDx(index, currentDx + details.delta.dx);
    } else if (isSender && details.delta.dx < 0) {
      updateDx(index, currentDx + details.delta.dx);
    }
  }

  void handleSwipeEnd({
    required int index,
    required bool isSender,
    required Map<String, dynamic> msg,
  }) {
    double dx = getDx(index);

    if (dx.abs() > swipeThreshold) {
      if (!isSender && dx > 0) {
        setReply(msg);
        // replyingMessage = msg;
      } else if (isSender && dx < 0) {
        setReply(msg);
        // replyingMessage = msg;
      }
    }

    snapBack(index);
  }

  void setReply(Map<String, dynamic> msg) {
    replyingMessage = msg;
    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
      }
    });
  }

  void quoteReply({required Map<String, dynamic> msg}) {
    setReply(msg);

    notifyListeners();
  }

  void clearReply() {
    replyingMessage = null;
    notifyListeners();
    focusNode.unfocus();
  }

  // ---- Recording ----
  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      // devlog.log("rec start has permission");

      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await recorder.start(const RecordConfig(), path: path);
      isRecording = true;
      waveform.clear();
      recordedFilePath = path;
      notifyListeners();

      _amplitudeSubscription = recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
            final normalized = (amp.current + 45) / 45;
            waveform.add(max(0, min(normalized, 1)));
            if (waveform.length > 100) waveform.removeAt(0);
            notifyListeners();
          });
    }
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();
    await _amplitudeSubscription?.cancel();
    isRecording = false;
    recordedFilePath = path;
    notifyListeners();
  }

  void deleteRecording() async {
    if (isRecording == true) {
      await recorder.stop();
      await _amplitudeSubscription?.cancel();
      isRecording = false;
    }

    recordedFilePath = null;
    notifyListeners();
  }

  // ---- Emoji ----
  void toggleEmojiPicker(BuildContext context) {
    if (showEmojiPicker) {
      Navigator.of(context).pop();
      showEmojiPicker = false;
      focusNode.requestFocus();
      notifyListeners();
    } else {
      focusNode.unfocus();
      showEmojiPicker = true;
      notifyListeners();
      showEmojiPickerBottomSheet(context, controller: controller).whenComplete(
        () {
          showEmojiPicker = false;
          focusNode.requestFocus();
          notifyListeners();
        },
      );
    }
  }

  // ---- file, image, gif, drive ----
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      _clearOthers(except: FileCategory.image);
      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = pickedFile;
      _clearOthers(except: FileCategory.image);
      notifyListeners();
    }
  }

  Future<void> pickFileFromDrive() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          final extension = filePath.split('.').last.toLowerCase();
          final category = FileExtensions.getCategory(extension);

          switch (category) {
            case FileCategory.image:
              image = XFile(filePath);
              break;
            case FileCategory.video:
              videoFile = XFile(filePath);
              break;
            case FileCategory.audio:
              audioFile = XFile(filePath);
              break;
            case FileCategory.document:
              documentFile = XFile(filePath);
              break;
            case FileCategory.archive:
              archiveFile = XFile(filePath);
              break;
            case FileCategory.other:
              otherFile = XFile(filePath);
              break;
          }

          _clearOthers(except: category);
          devlog.log("${category.name} file selected: $filePath");
          notifyListeners();
        }
      } else {
        devlog.log("User canceled file picking");
      }
    } catch (e) {
      devlog.log("Error picking file: $e");
    }
  }

  void removeFile(FileCategory category) {
    switch (category) {
      case FileCategory.image:
        image = null;
        break;
      case FileCategory.video:
        videoFile = null;
        break;
      case FileCategory.audio:
        audioFile = null;
        break;
      case FileCategory.document:
        documentFile = null;
        break;
      case FileCategory.archive:
        archiveFile = null;
        break;
      case FileCategory.other:
        otherFile = null;
        break;
    }
    notifyListeners();
  }

  void _clearOthers({required FileCategory except}) {
    if (except != FileCategory.image) image = null;
    if (except != FileCategory.video) videoFile = null;
    if (except != FileCategory.audio) audioFile = null;
    if (except != FileCategory.document) documentFile = null;
    if (except != FileCategory.archive) archiveFile = null;
    if (except != FileCategory.other) otherFile = null;
  }

  // ---- Send Message ----
  void sendMessage(Function scrollToBottom) {
    final message = controller.text.trim();
    if (message.isNotEmpty) {
      controller.clear();
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    recorder.dispose();
    _amplitudeSubscription?.cancel();
    super.dispose();
  }
}
