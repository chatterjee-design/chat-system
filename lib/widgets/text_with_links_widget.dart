import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/font/app_font.dart';
import '../utils/url_helper.dart';

class TextWithLinks extends StatefulWidget {
  final String text;
  final Color normalColor;
  final bool isOnlyLink;

  const TextWithLinks({
    super.key,
    required this.text,
    required this.normalColor,
    this.isOnlyLink = false,
  });

  @override
  State<TextWithLinks> createState() => _TextWithLinksState();
}

class _TextWithLinksState extends State<TextWithLinks> {
  String? title;

  @override
  void initState() {
    super.initState();
    _loadTitle();
  }

  Future<void> _loadTitle() async {
    final urlRegex = RegExp(
      r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );

    final match = urlRegex.firstMatch(widget.text);
    if (match != null) {
      var url = match.group(0)!;
      final formattedUrl = url.startsWith('http') ? url : 'https://$url';

      String? fetchedTitle = await WebHelper.getTitle(formattedUrl);
      // if (!mounted) return;
      setState(() {
        title = fetchedTitle ?? url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlRegex = RegExp(
      r'((https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\S*)?)',
      caseSensitive: false,
    );

    final spans = <TextSpan>[];

    if (widget.isOnlyLink) {
      final match = urlRegex.firstMatch(widget.text);
      if (match != null) {
        var url = match.group(0)!;
        final launchUrlString = url.startsWith('http') ? url : 'https://$url';

        spans.add(
          TextSpan(
            text: title ?? url,
            style: appText(
              size: 15,
              weight: FontWeight.normal,
              color: widget.normalColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => WebHelper.openUrl(url: launchUrlString),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: widget.text,
            style: appText(
              size: 15,
              weight: FontWeight.normal,
              color: widget.normalColor,
            ),
          ),
        );
      }
    } else {
      // 🔹 Normal mode → show whole text with links highlighted
      int start = 0;
      for (final match in urlRegex.allMatches(widget.text)) {
        if (match.start > start) {
          spans.add(
            TextSpan(
              text: widget.text.substring(start, match.start),
              style: appText(
                size: 15,
                weight: FontWeight.normal,
                color: widget.normalColor,
              ),
            ),
          );
        }

        var url = match.group(0)!;
        final launchUrlString = url.startsWith('http') ? url : 'https://$url';

        spans.add(
          TextSpan(
            text: title ?? url,
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

      if (start < widget.text.length) {
        spans.add(
          TextSpan(
            text: widget.text.substring(start),
            style: appText(
              size: 15,
              weight: FontWeight.normal,
              color: widget.normalColor,
            ),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
