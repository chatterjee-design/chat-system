import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/extension.dart';
import '../../../../provider/chat_details_provider.dart';

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
              onTap: () => chat.removeFile(FileCategory.image),

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
