enum FileCategory { image, video, audio, document, archive, other }

class FileExtensions {
  static const Map<FileCategory, List<String>> extensions = {
    FileCategory.image: [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'tiff',
      'heic',
    ],
    FileCategory.video: ['mp4', 'mkv', 'mov', 'avi', 'wmv', 'flv', 'webm'],
    FileCategory.audio: ['mp3', 'wav', 'aac', 'ogg', 'm4a', 'flac', 'opus'],
    FileCategory.document: [
      'pdf',
      'doc',
      'docx',
      'txt',
      'rtf',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'csv',
    ],
    FileCategory.archive: ['zip', 'rar', '7z', 'tar', 'gz'],
    FileCategory.other: [],
  };

  static FileCategory getCategory(String extension) {
    for (var entry in extensions.entries) {
      if (entry.value.contains(extension)) {
        return entry.key;
      }
    }
    return FileCategory.other;
  }
}
