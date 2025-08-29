import 'package:flutter/material.dart';

import '../../../../utils/url_helper.dart';
import '../../../../widgets/image_viewer_scree.dart';
import '../../../pdf_viewer/pdf_viewer.dart';

void handleItemTap(BuildContext context, Map<String, dynamic> msg) {
  final type = msg["type"];
  if (type == "image") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(imageUrl: msg['content']),
      ),
    );
  } else if (type == "pdf") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(pdfUrl: msg['content']),
      ),
    );
  } else if (type == "link") {
    final url = msg['content'];
    final launchUrlString = url.startsWith('http') ? url : 'https://$url';
    WebHelper.openUrl(url: launchUrlString);
  }
}
