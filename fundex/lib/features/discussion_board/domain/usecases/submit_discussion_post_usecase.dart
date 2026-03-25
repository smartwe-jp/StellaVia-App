import '../entities/discussion_board_models.dart';
import '../repositories/discussion_board_repository.dart';

class SubmitDiscussionPostUseCase {
  const SubmitDiscussionPostUseCase(this._repository);

  final DiscussionBoardRepository _repository;

  Future<List<DiscussionThread>> call({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
    int? linkedProjectId,
    String? linkedProjectName,
  }) {
    return _repository.submitPost(
      content: content,
      nowLabel: nowLabel,
      fallbackName: fallbackName,
      fallbackHandle: fallbackHandle,
      fallbackBadgeLabel: fallbackBadgeLabel,
      linkedProjectId: linkedProjectId,
      linkedProjectName: linkedProjectName,
    );
  }
}
