import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_system/core/font/app_font.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pdf_viewer/pdf_viewer.dart';

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
            size: 14,
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
          size: 14,
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
        style: appText(size: 14, weight: FontWeight.normal, color: normalColor),
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

class PdfPreview extends StatefulWidget {
  final String source;
  final bool isSender;
  final bool showTime;
  final bool showAvatarAndName;
  final bool shouldShowBottomRightRadiusForCurrent;
  final bool shouldShowBottomLeftRadiusForCurrent;
  final bool isNetwork;

  const PdfPreview({
    super.key,
    required this.source,
    required this.showAvatarAndName,
    required this.shouldShowBottomRightRadiusForCurrent,
    required this.shouldShowBottomLeftRadiusForCurrent,
    required this.showTime,
    required this.isSender,
    this.isNetwork = true,
  });

  @override
  State<PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreview> {
  final Dio dio = Dio();
  late Future<Uint8List> _pdfPreviewFuture;

  @override
  void initState() {
    super.initState();
    _pdfPreviewFuture = _renderFirstPageBytes();
  }

  Future<Uint8List> _renderFirstPageBytes() async {
    PdfDocument document;

    if (!widget.isNetwork) {
      if (widget.source.startsWith('assets/')) {
        document = await PdfDocument.openAsset(widget.source);
      } else {
        document = await PdfDocument.openFile(widget.source);
      }
    } else {
      final resp = await dio.get<List<int>>(
        widget.source,
        options: Options(responseType: ResponseType.bytes),
      );
      if (resp.statusCode != 200 || resp.data == null) {
        throw Exception('Failed to download PDF');
      }
      document = await PdfDocument.openData(Uint8List.fromList(resp.data!));
    }

    final page = await document.getPage(1);
    final pageImage = await page.render(
      width: page.width * 2,
      height: page.height * 2,
      format: PdfPageImageFormat.jpeg,
      backgroundColor: '#FFFFFFFF',
    );

    final bytes = pageImage!.bytes;
    await page.close();
    await document.close();

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 200,
      child: FutureBuilder<Uint8List>(
        future: _pdfPreviewFuture, // ← use cached future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  !widget.isSender
                      ? (!widget.showTime && !widget.showAvatarAndName)
                            ? 5
                            : 20
                      : 20,
                ),
                topRight: Radius.circular(
                  widget.isSender
                      ? (!widget.showTime)
                            ? 5
                            : 20
                      : 20,
                ),
                // bottomLeft: Radius.circular(
                //   !widget.isSender
                //       ? (widget.shouldShowBottomLeftRadiusForCurrent ? 20 : 5)
                //       : 20,
                // ),
                // bottomRight: Radius.circular(
                //   widget.isSender
                //       ? (widget.shouldShowBottomRightRadiusForCurrent ? 20 : 5)
                //       : 20,
                // ),
              ),
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            );
          }
        },
      ),
    );
  }
}
