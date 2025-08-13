import 'package:flutter/material.dart';

IconData getFileIcon(String path) {
  String ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'txt':
      return Icons.article;
    default:
      return Icons.insert_drive_file;
  }
}

String getFileName(String path) {
  return path.split('/').last;
}
