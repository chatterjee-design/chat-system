import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_system/core/font/app_font.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../screens/pdf_viewer/pdf_viewer.dart';
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
      return _buildTextWithLinks(msg['content'], normalColor: color);

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
        child: CachedNetworkImage(
          imageUrl: msg['content'],
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 100),
          placeholderFadeInDuration: Duration(milliseconds: 50),
          placeholder: (context, url) => Container(color: Colors.grey[300]),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
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
              isNetwork: false,
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
                        // color: color,
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

Widget _buildTextWithLinks(String text, {required Color normalColor}) {
  final urlRegex = RegExp(
    r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
    caseSensitive: false,
  );

  final spans = <TextSpan>[];
  int start = 0;

  for (final match in urlRegex.allMatches(text)) {
    if (match.start > start) {
      spans.add(
        TextSpan(
          text: text.substring(start, match.start),

          style: appText(
            size: 15,
            weight: FontWeight.normal,
            color: normalColor,
          ),
        ),
      );
    }

    var url = match.group(0)!;
    // If protocol is missing, add https:// before launching
    final launchUrlString = url.startsWith('http') ? url : 'https://$url';

    spans.add(
      TextSpan(
        text: url,
        style: appText(
          size: 15,
          weight: FontWeight.normal,
          color: Colors.blue,
        ).copyWith(decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _launchUrl(url: launchUrlString),
      ),
    );

    start = match.end;
  }

  if (start < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(start),
        style: appText(size: 15, weight: FontWeight.normal, color: normalColor),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 13),
    child: RichText(text: TextSpan(children: spans)),
  );
}

Future<void> _launchUrl({required String url}) async {
  try {
    final Uri uri = Uri.parse(url.trim());
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw 'Could not launch $url';
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
  }
}

enum PdfSourceType { asset, file, network }
