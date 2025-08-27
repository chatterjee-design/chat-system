import 'dart:async';
import 'dart:developer' as devlog;
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';

import 'chat_details_event.dart';
import 'chat_details_state.dart';

class ChatDetailsBloc extends Bloc<ChatDetailsEvent, ChatDetailsState> {
  final ImagePicker picker = ImagePicker();
  final AudioRecorder recorder = AudioRecorder();

  StreamSubscription<Amplitude>? _amplitudeSubscription;

  ChatDetailsBloc() : super(ChatDetailsInitial()) {
    on<ToggleEmojiPicker>(_onToggleEmojiPicker);
    on<SendMessage>(_onSendMessage);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<DeleteRecording>(_onDeleteRecording);
    on<PickImageFromGallery>(_onPickImageFromGallery);
    on<PickImageFromCamera>(_onPickImageFromCamera);
    on<PickFileFromDrive>(_onPickFileFromDrive);
    on<PickLocalFile>(_onPickLocalFile);
    on<RemoveImage>(_onRemoveImage);
    on<RemoveFile>(_onRemoveFile);
  }

  // Emoji
  Future<void> _onToggleEmojiPicker(
    ToggleEmojiPicker event,
    Emitter<ChatDetailsState> emit,
  ) async {
    emit(state.copyWith(showEmojiPicker: !state.showEmojiPicker));
  }

  // Message
  void _onSendMessage(SendMessage event, Emitter<ChatDetailsState> emit) {
    emit(ChatDetailsLoading());
    event.scrollToBottom();
    emit(ChatDetailsSuccess(message: "Message sent"));
  }

  // Recording
  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<ChatDetailsState> emit,
  ) async {
    if (await recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await recorder.start(const RecordConfig(), path: path);

      _amplitudeSubscription = recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
            final normalized = (amp.current + 45) / 45;
            final updatedWaveform = List<double>.from(state.waveform)
              ..add(max(0, min(normalized, 1)));
            if (updatedWaveform.length > 100) updatedWaveform.removeAt(0);
            emit(state.copyWith(waveform: updatedWaveform));
          });

      emit(state.copyWith(isRecording: true, recordedFilePath: path));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<ChatDetailsState> emit,
  ) async {
    final path = await recorder.stop();
    await _amplitudeSubscription?.cancel();
    emit(state.copyWith(isRecording: false, recordedFilePath: path));
  }

  void _onDeleteRecording(
    DeleteRecording event,
    Emitter<ChatDetailsState> emit,
  ) {
    emit(state.copyWith(recordedFilePath: null));
  }

  // Image
  Future<void> _onPickImageFromGallery(
    PickImageFromGallery event,
    Emitter<ChatDetailsState> emit,
  ) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(image: pickedFile, otherFile: null));
    }
  }

  Future<void> _onPickImageFromCamera(
    PickImageFromCamera event,
    Emitter<ChatDetailsState> emit,
  ) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      emit(state.copyWith(image: pickedFile, otherFile: null));
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<ChatDetailsState> emit) {
    emit(state.copyWith(image: null));
  }

  void _onRemoveFile(RemoveFile event, Emitter<ChatDetailsState> emit) {
    emit(state.copyWith(otherFile: null));
  }

  // File Picker
  Future<void> _onPickFileFromDrive(
    PickFileFromDrive event,
    Emitter<ChatDetailsState> emit,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          final extension = filePath.split('.').last.toLowerCase();
          final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
          final otherFileExtensions = ['pdf', 'docx', 'txt', 'doc'];

          if (imageExtensions.contains(extension)) {
            emit(state.copyWith(image: XFile(filePath), otherFile: null));
          } else if (otherFileExtensions.contains(extension)) {
            emit(state.copyWith(otherFile: XFile(filePath), image: null));
          } else {
            devlog.log("Unsupported file format: $extension");
          }
        }
      }
    } catch (e) {
      emit(ChatDetailsError("Error picking file: $e"));
    }
  }

  Future<void> _onPickLocalFile(
    PickLocalFile event,
    Emitter<ChatDetailsState> emit,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt', 'doc'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        emit(state.copyWith(otherFile: XFile(filePath)));
      }
    } catch (e) {
      emit(ChatDetailsError("Error picking local file: $e"));
    }
  }

  @override
  Future<void> close() {
    recorder.dispose();
    _amplitudeSubscription?.cancel();
    return super.close();
  }
}
