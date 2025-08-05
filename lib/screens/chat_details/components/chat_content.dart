import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget chatContent(Map<String, dynamic> msg) {
  switch (msg['type']) {
    case 'text':
      return Text(msg['content']);
    case 'image':
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: msg['content'],
          height: 150,
          width: 200,
          fit: BoxFit.cover,
        ),
      );
    case 'pdf':
      return GestureDetector(
        onTap: () => launchURL(msg['content']),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.picture_as_pdf, color: Colors.red),
            SizedBox(width: 6),
            Text(
              "Open PDF",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ),
      );
    case 'link':
      return GestureDetector(
        onTap: () => launchURL(msg['content']),
        child: Text(
          msg['content'],
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    default:
      return const Text("Unsupported message type");
  }
}

Future<void> launchURL(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
