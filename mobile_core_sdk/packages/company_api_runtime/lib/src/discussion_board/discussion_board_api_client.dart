import 'dart:io';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'discussion_comment_dto.dart';

class DiscussionBoardApiPaths {
  const DiscussionBoardApiPaths._();

  static const String commentPage = '/crowdfunding/offline/comment-page';
  static const String commentSend = '/crowdfunding/comment/send';
  static const String commentDelete = '/crowdfunding/comment/delete';
  static const String imageUpload = '/crowdfunding/comment/add-comment-photos';
}

class DiscussionBoardApiClient {
  DiscussionBoardApiClient(
    this._client, {
    CoreHttpClient? imageUploadClient,
    LegacyEnvelopeCodec? envelopeCodec,
    this.commentPagePath = DiscussionBoardApiPaths.commentPage,
    this.commentSendPath = DiscussionBoardApiPaths.commentSend,
    this.commentDeletePath = DiscussionBoardApiPaths.commentDelete,
    this.imageUploadPath = DiscussionBoardApiPaths.imageUpload,
  }) : _imageUploadClient = imageUploadClient ?? _client,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec();

  final CoreHttpClient _client;
  final CoreHttpClient _imageUploadClient;
  final LegacyEnvelopeCodec _envelopeCodec;
  final String commentPagePath;
  final String commentSendPath;
  final String commentDeletePath;
  final String imageUploadPath;

  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  }) async {
    final payload = <String, dynamic>{'startPage': startPage, 'limit': limit};
    if (projectId != null) {
      payload['projectId'] = projectId;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      commentPagePath,
      data: payload,
      options: authRequired(false),
    );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load comments.',
    );
    return rows
        .map((Map<String, dynamic> row) => DiscussionCommentDto.fromJson(row))
        .toList(growable: false);
  }

  Future<void> sendComment({
    required String content,
    List<String> imageUrls = const <String>[],
    int? parentId,
    int? projectId,
  }) async {
    final payload = <String, dynamic>{
      'content': content.trim(),
      'imageUrls': imageUrls,
    };
    if (parentId != null) {
      payload['parentId'] = parentId;
    }
    if (projectId != null) {
      payload['projectId'] = projectId;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      commentSendPath,
      data: payload,
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send comment.',
      requireTruthyData: true,
    );
  }

  Future<List<String>> uploadImages({
    required List<String> filePaths,
    ProgressCallback? onSendProgress,
  }) async {
    final normalizedPaths = filePaths
        .map(_normalizeAndValidatePath)
        .toList(growable: false);
    if (normalizedPaths.isEmpty) {
      return const <String>[];
    }

    final formData = FormData();
    for (final path in normalizedPaths) {
      formData.files.add(
        MapEntry<String, MultipartFile>(
          'files',
          await MultipartFile.fromFile(path),
        ),
      );
    }

    final response = await _imageUploadClient.dio.post<Map<String, dynamic>>(
      imageUploadPath,
      data: formData,
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
      onSendProgress: onSendProgress,
    );

    return _extractUploadedUrls(_envelopeCodec.toJsonMap(response.data));
  }

  Future<void> deleteComment({required int commentId}) async {
    final response = await _client.dio.delete<Map<String, dynamic>>(
      commentDeletePath,
      queryParameters: <String, dynamic>{'commentId': commentId},
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to delete comment.',
      requireTruthyData: true,
    );
  }

  String _normalizeAndValidatePath(String filePath) {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError('Failed to upload comment image.');
    }

    final file = File(normalizedPath);
    if (!file.existsSync()) {
      throw StateError('Failed to upload comment image.');
    }
    return normalizedPath;
  }

  List<String> _extractUploadedUrls(Map<String, dynamic> payload) {
    const fallbackMessage = 'Failed to upload comment image.';
    if (payload.isEmpty) {
      throw StateError(fallbackMessage);
    }
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: fallbackMessage,
      requireTruthyData: true,
    );
    final rawUrls = payload[(_envelopeCodec.profile.dataKey)];
    if (rawUrls is! List) {
      throw StateError(fallbackMessage);
    }
    final urls = rawUrls
        .map((dynamic value) => value?.toString().trim() ?? '')
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
    if (urls.isEmpty) {
      throw StateError(fallbackMessage);
    }
    return urls;
  }
}
