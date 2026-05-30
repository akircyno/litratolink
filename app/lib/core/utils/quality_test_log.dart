import 'package:flutter/foundation.dart';

class QualityTestLog {
  const QualityTestLog._();

  static void originalUpload({
    required String filename,
    required int sizeBytes,
    required String mimeType,
    required String? localPath,
  }) {
    if (!kDebugMode) return;

    debugPrint('[LitratoLink Quality] Original upload');
    debugPrint('  filename: $filename');
    debugPrint('  size_bytes: $sizeBytes');
    debugPrint('  mime_type: $mimeType');
    debugPrint('  local_path: ${localPath ?? "browser-selected file"}');
  }

  static void downloadedFile({
    required String filename,
    required int downloadedSizeBytes,
    required int expectedSizeBytes,
    required String mimeType,
    required String savedPath,
  }) {
    if (!kDebugMode) return;

    debugPrint('[LitratoLink Quality] Downloaded original');
    debugPrint('  filename: $filename');
    debugPrint('  downloaded_size_bytes: $downloadedSizeBytes');
    debugPrint('  expected_size_bytes: $expectedSizeBytes');
    debugPrint('  mime_type: $mimeType');
    debugPrint('  saved_path: $savedPath');

    if (expectedSizeBytes > 0 && downloadedSizeBytes != expectedSizeBytes) {
      debugPrint(
        '  warning: downloaded size differs from expected original size.',
      );
    }
  }
}
