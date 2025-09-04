import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/chat_details_provider.dart';
import 'audio_rec.dart';
import 'open_bottom_sheet.dart';
import '../../widgets/voice_message_weave.dart';
import '../../widgets/voice_rec_button.dart';
import '../../widgets/text_field_send_msg.dart';

class ChatInputBar extends StatelessWidget {
  final Function scrollToBottom;
  const ChatInputBar({super.key, required this.scrollToBottom});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatDetailsProvider>(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 5),
        color: chat.recordedFilePath != null || chat.isRecording
            ? Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : Colors.transparent,
        // height: chat.replyingMessage != null ? 150 : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chat.replyingMessage != null) ReplyMsg(chat: chat),

            Row(
              crossAxisAlignment:
                  chat.isRecording || chat.recordedFilePath != null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
              children: [
                if (chat.recordedFilePath == null)
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => OptionsBottomSheet.show(context),
                  ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: chat.isRecording
                        ? RecordingWaveformWidget(
                            isRecording: chat.isRecording,
                            waveForm: chat.waveform,
                            onDelete: chat.deleteRecording,
                          )
                        : chat.recordedFilePath != null
                        ? VoiceMessageWidget(
                            filePath: chat.recordedFilePath!,
                            onDelete: chat.deleteRecording,
                          )
                        : TextFieldSendMsg(),
                  ),
                ),

                const SizedBox(width: 8),

                chat.isRecording
                    ? RecordButton(
                        isRecording: true,
                        onRecordStart: chat.startRecording,
                        onRecordStop: chat.stopRecording,
                      )
                    : (chat.recordedFilePath != null ||
                          chat.hasText ||
                          chat.image != null ||
                          chat.otherFile != null ||
                          chat.videoFile != null ||
                          chat.audioFile != null ||
                          chat.documentFile != null)
                    ? IconButton(
                        onPressed: () => chat.sendMessage(scrollToBottom),
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            icon: Icon(
                              Icons.image_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: chat.pickImageFromGallery,
                          ),
                          RecordButton(
                            isRecording: false,
                            onRecordStart: chat.startRecording,
                            onRecordStop: chat.stopRecording,
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyMsg extends StatelessWidget {
  const ReplyMsg({super.key, required this.chat});

  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(bottom: 12, left: 12),
      title: Row(
        spacing: 3,
        children: [
          Image.asset("assets/icons/quote.png", height: 24, width: 24),

          CircleAvatar(
            radius: 9,
            backgroundImage: NetworkImage(chat.replyingMessage!["avatar"]),
          ),
          SizedBox(height: 5),
          Text(
            chat.replyingMessage?["name"] ?? '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      subtitle: Text(
        chat.replyingMessage?["content"] ?? "",
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          chat.clearReply();
        },
        icon: Icon(Icons.close),
      ),
    );
  }
}
