import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ChatDetailsState extends Equatable {
  final bool hasText;
  final bool showEmojiPicker;
  final bool isRecording;
  final String? recordedFilePath;
  final XFile? image;
  final XFile? otherFile;
  final List<double> waveform;
  final String statusMessage;

  const ChatDetailsState({
    this.hasText = false,
    this.showEmojiPicker = false,
    this.isRecording = false,
    this.recordedFilePath,
    this.image,
    this.otherFile,
    this.waveform = const [],
    this.statusMessage = '',
  });

  ChatDetailsState copyWith({
    bool? hasText,
    bool? showEmojiPicker,
    bool? isRecording,
    String? recordedFilePath,
    XFile? image,
    XFile? otherFile,
    List<double>? waveform,
    String? statusMessage,
  }) {
    return ChatDetailsState(
      hasText: hasText ?? this.hasText,
      showEmojiPicker: showEmojiPicker ?? this.showEmojiPicker,
      isRecording: isRecording ?? this.isRecording,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      image: image ?? this.image,
      otherFile: otherFile ?? this.otherFile,
      waveform: waveform ?? this.waveform,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  List<Object?> get props => [
    hasText,
    showEmojiPicker,
    isRecording,
    recordedFilePath,
    image,
    otherFile,
    waveform,
    statusMessage,
  ];
}

class ChatDetailsInitial extends ChatDetailsState {}

class ChatDetailsLoading extends ChatDetailsState {}

class ChatDetailsSuccess extends ChatDetailsState {
  const ChatDetailsSuccess({String message = ''})
    : super(statusMessage: message);
}

class ChatDetailsError extends ChatDetailsState {
  final String error;
  const ChatDetailsError(this.error) : super(statusMessage: error);

  @override
  List<Object?> get props => [error];
}
