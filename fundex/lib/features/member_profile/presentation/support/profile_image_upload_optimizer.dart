import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileImageSizeLimitException implements Exception {
  const ProfileImageSizeLimitException([this.message]);

  final String? message;

  @override
  String toString() {
    final detail = message?.trim() ?? '';
    return detail.isEmpty
        ? 'ProfileImageSizeLimitException'
        : 'ProfileImageSizeLimitException: $detail';
  }
}

class ProfileImageUploadOptimizer {
  const ProfileImageUploadOptimizer();

  static const int maxUploadBytes = 10 * 1024 * 1024;
  static const List<int> _qualitySteps = <int>[
    82,
    74,
    66,
    58,
    50,
    42,
    34,
    28,
    22,
    16,
  ];
  static const List<int> _dimensionSteps = <int>[1800, 1600, 1400, 1200, 1000];

  Future<String> ensureWithinUploadLimit(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      final sourceSize = await sourceFile.length();
      if (sourceSize <= maxUploadBytes) {
        _debugLog(
          'skip compression, sourceSize=${_formatBytes(sourceSize)}, '
          'limit=${_formatBytes(maxUploadBytes)}',
        );
        return sourcePath;
      }

      _debugLog(
        'start compression, sourceSize=${_formatBytes(sourceSize)}, '
        'limit=${_formatBytes(maxUploadBytes)}',
      );
      final tempDir = await Directory.systemTemp.createTemp(
        'fundex_upload_image_',
      );

      for (final dimension in _dimensionSteps) {
        for (final quality in _qualitySteps) {
          final compressedPath =
              '${tempDir.path}/image_${dimension}_$quality.jpg';
          final compressed = await FlutterImageCompress.compressAndGetFile(
            sourcePath,
            compressedPath,
            minWidth: dimension,
            minHeight: dimension,
            quality: quality,
            format: CompressFormat.jpeg,
            autoCorrectionAngle: true,
            keepExif: false,
          );
          final path = compressed?.path.trim() ?? '';
          if (path.isEmpty) {
            continue;
          }

          final compressedFile = File(path);
          final compressedSize = await compressedFile.length();
          _debugLog(
            'compressed candidate, dimension=$dimension, quality=$quality, '
            'size=${_formatBytes(compressedSize)}',
          );
          if (compressedSize <= maxUploadBytes) {
            _debugLog(
              'compression selected, outputSize=${_formatBytes(compressedSize)}',
            );
            return path;
          }

          await compressedFile.delete().catchError((Object _) {
            return compressedFile;
          });
        }
      }

      throw const ProfileImageSizeLimitException(
        'Unable to compress image below 10MB.',
      );
    } on ProfileImageSizeLimitException {
      rethrow;
    } catch (error) {
      throw ProfileImageSizeLimitException(error.toString());
    }
  }

  void _debugLog(String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('[ProfileImageUploadOptimizer] $message');
  }

  String _formatBytes(int bytes) {
    final mb = bytes / 1000000;
    return '${mb.toStringAsFixed(2)}MB($bytes bytes)';
  }
}
