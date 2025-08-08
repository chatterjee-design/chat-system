import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/temp.pdf';

      if (widget.pdfUrl.startsWith('http')) {
        await Dio().download(widget.pdfUrl, filePath);
      } else if (widget.pdfUrl.startsWith('assets/')) {
        final data = await rootBundle.load(widget.pdfUrl);
        final bytes = data.buffer.asUint8List();
        final file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        throw Exception("Invalid PDF path");
      }

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading PDF: $e");
      setState(() {
        isLoading = false;
        localPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
          ? const Center(child: Text("Failed to load PDF"))
          : PDFView(filePath: localPath!),
    );
  }
}
