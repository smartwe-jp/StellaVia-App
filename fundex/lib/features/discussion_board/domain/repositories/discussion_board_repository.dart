import '../entities/discussion_board_models.dart';

abstract class DiscussionBoardRepository {
  Future<List<DiscussionThread>> loadThreads({int page = 1, int limit = 50});

  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    List<String> imageUrls = const <String>[],
    String? fallbackAvatarUrl,
    int? linkedProjectId,
    String? linkedProjectName,
  });

  Future<List<DiscussionThread>> submitReply({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    List<String> imageUrls = const <String>[],
    int? linkedProjectId,
  });

  Future<List<String>> uploadImages({required List<String> filePaths});

  Future<List<DiscussionThread>> deleteComment({required String commentId});
}
