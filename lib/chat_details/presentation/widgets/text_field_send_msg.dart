import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/font/app_font.dart';
import '../../../core/utils/file_icon_and_name.dart';
import '../../../provider/chat_details_provider.dart';
import '../../../screens/pdf_viewer/pdf_viewer.dart';
import 'pdf_preview.dart';

class TextFieldSendMsg extends StatelessWidget {
  const TextFieldSendMsg({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatDetailsProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldAndEmojie(chat: chat),

          if (chat.image != null) ...[
            const SizedBox(height: 8),
            ChatImageWidget(chat: chat),
          ] else if (chat.otherFile != null) ...[
            const SizedBox(height: 8),
            ChatFilesWidget(chat: chat),
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

class ChatFilesWidget extends StatelessWidget {
  const ChatFilesWidget({super.key, required this.chat});

  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 220,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height: 170,
              width: 215,
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // PDF Preview
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PdfViewerScreen(pdfUrl: chat.otherFile!.path),
                        ),
                      );
                    },
                    child: SimplePdfPreview(
                      source: chat.otherFile!.path,
                      isNetwork: false,
                    ),
                  ),

                  // File details row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 18,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          getFileIcon(chat.otherFile!.path),
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            getFileName(chat.otherFile!.path),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appText(size: 12, weight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: chat.removeFile,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 4,
                  ),
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatImageWidget extends StatelessWidget {
  const ChatImageWidget({super.key, required this.chat});

  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      width: 95,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(chat.image!.path),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: chat.removeImage,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 4,
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
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
