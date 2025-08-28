import 'package:flutter/material.dart';

import '../../../../widgets/image_content_widget.dart';
import '../../../../widgets/text_with_links_widget.dart';
import '../../../pdf_viewer/pdf_viewer.dart';
import 'pdf_preview.dart';

Widget chatContent(
  Map<String, dynamic> msg, {
  required bool shouldShowBottomRightRadiusForCurrent,
  required bool shouldShowBottomLeftRadiusForCurrent,
  required bool isSender,
  required bool showAvatarAndName,
  required bool showTime,
  required Color color,
  required BuildContext context,
}) {
  switch (msg['type']) {
    case 'text':
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 13),
        child: buildTextWithLinks(msg['content'], normalColor: color),
      );

    case 'image':
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            !isSender
                ? (!showTime && !showAvatarAndName)
                      ? 5
                      : 20
                : 20,
          ),
          topRight: Radius.circular(
            isSender
                ? (!showTime)
                      ? 5
                      : 20
                : 20,
          ),
          bottomLeft: Radius.circular(
            !isSender ? (shouldShowBottomLeftRadiusForCurrent ? 20 : 5) : 20,
          ),
          bottomRight: Radius.circular(
            isSender ? (shouldShowBottomRightRadiusForCurrent ? 20 : 5) : 20,
          ),
        ),
        child: ImageContentWidget(imageUrl: msg['content']),
      );
    case 'pdf':
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(pdfUrl: msg['content']),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PdfPreview(
              source: msg['content'],
              isNetwork:
                  (msg['content']?.toString().startsWith('https') ?? false),
              isSender: isSender,
              shouldShowBottomLeftRadiusForCurrent:
                  shouldShowBottomLeftRadiusForCurrent,
              shouldShowBottomRightRadiusForCurrent:
                  shouldShowBottomRightRadiusForCurrent,
              showAvatarAndName: showAvatarAndName,
              showTime: showTime,
            ),

            Divider(color: Colors.grey, thickness: 0.7),
            // const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      msg['content'].split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

    default:
      return const Text("Unsupported message type");
  }
}

enum PdfSourceType { asset, file, network }
