import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/font/app_font.dart';
import '../../../../utils/url_helper.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final BuildContext context;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    required this.context,
  });

  get normalColor => Theme.of(context).colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox();
    }

    final lowerHighlight = highlight.toLowerCase();
    final urlRegex = RegExp(
      r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );

    final spans = <TextSpan>[];
    int start = 0;

    for (final match in urlRegex.allMatches(text)) {
      // Add normal text before URL
      if (match.start > start) {
        spans.addAll(
          _processHighlight(
            context,
            text.substring(start, match.start),
            lowerHighlight,
          ),
        );
      }

      // Add URL text
      var url = match.group(0)!;
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
            ..onTap = () => WebHelper.openUrl(url: launchUrlString),
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.addAll(
        _processHighlight(context, text.substring(start), lowerHighlight),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  List<TextSpan> _processHighlight(
    BuildContext context,
    String chunk,
    String lowerHighlight,
  ) {
    if (highlight.isEmpty) {
      return [
        TextSpan(
          text: chunk,
          style: appText(
            size: 15,
            weight: FontWeight.normal,
            color: normalColor,
          ),
        ),
      ];
    }

    final spans = <TextSpan>[];
    final lowerChunk = chunk.toLowerCase();
    int start = 0;
    int index;

    while ((index = lowerChunk.indexOf(lowerHighlight, start)) != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: chunk.substring(start, index),
            style: appText(
              size: 15,
              weight: FontWeight.normal,
              color: normalColor,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: chunk.substring(index, index + highlight.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

      start = index + highlight.length;
    }

    if (start < chunk.length) {
      spans.add(
        TextSpan(
          text: chunk.substring(start),
          style: appText(
            size: 15,
            weight: FontWeight.normal,
            color: normalColor,
          ),
        ),
      );
    }

    return spans;
  }
}
