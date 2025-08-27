import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;

  HighlightedText({required this.text, required this.highlight});

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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + highlight.length),
          style: TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
            fontWeight: FontWeight.w500,
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
