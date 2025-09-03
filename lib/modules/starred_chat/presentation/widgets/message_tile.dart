import 'package:flutter/material.dart';

import '../../../../core/font/app_font.dart';
import '../../../../utils/time_formater.dart';
import '../../../../widgets/image_content_widget.dart';
import '../../../../widgets/text_with_links_widget.dart';
import '../../../pdf_viewer/pdf_viewer.dart';

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> msg;

  const MessageTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final String avatar = msg["avatar"];
    final String name = msg["name"];
    final String? type = msg["type"];
    final String? content = msg["content"];
    final String? timestamp = msg["timestamp"];

    Widget? subtitleWidget;

    if (type == "image" && content != null) {
      subtitleWidget = Padding(
        padding: const EdgeInsets.only(top: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ImageContentWidget(imageUrl: msg['content']),
        ),
      );
    } else if (type == "text" && content != null) {
      subtitleWidget = TextWithLinks(
        text: msg['content'],
        normalColor: Theme.of(context).colorScheme.onSurface,
      );
    } else if (type == "pdf" && content != null) {
      final pdfName = Uri.parse(content).pathSegments.last;

      subtitleWidget = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(pdfUrl: msg['content']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    pdfName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListTile(
      minTileHeight: 0,
      contentPadding: const EdgeInsets.all(0),
      isThreeLine: true,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      leading: CircleAvatar(backgroundImage: NetworkImage(avatar)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Sent an ${type == "image" ? type : "atttachment"}",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          if (subtitleWidget != null) subtitleWidget,
        ],
      ),

      trailing: timestamp != null
          ? Text(
              AppFormatedTime.smartTimestamp(msg['timestamp']),
              style: appText(size: 9, weight: FontWeight.w400),
            )
          : null,
    );
  }
}
