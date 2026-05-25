import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class DiscussionBoardRemoteDataSource {
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  });

  Future<void> sendComment({
    required String content,
    List<String> imageUrls = const <String>[],
    int? parentId,
    int? projectId,
  });

  Future<List<String>> uploadImages({
    required List<String> filePaths,
    void Function(int sent, int total)? onSendProgress,
  });

  Future<void> deleteComment({required int commentId});
}

class DiscussionBoardRemoteDataSourceImpl
    implements DiscussionBoardRemoteDataSource {
  DiscussionBoardRemoteDataSourceImpl(
    CoreHttpClient client, {
    CoreHttpClient? imageUploadClient,
    DiscussionBoardApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           DiscussionBoardApiClient(
             client,
             imageUploadClient: imageUploadClient,
           );

  final DiscussionBoardApiClient _apiClient;

  @override
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  }) async {
    return _apiClient.fetchCommentPage(
      startPage: startPage,
      limit: limit,
      projectId: projectId,
    );
  }

  @override
  Future<void> sendComment({
    required String content,
    List<String> imageUrls = const <String>[],
    int? parentId,
    int? projectId,
  }) async {
    await _apiClient.sendComment(
      content: content,
      imageUrls: imageUrls,
      parentId: parentId,
      projectId: projectId,
    );
  }

  @override
  Future<List<String>> uploadImages({
    required List<String> filePaths,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return _apiClient.uploadImages(
      filePaths: filePaths,
      onSendProgress: onSendProgress,
    );
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    await _apiClient.deleteComment(commentId: commentId);
  }
}
