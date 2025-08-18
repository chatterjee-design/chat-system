import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/chat_details_provider.dart';
import '../../audio_rec.dart';
import 'open_bottom_sheet.dart';
import '../widgets/voice_message_weave.dart';
import '../widgets/voice_rec_button.dart';
import '../widgets/text_field_send_msg.dart';

class ChatInputBar extends StatelessWidget {
  final Function scrollToBottom;
  const ChatInputBar({super.key, required this.scrollToBottom});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatDetailsProvider>(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 5),
      color: chat.recordedFilePath != null
          ? const Color.fromARGB(136, 193, 206, 215)
          : Colors.transparent,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          crossAxisAlignment: chat.isRecording || chat.recordedFilePath != null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            if (chat.recordedFilePath == null)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
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
                    : textFieldForSendMessage(context, chat),
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
                      chat.otherFile != null)
                ? InkWell(
                    onTap: () => chat.sendMessage(scrollToBottom),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Icon(Icons.send, color: Colors.teal),
                    ),
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Colors.teal,
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
      ),
    );
  }
}
