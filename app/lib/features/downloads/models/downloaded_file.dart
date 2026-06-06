import 'dart:typed_data';

class DownloadedFile {
  const DownloadedFile({
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    required this.expectedSizeBytes,
    required this.savedPath,
    this.savedToGallery = false,
  });

  final String filename;
  final String mimeType;
  final int sizeBytes;
  final int expectedSizeBytes;
  final String savedPath;
  final bool savedToGallery;

  bool get sizeMatchesExpected =>
      expectedSizeBytes <= 0 || sizeBytes == expectedSizeBytes;
}

class OriginalDownload {
  const OriginalDownload({
    required this.filename,
    required this.mimeType,
    required this.bytes,
    required this.expectedSizeBytes,
  });

  final String filename;
  final String mimeType;
  final Uint8List bytes;
  final int expectedSizeBytes;

  int get sizeBytes => bytes.length;

  bool get sizeMatchesExpected =>
      expectedSizeBytes <= 0 || sizeBytes == expectedSizeBytes;
}
