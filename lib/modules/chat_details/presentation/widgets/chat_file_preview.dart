import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/constants/extension.dart';
import '../../../../core/font/app_font.dart';
import '../../../../core/utils/file_icon_and_name.dart';
import '../../../../provider/chat_details_provider.dart';
import '../../../pdf_viewer/pdf_viewer.dart';
import 'pdf_preview.dart';

class ChatFilesWidget extends StatelessWidget {
  const ChatFilesWidget({super.key, required this.chat});

  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    final filePath = chat.documentFile?.path ?? chat.otherFile?.path;
    if (filePath == null) return const SizedBox.shrink();

    final extension = filePath.split('.').last.toLowerCase();

    if (extension == 'pdf') {
      return DocumentPreviewWidget(filePath: filePath, chat: chat);
    } else {
      return OtherFileWidget(filePath: filePath, chat: chat);
    }
  }
}

class DocumentPreviewWidget extends StatelessWidget {
  const DocumentPreviewWidget({
    super.key,
    required this.filePath,
    required this.chat,
  });

  final String filePath;
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
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  // PDF preview
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(pdfUrl: filePath),
                        ),
                      );
                    },
                    child: SimplePdfPreview(source: filePath, isNetwork: false),
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
                        FileIcon(filePath, size: 22),
                        // Icon(
                        //   getFileIcon(filePath),
                        //   size: 20,
                        //   color: Colors.red,
                        // ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            getFileName(filePath),
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
          // Close button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => chat.removeFile(FileCategory.document),
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

class OtherFileWidget extends StatelessWidget {
  const OtherFileWidget({
    super.key,
    required this.filePath,
    required this.chat,
  });

  final String filePath;
  final ChatDetailsProvider chat;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () async {
              await OpenFilex.open(filePath);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FileIcon(filePath, size: 30),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      getFileName(filePath),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appText(size: 13, weight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () => chat.removeFile(FileCategory.document),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 4,
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  Icons.close,
                  size: 14,
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
