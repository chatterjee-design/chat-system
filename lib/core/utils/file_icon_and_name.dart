import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';

import '../constants/extension.dart';

// Widget getFileIcon(String path) {
//   return FileIcon(path, size: 22);
// }

// IconData getFileIcon(String path) {
//   final ext = path.split('.').last.toLowerCase();
//   final category = FileExtensions.getCategory(ext);

//   switch (category) {
//     case FileCategory.document:
//       switch (ext) {
//         case 'pdf':
//           return Icons.picture_as_pdf;
//         case 'doc':
//           return Icons.word_doc;

//         case 'docx':
//           return Icons.description;
//         case 'txt':
//         case 'rtf':
//           return Icons.article;
//         case 'xls':
//         case 'xlsx':
//           return Icons.table_chart;
//         case 'ppt':
//         case 'pptx':
//           return Icons.slideshow;
//         case 'csv':
//           return Icons.grid_on;
//         default:
//           return Icons.insert_drive_file;
//       }

//     case FileCategory.image:
//       return Icons.image;

//     case FileCategory.audio:
//       return Icons.audiotrack;

//     case FileCategory.video:
//       return Icons.videocam;

//     case FileCategory.archive:
//       return Icons.archive;

//     case FileCategory.other:
//     default:
//       return Icons.insert_drive_file;
//   }
// }

String getFileName(String path) {
  return path.split('/').last;
}
