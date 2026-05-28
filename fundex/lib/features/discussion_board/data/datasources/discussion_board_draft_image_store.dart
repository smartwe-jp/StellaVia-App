import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DiscussionBoardDraftImageStore {
  const DiscussionBoardDraftImageStore();

  static const String _relativeDirectory = 'discussion_board/draft_images';

  Future<String?> persist(String sourcePath) async {
    final normalized = sourcePath.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final existingReference = await _existingDraftImageReference(normalized);
    if (existingReference != null) {
      return existingReference;
    }

    final sourceFile = File(normalized);
    if (!await sourceFile.exists()) {
      return null;
    }

    final imageDirectory = await _ensureImageDirectory();
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final extension = _resolveExtension(normalized);
    final fileName = 'draft_${DateTime.now().microsecondsSinceEpoch}$extension';
    final outputPath = '${imageDirectory.path}/$fileName';
    await sourceFile.copy(outputPath);
    return '$_relativeDirectory/$fileName';
  }

  Future<String?> persistForDisplay(String sourcePath) async {
    final reference = await persist(sourcePath);
    if (reference == null) {
      return null;
    }
    return resolve(reference);
  }

  Future<String?> resolve(String path) async {
    final normalized = path.trim();
    if (normalized.isEmpty) {
      return null;
    }

    if (_isDraftImageReference(normalized)) {
      final supportDirectory = await getApplicationSupportDirectory();
      final file = File('${supportDirectory.path}/$normalized');
      return await file.exists() ? file.path : null;
    }

    final file = File(normalized);
    return await file.exists() ? file.path : null;
  }

  Future<List<String>> persistAll(Iterable<String> sourcePaths) async {
    final persisted = <String>[];
    for (final sourcePath in sourcePaths) {
      final reference = await persist(sourcePath);
      if (reference != null && reference.isNotEmpty) {
        persisted.add(reference);
      }
    }
    return persisted;
  }

  Future<List<String>> resolveAll(Iterable<String> paths) async {
    final resolved = <String>[];
    for (final path in paths) {
      final absolutePath = await resolve(path);
      if (absolutePath != null && absolutePath.isNotEmpty) {
        resolved.add(absolutePath);
      }
    }
    return resolved;
  }

  Future<String?> _existingDraftImageReference(String path) async {
    if (_isDraftImageReference(path)) {
      final resolved = await resolve(path);
      return resolved == null ? null : path;
    }

    final imageDirectory = await _ensureImageDirectory();
    final directoryPath = _withTrailingSlash(imageDirectory.path);
    if (!path.startsWith(directoryPath)) {
      return null;
    }

    final file = File(path);
    if (!await file.exists()) {
      return null;
    }
    return '$_relativeDirectory/${path.substring(directoryPath.length)}';
  }

  Future<Directory> _ensureImageDirectory() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final imageDirectory = Directory(
      '${supportDirectory.path}/$_relativeDirectory',
    );
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }
    return imageDirectory;
  }

  bool _isDraftImageReference(String path) {
    return path == _relativeDirectory ||
        path.startsWith('$_relativeDirectory/');
  }

  String _withTrailingSlash(String path) {
    return path.endsWith('/') ? path : '$path/';
  }

  String _resolveExtension(String path) {
    final fileName = path.split('/').last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return '.jpg';
    }
    final extension = fileName.substring(dotIndex).toLowerCase();
    return extension.length > 12 ? '.jpg' : extension;
  }
}
