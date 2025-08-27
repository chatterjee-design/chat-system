import 'package:flutter/material.dart';

import '../../../../core/font/app_font.dart';
import 'highlighted_text.dart';

Widget buildMessageSubtitle(Map<String, dynamic> msg, String query) {
  String content = msg["content"] ?? "";
  String type = msg["type"] ?? "text";

  String displayText = type == "text" ? content : content.split("/").last;

  if (type == "text") {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg["replied"] != null) RepliedContainer(msg: msg),
        HighlightedText(text: displayText, highlight: query),
      ],
    );
  } else {
    IconData icon;
    if (type == "image") {
      icon = Icons.image;
    } else if (type == "pdf") {
      icon = Icons.picture_as_pdf;
    } else {
      icon = Icons.insert_drive_file;
    }

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg["replied"] != null) RepliedContainer(msg: msg),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
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
      ],
    );
  }
}

class RepliedContainer extends StatelessWidget {
  const RepliedContainer({super.key, required this.msg});

  final Map<String, dynamic> msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        dense: true,

        title: Row(
          mainAxisSize: MainAxisSize.min,

          spacing: 3,
          children: [
            Image.asset(
              "assets/icons/quote.png",
              height: 18,
              width: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),

            CircleAvatar(
              radius: 9,
              // backgroundImage: AssetImage("assets/icons/quote.png"),
              backgroundImage: NetworkImage(msg["replied"]["avatar"]),
            ),
            SizedBox(height: 5),
            Text(
              msg["replied"]["name"] ?? '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        subtitle: Text(
          msg["replied"]["content"] ?? "",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),

          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
