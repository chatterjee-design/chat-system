import 'package:flutter/material.dart';

import '../../../core/font/app_font.dart';
import '../../../provider/chat_search_provider.dart';
import '../../../utils/time_formater.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, required this.provider});

  final ChatSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: provider.filteredMessages.length,
      itemBuilder: (context, index) {
        final msg = provider.filteredMessages[index];

        return Column(
          children: [
            ListTile(
              minTileHeight: 0,
              contentPadding: EdgeInsets.all(10),
              isThreeLine: true,

              titleAlignment: ListTileTitleAlignment.titleHeight,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(msg["avatar"]),
              ),
              title: Text(
                msg["name"] ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppFormatedTime.formattedTimestamp(msg['timestamp']),
                    style: appText(size: 10, weight: FontWeight.w400),
                  ),
                ],
              ),
              subtitle: buildMessageSubtitle(msg, provider.query),
            ),
            const Divider(thickness: 0.5, height: 1),
          ],
        );
      },
    );
  }
}

Widget buildMessageSubtitle(Map<String, dynamic> msg, String query) {
  String content = msg["content"] ?? "";
  String type = msg["type"] ?? "text";

  String displayText;

  if (type == "text") {
    displayText = content;
  } else {
    displayText = content.split("/").last;
  }

  if (type == "text") {
    return _HighlightedText(text: displayText, highlight: query);
  } else {
    IconData icon;
    if (type == "image") {
      icon = Icons.image;
    } else if (type == "pdf") {
      icon = Icons.picture_as_pdf;
    } else {
      icon = Icons.insert_drive_file;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.red),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                displayText,
                style: appText(size: 12, weight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;

  const _HighlightedText({required this.text, required this.highlight});

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();

    final spans = <TextSpan>[];
    int start = 0;
    int index;

    while ((index = lowerText.indexOf(lowerHighlight, start)) != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + highlight.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + highlight.length;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
