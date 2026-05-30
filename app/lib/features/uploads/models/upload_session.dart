class UploadSession {
  const UploadSession({
    required this.mediaFileId,
    required this.storageObjectId,
    required this.uploadUrl,
    required this.uploadMethod,
    required this.requiredHeaders,
  });

  final String mediaFileId;
  final String storageObjectId;
  final String uploadUrl;
  final String uploadMethod;
  final Map<String, String> requiredHeaders;

  factory UploadSession.fromJson(Map<String, dynamic> json) {
    final headers = Map<String, dynamic>.from(json['required_headers'] as Map? ?? {});

    return UploadSession(
      mediaFileId: json['media_file_id']?.toString() ?? '',
      storageObjectId: json['storage_object_id']?.toString() ?? '',
      uploadUrl: json['upload_url']?.toString() ?? '',
      uploadMethod: json['upload_method']?.toString() ?? 'PUT',
      requiredHeaders: headers.map((key, value) => MapEntry(key, value.toString())),
    );
  }
}

class CompletedUpload {
  const CompletedUpload({
    required this.mediaFileId,
    required this.uploadStatus,
    required this.uploadedAt,
  });

  final String mediaFileId;
  final String uploadStatus;
  final DateTime? uploadedAt;

  factory CompletedUpload.fromJson(Map<String, dynamic> json) {
    return CompletedUpload(
      mediaFileId: json['media_file_id']?.toString() ?? '',
      uploadStatus: json['upload_status']?.toString() ?? '',
      uploadedAt: DateTime.tryParse(json['uploaded_at']?.toString() ?? ''),
    );
  }
}
