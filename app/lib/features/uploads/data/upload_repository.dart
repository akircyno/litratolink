import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/services/edge_function_service.dart';
import '../../../core/utils/quality_test_log.dart';
import '../models/upload_file.dart';
import '../models/upload_session.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(
    ref.watch(edgeFunctionServiceProvider),
    Dio(),
  );
});

class UploadRepository {
  const UploadRepository(this.edgeFunctionService, this.dio);

  final EdgeFunctionService edgeFunctionService;
  final Dio dio;

  Future<CompletedUpload> uploadOriginalFile({
    required String albumId,
    required UploadFile file,
    required void Function(double progress) onProgress,
  }) async {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw const AppError('Could not read the selected original file.');
    }

    QualityTestLog.originalUpload(
      filename: file.name,
      sizeBytes: file.sizeBytes,
      mimeType: file.mimeType,
      localPath: file.localPath,
    );

    final session = await edgeFunctionService.call<UploadSession>(
      'create-upload-session',
      body: {
        'album_id': albumId,
        'original_filename': file.name,
        'mime_type': file.mimeType,
        'file_size_bytes': file.sizeBytes,
        'file_type': file.fileType,
      },
      parser: (data) =>
          UploadSession.fromJson(Map<String, dynamic>.from(data as Map)),
    );

    final response = await dio.post<Map<String, dynamic>>(
      '${edgeFunctionService.supabaseService.env.supabaseUrl}/functions/v1/upload-original-file',
      data: bytes,
      options: Options(
        contentType: file.mimeType,
        responseType: ResponseType.json,
        headers: {
          'Authorization':
              'Bearer ${edgeFunctionService.supabaseService.currentSession?.accessToken}',
          'apikey': edgeFunctionService.supabaseService.env.supabaseAnonKey,
          'x-media-file-id': session.mediaFileId,
          'x-storage-object-id': session.storageObjectId,
        },
      ),
      onSendProgress: (sent, total) {
        if (total <= 0) return;
        onProgress(sent / total);
      },
    );

    final payload = response.data;
    if (payload == null || payload['success'] != true) {
      throw AppError(
        payload?['message']?.toString() ??
            'Could not upload to Google Drive. Please try again.',
        code: payload?['error_code']?.toString(),
      );
    }

    onProgress(1);

    return CompletedUpload.fromJson(
        Map<String, dynamic>.from(payload['data'] as Map));
  }
}
