import '../entities/discussion_board_models.dart';
import '../repositories/discussion_board_repository.dart';

class SubmitDiscussionReplyUseCase {
  const SubmitDiscussionReplyUseCase(this._repository);

  final DiscussionBoardRepository _repository;

  Future<List<DiscussionThread>> call({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    List<String> imageUrls = const <String>[],
  }) {
    return _repository.submitReply(
      threadId: threadId,
      content: content,
      nowLabel: nowLabel,
      fallbackName: fallbackName,
      fallbackHandle: fallbackHandle,
      fallbackBadgeLabel: fallbackBadgeLabel,
      imageUrls: imageUrls,
    );
  }
}
