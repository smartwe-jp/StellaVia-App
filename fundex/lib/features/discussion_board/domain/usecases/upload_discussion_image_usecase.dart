import '../repositories/discussion_board_repository.dart';

class UploadDiscussionImageUseCase {
  const UploadDiscussionImageUseCase(this._repository);

  final DiscussionBoardRepository _repository;

  Future<List<String>> call({
    required List<String> filePaths,
    DiscussionUploadProgressCallback? onSendProgress,
  }) {
    return _repository.uploadImages(
      filePaths: filePaths,
      onSendProgress: onSendProgress,
    );
  }
}
