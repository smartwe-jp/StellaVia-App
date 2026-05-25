import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DiscussionBoardDraftImageStore {
  const DiscussionBoardDraftImageStore();

  Future<String?> persist(String sourcePath) async {
    final normalized = sourcePath.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final sourceFile = File(normalized);
    if (!await sourceFile.exists()) {
      return null;
    }

    final supportDirectory = await getApplicationSupportDirectory();
    final imageDirectory = Directory(
      '${supportDirectory.path}/discussion_board/draft_images',
    );
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final extension = _resolveExtension(normalized);
    final fileName = 'draft_${DateTime.now().microsecondsSinceEpoch}$extension';
    final outputPath = '${imageDirectory.path}/$fileName';
    await sourceFile.copy(outputPath);
    return outputPath;
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
