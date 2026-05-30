class DownloadAccess {
  const DownloadAccess({
    required this.mediaFileId,
    required this.downloadUrl,
    required this.accessToken,
    required this.originalFilename,
    required this.mimeType,
    required this.fileSizeBytes,
  });

  final String mediaFileId;
  final String downloadUrl;
  final String accessToken;
  final String originalFilename;
  final String mimeType;
  final int fileSizeBytes;

  factory DownloadAccess.fromJson(Map<String, dynamic> json) {
    return DownloadAccess(
      mediaFileId: json['media_file_id']?.toString() ?? '',
      downloadUrl: json['download_url']?.toString() ?? '',
      accessToken: json['access_token']?.toString() ?? '',
      originalFilename: json['original_filename']?.toString() ?? 'original-file',
      mimeType: json['mime_type']?.toString() ?? 'application/octet-stream',
      fileSizeBytes: int.tryParse(json['file_size_bytes']?.toString() ?? '') ?? 0,
    );
  }
}

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
