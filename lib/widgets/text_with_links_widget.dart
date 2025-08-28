import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/font/app_font.dart';
import '../utils/launch_url.dart';

Widget buildTextWithLinks(String text, {required Color normalColor}) {
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
          ..onTap = () => openUrl(url: launchUrlString),
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

  return RichText(text: TextSpan(children: spans));
}
