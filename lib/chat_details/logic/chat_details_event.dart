import 'package:equatable/equatable.dart';

abstract class ChatDetailsEvent extends Equatable {
  const ChatDetailsEvent();

  @override
  List<Object?> get props => [];
}

//Emojie
class ToggleEmojiPicker extends ChatDetailsEvent {}

//send message
class SendMessage extends ChatDetailsEvent {
  final Function scrollToBottom;
  const SendMessage(this.scrollToBottom);

  @override
  List<Object?> get props => [scrollToBottom];
}

// Recording
class StartRecording extends ChatDetailsEvent {}

class StopRecording extends ChatDetailsEvent {}

class DeleteRecording extends ChatDetailsEvent {}

// File & Image
class PickImageFromGallery extends ChatDetailsEvent {}

class PickImageFromCamera extends ChatDetailsEvent {}

class PickFileFromDrive extends ChatDetailsEvent {}

class PickLocalFile extends ChatDetailsEvent {}

class RemoveImage extends ChatDetailsEvent {}

class RemoveFile extends ChatDetailsEvent {}
