import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  static const _defaultDriveChunkSizeBytes = 8 * 1024 * 1024;
  static const _driveChunkQuantumBytes = 256 * 1024;
  static const _maxChunkAttempts = 3;

  Future<CompletedUpload> uploadOriginalFile({
    required String albumId,
    required UploadFile file,
    required void Function(double progress) onProgress,
  }) async {
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw const AppError('Could not read the selected original file.');
    }

    if (bytes.length != file.sizeBytes) {
      throw const AppError(
        'Selected file size changed. Choose the original again and retry.',
        code: 'UPLOAD_FAILED',
      );
    }

    final checksumHex = QualityTestLog.sha256Hex(bytes);
    QualityTestLog.originalUpload(
      filename: file.name,
      sizeBytes: file.sizeBytes,
      mimeType: file.mimeType,
      localPath: file.localPath,
      checksumHex: checksumHex,
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

    onProgress(0.05);

    if (session.isGoogleDriveResumable) {
      return _uploadWithGoogleDriveResumableSession(
        session: session,
        file: file,
        bytes: bytes,
        checksumHex: checksumHex,
        onProgress: onProgress,
      );
    }

    return _uploadWithLegacyEdgeProxy(
      session: session,
      file: file,
      bytes: bytes,
      onProgress: onProgress,
    );
  }

  Future<CompletedUpload> _uploadWithGoogleDriveResumableSession({
    required UploadSession session,
    required UploadFile file,
    required Uint8List bytes,
    required String? checksumHex,
    required void Function(double progress) onProgress,
  }) async {
    String providerFileId;

    try {
      providerFileId = await _uploadRawBytesToDrive(
        session: session,
        file: file,
        bytes: bytes,
        onProgress: (p) => onProgress(0.05 + p.clamp(0.0, 1.0) * 0.88),
      );
    } catch (_) {
      await _markUploadFailed(session);
      rethrow;
    }

    onProgress(0.95);

    final completed = await _completeDirectUploadWithRetry(
      session: session,
      providerFileId: providerFileId,
      finalFileSizeBytes: file.sizeBytes,
      checksumHex: checksumHex,
    );

    onProgress(1);
    return completed;
  }

  Future<String> _uploadRawBytesToDrive({
    required UploadSession session,
    required UploadFile file,
    required Uint8List bytes,
    required void Function(double progress) onProgress,
  }) async {
    final totalBytes = bytes.length;
    final chunkSize = _normalizeDriveChunkSize(
      session.chunkSizeBytes ?? _defaultDriveChunkSizeBytes,
    );
    var offset = 0;
    Object? finalPayload;

    while (offset < totalBytes) {
      final chunkStart = offset;
      final chunkEndExclusive = math.min(chunkStart + chunkSize, totalBytes);
      final chunkEndInclusive = chunkEndExclusive - 1;
      final chunk = Uint8List.sublistView(
        bytes,
        chunkStart,
        chunkEndExclusive,
      );

      final result = await _putDriveChunkWithRetry(
        session: session,
        file: file,
        chunk: chunk,
        chunkStart: chunkStart,
        chunkEndInclusive: chunkEndInclusive,
        totalBytes: totalBytes,
        onProgress: onProgress,
      );

      if (result.statusCode == 308) {
        final nextOffset = result.nextOffset ?? chunkEndExclusive;
        if (nextOffset <= chunkStart) {
          throw const AppError(
            'Upload could not make progress. Check your connection and try again.',
            code: 'NETWORK',
          );
        }

        offset = nextOffset.clamp(chunkStart, totalBytes).toInt();
        onProgress(offset / totalBytes);
        continue;
      }

      if (result.statusCode == 200 || result.statusCode == 201) {
        finalPayload = result.data;
        offset = totalBytes;
        onProgress(1);
        break;
      }

      throw _appErrorFromDriveStatus(result.statusCode);
    }

    final providerFileId = _driveFileIdFromPayload(finalPayload);
    if (providerFileId == null) {
      throw const AppError(
        'Upload reached storage but could not be confirmed. Please try again.',
        code: 'UPLOAD_FAILED',
      );
    }

    return providerFileId;
  }

  Future<_DriveUploadResult> _putDriveChunkWithRetry({
    required UploadSession session,
    required UploadFile file,
    required Uint8List chunk,
    required int chunkStart,
    required int chunkEndInclusive,
    required int totalBytes,
    required void Function(double progress) onProgress,
  }) async {
    for (var attempt = 1; attempt <= _maxChunkAttempts; attempt++) {
      try {
        final response = await dio.put<dynamic>(
          session.uploadUrl,
          data: chunk,
          options: Options(
            headers: _driveChunkHeaders(
              mimeType: file.mimeType,
              chunkLength: chunk.length,
              chunkStart: chunkStart,
              chunkEndInclusive: chunkEndInclusive,
              totalBytes: totalBytes,
            ),
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ),
          onSendProgress: (sent, _) {
            final uploaded = (chunkStart + sent).clamp(0, totalBytes).toInt();
            onProgress(uploaded / totalBytes);
          },
        );

        final statusCode = response.statusCode ?? 0;
        final result = _driveUploadResultFromResponse(response);
        final madeNoProgress =
            statusCode == 308 && (result.nextOffset ?? 0) <= chunkStart;

        if (attempt < _maxChunkAttempts &&
            (_isRetryableDriveStatus(statusCode) || madeNoProgress)) {
          final statusResult = await _queryDriveUploadStatus(
            session: session,
            totalBytes: totalBytes,
          );
          if (_canContinueFromDriveStatus(statusResult, chunkStart)) {
            return statusResult!;
          }

          await _chunkRetryDelay(attempt);
          continue;
        }

        return result;
      } on DioException catch (error) {
        if (attempt < _maxChunkAttempts && _isRetryableDioUpload(error)) {
          final statusResult = await _queryDriveUploadStatus(
            session: session,
            totalBytes: totalBytes,
          );
          if (_canContinueFromDriveStatus(statusResult, chunkStart)) {
            return statusResult!;
          }

          await _chunkRetryDelay(attempt);
          continue;
        }

        throw _appErrorFromDioUpload(error);
      }
    }

    throw const AppError(
      'Upload could not finish. Check your connection and try again.',
      code: 'NETWORK',
    );
  }

  Future<_DriveUploadResult?> _queryDriveUploadStatus({
    required UploadSession session,
    required int totalBytes,
  }) async {
    try {
      final response = await dio.put<dynamic>(
        session.uploadUrl,
        data: Uint8List(0),
        options: Options(
          headers: {
            'Content-Range': 'bytes */$totalBytes',
          },
          responseType: ResponseType.json,
          validateStatus: (_) => true,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode == 308 ||
          statusCode == 200 ||
          statusCode == 201 ||
          statusCode == 404) {
        return _driveUploadResultFromResponse(response);
      }

      return null;
    } on DioException {
      return null;
    }
  }

  Map<String, String> _driveChunkHeaders({
    required String mimeType,
    required int chunkLength,
    required int chunkStart,
    required int chunkEndInclusive,
    required int totalBytes,
  }) {
    final headers = <String, String>{
      'Content-Type': mimeType,
      'Content-Range': 'bytes $chunkStart-$chunkEndInclusive/$totalBytes',
    };

    // Browsers set Content-Length themselves and block apps from overriding it.
    if (!kIsWeb) {
      headers['Content-Length'] = chunkLength.toString();
    }

    return headers;
  }

  Future<CompletedUpload> _completeDirectUploadWithRetry({
    required UploadSession session,
    required String providerFileId,
    required int finalFileSizeBytes,
    required String? checksumHex,
  }) async {
    for (var attempt = 1; attempt <= _maxChunkAttempts; attempt++) {
      try {
        return await edgeFunctionService.call<CompletedUpload>(
          'complete-upload',
          body: {
            'media_file_id': session.mediaFileId,
            'storage_object_id': session.storageObjectId,
            'provider_file_id': providerFileId,
            'final_file_size_bytes': finalFileSizeBytes,
            if (checksumHex != null) 'checksum': checksumHex,
          },
          parser: (data) =>
              CompletedUpload.fromJson(Map<String, dynamic>.from(data as Map)),
        );
      } on AppError catch (error) {
        if (attempt < _maxChunkAttempts && error.code == 'NETWORK') {
          await _chunkRetryDelay(attempt);
          continue;
        }

        rethrow;
      }
    }

    throw const AppError(
      'Upload reached storage but could not be confirmed. Check the album before retrying.',
      code: 'UPLOAD_FAILED',
    );
  }

  Future<void> _markUploadFailed(UploadSession session) async {
    try {
      await edgeFunctionService.call<void>(
        'fail-upload',
        body: {
          'media_file_id': session.mediaFileId,
          'storage_object_id': session.storageObjectId,
        },
        parser: (_) {},
      );
    } catch (_) {
      // Best effort only; the visible upload error is more important.
    }
  }

  Future<CompletedUpload> _uploadWithLegacyEdgeProxy({
    required UploadSession session,
    required UploadFile file,
    required Uint8List bytes,
    required void Function(double progress) onProgress,
  }) async {
    onProgress(0.15);

    // Simulate granular progress while the upload POST is in-flight.
    // The edge function receives the full base64 body before responding, so
    // there is no real streaming progress signal. We advance from 15% toward
    // 90% using an ease-out curve based on a conservative 800 KB/s estimate,
    // then snap to 100% when the response arrives.
    const progressStart = 0.15;
    const progressTarget = 0.90;
    final uploadStart = DateTime.now();
    final estimatedMs = (bytes.length / 819.2).clamp(2000.0, 90000.0);
    final progressTimer =
        Timer.periodic(const Duration(milliseconds: 300), (_) {
      final elapsed = DateTime.now().difference(uploadStart).inMilliseconds;
      final t = (elapsed / estimatedMs).clamp(0.0, 1.0);
      final eased = 1 - (1 - t) * (1 - t);
      onProgress(progressStart + eased * (progressTarget - progressStart));
    });

    final CompletedUpload completed;
    try {
      completed = await edgeFunctionService.call<CompletedUpload>(
        'upload-original-file',
        body: {
          'media_file_id': session.mediaFileId,
          'storage_object_id': session.storageObjectId,
          'file_data_base64': base64Encode(bytes),
          'file_size_bytes': file.sizeBytes,
        },
        parser: (data) =>
            CompletedUpload.fromJson(Map<String, dynamic>.from(data as Map)),
      );
    } catch (e) {
      progressTimer.cancel();
      rethrow;
    }
    progressTimer.cancel();
    onProgress(1);

    return completed;
  }

  int _normalizeDriveChunkSize(int chunkSizeBytes) {
    final atLeastOneQuantum = math.max(chunkSizeBytes, _driveChunkQuantumBytes);
    final quanta = (atLeastOneQuantum / _driveChunkQuantumBytes).floor();
    return quanta * _driveChunkQuantumBytes;
  }

  int? _nextDriveOffset(Headers headers) {
    final values = headers['range'];
    if (values == null || values.isEmpty) return null;

    final match = RegExp(r'^bytes=0-(\d+)$').firstMatch(values.first.trim());
    if (match == null) return null;

    final lastByte = int.tryParse(match.group(1) ?? '');
    if (lastByte == null) return null;

    return lastByte + 1;
  }

  _DriveUploadResult _driveUploadResultFromResponse(
    Response<dynamic> response,
  ) {
    final statusCode = response.statusCode ?? 0;
    return _DriveUploadResult(
      statusCode: statusCode,
      nextOffset: statusCode == 308 ? _nextDriveOffset(response.headers) : null,
      data: response.data,
    );
  }

  bool _canContinueFromDriveStatus(
    _DriveUploadResult? result,
    int chunkStart,
  ) {
    if (result == null) return false;
    if (result.statusCode == 200 ||
        result.statusCode == 201 ||
        result.statusCode == 404) {
      return true;
    }

    return result.statusCode == 308 &&
        result.nextOffset != null &&
        result.nextOffset! > chunkStart;
  }

  bool _isRetryableDriveStatus(int statusCode) {
    return statusCode == 408 || statusCode == 429 || statusCode >= 500;
  }

  bool _isRetryableDioUpload(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) return _isRetryableDriveStatus(statusCode);

    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown;
  }

  Future<void> _chunkRetryDelay(int attempt) {
    return Future<void>.delayed(Duration(milliseconds: 400 * attempt));
  }

  AppError _appErrorFromDriveStatus(int statusCode) {
    if (statusCode == 404) {
      return const AppError(
        'Upload session expired. Please choose the original again and retry.',
        code: 'UPLOAD_FAILED',
      );
    }

    if (_isRetryableDriveStatus(statusCode)) {
      return const AppError(
        'Upload could not finish. Check your connection and try again.',
        code: 'NETWORK',
      );
    }

    return const AppError(
      'Upload was rejected by storage. Please try again.',
      code: 'UPLOAD_FAILED',
    );
  }

  AppError _appErrorFromDioUpload(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) return _appErrorFromDriveStatus(statusCode);

    return const AppError(
      'Upload could not reach storage. Check your connection and try again.',
      code: 'NETWORK',
    );
  }

  String? _driveFileIdFromPayload(Object? payload) {
    if (payload is Map) return payload['id']?.toString();

    if (payload is String && payload.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map) return decoded['id']?.toString();
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}

class _DriveUploadResult {
  const _DriveUploadResult({
    required this.statusCode,
    required this.data,
    this.nextOffset,
  });

  final int statusCode;
  final int? nextOffset;
  final Object? data;
}
