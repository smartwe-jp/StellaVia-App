import '../entities/discussion_board_models.dart';

abstract class DiscussionBoardRepository {
  Future<List<DiscussionThread>> loadThreads({int page = 1, int limit = 50});

  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
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
  });

  Future<List<DiscussionThread>> deleteComment({required String commentId});
}
