import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';

/// A utility class to render the first page of a PDF to bytes.
class PdfPreviewHelper {
  static final Dio _dio = Dio();

  static Future<Uint8List> renderFirstPageBytes({
    required String source,
    required bool isNetwork,
  }) async {
    PdfDocument document;

    if (!isNetwork) {
      if (source.startsWith('assets/')) {
        document = await PdfDocument.openAsset(source);
      } else {
        document = await PdfDocument.openFile(source);
      }
    } else {
      final resp = await _dio.get<List<int>>(
        source,
        options: Options(responseType: ResponseType.bytes),
      );
      if (resp.statusCode != 200 || resp.data == null) {
        throw Exception('Failed to load PDF');
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
}

/// Base widget that displays a PDF preview from bytes.
class PdfPreviewBase extends StatelessWidget {
  final Future<Uint8List> pdfFuture;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxDecoration? decoration;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const PdfPreviewBase({
    super.key,
    required this.pdfFuture,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.decoration,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: decoration,
      child: FutureBuilder<Uint8List>(
        future: pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget ??
                const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return errorWidget ?? Center(child: Text('Error loading PDF'));
          } else {
            return ClipRRect(
              borderRadius: borderRadius,
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            );
          }
        },
      ),
    );
  }
}

/// Chat-style PDF preview
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
  late Future<Uint8List> _pdfPreviewFuture;

  @override
  void initState() {
    super.initState();
    _pdfPreviewFuture = PdfPreviewHelper.renderFirstPageBytes(
      source: widget.source,
      isNetwork: widget.isNetwork,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreviewBase(
      pdfFuture: _pdfPreviewFuture,
      height: 130,
      width: 200,
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
        // Uncomment if bottom corners needed:
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
    );
  }
}

/// Simple card-style PDF preview
class SimplePdfPreview extends StatefulWidget {
  final String source;
  final bool isNetwork;

  const SimplePdfPreview({
    super.key,
    required this.source,
    this.isNetwork = true,
  });

  @override
  State<SimplePdfPreview> createState() => _SimplePdfPreviewState();
}

class _SimplePdfPreviewState extends State<SimplePdfPreview> {
  late Future<Uint8List> _pdfPreviewFuture;

  @override
  void initState() {
    super.initState();
    _pdfPreviewFuture = PdfPreviewHelper.renderFirstPageBytes(
      source: widget.source,
      isNetwork: widget.isNetwork,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreviewBase(
      pdfFuture: _pdfPreviewFuture,
      height: 105,
      width: 215,
      borderRadius: BorderRadius.circular(22),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      errorWidget: const Center(child: Text('Failed to load PDF preview')),
    );
  }
}
