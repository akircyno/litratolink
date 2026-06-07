import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/services/edge_function_service.dart';
import '../../../core/utils/quality_test_log.dart';
import '../../albums/models/media_file.dart';
import '../models/downloaded_file.dart';

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
    final original = await downloadOriginalBytes(
      file: file,
      onProgress: onProgress,
    );

    final String savedPath;
    final bool savedToGallery;

    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      await _requestGalleryPermission();
      await _saveToGallery(original);
      savedPath = original.filename;
      savedToGallery = true;
    } else if (_shouldUseMobileWebShareSheet) {
      await _shareOriginalToMobileSaveSheet(original);
      savedPath = original.filename;
      savedToGallery = true;
    } else {
      final picked = await FilePicker.saveFile(
        dialogTitle: 'Save file',
        fileName: original.filename,
        bytes: original.bytes,
      );

      if (picked == null && !kIsWeb) {
        throw const AppError('Download was cancelled.');
      }

      savedPath = picked ?? original.filename;
      savedToGallery = false;
    }

    QualityTestLog.downloadedFile(
      filename: original.filename,
      downloadedSizeBytes: original.sizeBytes,
      expectedSizeBytes: original.expectedSizeBytes,
      mimeType: original.mimeType,
      savedPath: savedPath,
      checksumHex: QualityTestLog.sha256Hex(original.bytes),
    );

    onProgress(1);

    return DownloadedFile(
      filename: original.filename,
      mimeType: original.mimeType,
      sizeBytes: original.sizeBytes,
      expectedSizeBytes: original.expectedSizeBytes,
      savedPath: savedPath,
      savedToGallery: savedToGallery,
    );
  }

  bool get _shouldUseMobileWebShareSheet =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  Future<void> _shareOriginalToMobileSaveSheet(
    OriginalDownload original,
  ) async {
    final previousFallback = Share.downloadFallbackEnabled;
    Share.downloadFallbackEnabled = false;

    try {
      final result = await Share.shareXFiles(
        [
          XFile.fromData(
            original.bytes,
            mimeType: original.mimeType,
            name: original.filename,
          ),
        ],
        subject: 'Save ${original.filename}',
        fileNameOverrides: [original.filename],
      );

      if (result.status == ShareResultStatus.dismissed) {
        throw const AppError('Save was cancelled.');
      }
    } on AppError {
      rethrow;
    } catch (_) {
      throw const AppError(
        'Could not open the phone save sheet. Open Potoos in Safari or Chrome and try again.',
      );
    } finally {
      Share.downloadFallbackEnabled = previousFallback;
    }
  }

  Future<void> _requestGalleryPermission() async {
    final permission =
        Platform.isIOS ? Permission.photosAddOnly : Permission.storage;
    final status = await permission.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      throw const AppError(
        'Gallery access is required to save files.',
        code: 'photo_permission_denied',
      );
    }
  }

  Future<void> _saveToGallery(OriginalDownload original) async {
    final isVideo = original.mimeType.startsWith('video/');
    if (isVideo) {
      final tmp = await Directory.systemTemp.createTemp('potoos_');
      try {
        final tmpFile = File('${tmp.path}/${original.filename}');
        await tmpFile.writeAsBytes(original.bytes);
        await ImageGallerySaver.saveFile(tmpFile.path);
      } finally {
        await tmp.delete(recursive: true);
      }
    } else {
      await ImageGallerySaver.saveImage(
        original.bytes,
        name: original.filename.replaceAll(RegExp(r'\.[^.]+$'), ''),
        quality: 100,
      );
    }
  }

  Future<OriginalDownload> downloadOriginalBytes({
    required MediaFile file,
    required void Function(double progress) onProgress,
  }) async {
    final Response<List<int>> response;
    try {
      response = await dio.post<List<int>>(
        '${edgeFunctionService.supabaseService.env.supabaseUrl}/functions/v1/download-original-file',
        data: {'media_file_id': file.id},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization':
                'Bearer ${edgeFunctionService.supabaseService.currentSession?.accessToken}',
            'apikey': edgeFunctionService.supabaseService.env.supabaseAnonKey,
          },
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          onProgress(received / total);
        },
      );
    } on DioException catch (error) {
      throw _appErrorFromDio(error);
    }

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const AppError('Downloaded file was empty. Please try again.');
    }

    final originalFilename = _readHeader(
          response.headers,
          'x-original-filename',
        ) ??
        file.originalFilename;
    final mimeType =
        _readHeader(response.headers, 'x-mime-type') ?? file.mimeType;
    final expectedSize = int.tryParse(
          _readHeader(response.headers, 'x-file-size-bytes') ?? '',
        ) ??
        bytes.length;

    final downloadedBytes = Uint8List.fromList(bytes);
    final filename = Uri.decodeComponent(originalFilename);

    onProgress(1);

    return OriginalDownload(
      filename: filename,
      mimeType: mimeType,
      bytes: downloadedBytes,
      expectedSizeBytes: expectedSize,
    );
  }

  String? _readHeader(Headers headers, String name) {
    final values = headers[name];
    if (values == null || values.isEmpty) return null;
    return values.first;
  }

  AppError _appErrorFromDio(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      return AppError(
        data['message']?.toString() ?? 'Download failed. Please try again.',
        code: data['error_code']?.toString(),
      );
    }

    if (data is List<int> && data.isNotEmpty) {
      final decoded = utf8.decode(data, allowMalformed: true);
      try {
        final payload = jsonDecode(decoded);
        if (payload is Map) {
          return AppError(
            payload['message']?.toString() ??
                'Download failed. Please try again.',
            code: payload['error_code']?.toString(),
          );
        }
      } catch (_) {
        if (decoded.trim().isNotEmpty) {
          return AppError(decoded.trim());
        }
      }
    }

    return const AppError('Download failed. Please try again.');
  }
}
