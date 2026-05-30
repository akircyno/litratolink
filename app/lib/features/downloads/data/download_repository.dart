import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/services/edge_function_service.dart';
import '../../../core/utils/quality_test_log.dart';
import '../../albums/models/media_file.dart';
import '../models/download_access.dart';

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository(
    ref.watch(edgeFunctionServiceProvider),
    Dio(),
  );
});

class DownloadRepository {
  const DownloadRepository(this.edgeFunctionService, this.dio);

  final EdgeFunctionService edgeFunctionService;
  final Dio dio;

  Future<DownloadedFile> downloadOriginal({
    required MediaFile file,
    required void Function(double progress) onProgress,
  }) async {
    final access = await edgeFunctionService.call<DownloadAccess>(
      'get-download-access',
      body: {'media_file_id': file.id},
      parser: (data) => DownloadAccess.fromJson(Map<String, dynamic>.from(data as Map)),
    );

    final response = await dio.get<List<int>>(
      access.downloadUrl,
      options: Options(
        headers: {'Authorization': 'Bearer ${access.accessToken}'},
        responseType: ResponseType.bytes,
      ),
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        onProgress(received / total);
      },
    );

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const AppError('Downloaded file was empty. Please try again.');
    }

    final savedPath = await FilePicker.saveFile(
      dialogTitle: 'Save original file',
      fileName: access.originalFilename,
      bytes: Uint8List.fromList(bytes),
    );

    if (savedPath == null) {
      throw const AppError('Download was cancelled.');
    }

    QualityTestLog.downloadedFile(
      filename: access.originalFilename,
      downloadedSizeBytes: bytes.length,
      expectedSizeBytes: access.fileSizeBytes,
      mimeType: access.mimeType,
      savedPath: savedPath,
    );

    onProgress(1);

    return DownloadedFile(
      filename: access.originalFilename,
      mimeType: access.mimeType,
      sizeBytes: bytes.length,
      savedPath: savedPath,
    );
  }
}
