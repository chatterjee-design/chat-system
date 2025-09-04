import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/extension.dart';
import '../../../../provider/chat_details_provider.dart';
import 'chat_audio_preview.dart';
import 'chat_file_preview.dart';
import 'chat_image_preview.dart';
import 'voice_message_weave.dart';

class TextFieldSendMsg extends StatelessWidget {
  const TextFieldSendMsg({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatDetailsProvider>(context);
    log('${chat.audioFile}');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldAndEmojie(chat: chat),

          if (chat.image != null) ...[
            const SizedBox(height: 8),
            ChatImageWidget(chat: chat),
          ] else if (chat.documentFile != null) ...[
            const SizedBox(height: 8),
            ChatFilesWidget(chat: chat),
          ] else if (chat.audioFile != null) ...[
            const SizedBox(height: 8),
            ChatAudioPreview(chat: chat),
          ],
        ],
      ),
    );
  }
}

class TextFieldAndEmojie extends StatelessWidget {
  const TextFieldAndEmojie({super.key, required this.chat});

  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: chat.controller,
          focusNode: chat.focusNode,
          maxLines: 7,
          minLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(right: 22),
            hintText: 'Type a message...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        Positioned(
          top: 0,
          right: 0,
          // bottom: 0,
          child: InkWell(
            onTap: () => chat.toggleEmojiPicker(context),
            child: Icon(
              Icons.emoji_emotions_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
