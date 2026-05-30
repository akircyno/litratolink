class DownloadedFile {
  const DownloadedFile({
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    required this.savedPath,
  });

  final String filename;
  final String mimeType;
  final int sizeBytes;
  final String savedPath;
}
