import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/discussion_board/data/datasources/discussion_board_remote_data_source.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    return null;
  }
}

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

CoreHttpClient _buildClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);

  return CoreHttpClient(
    baseUrl: 'https://api.example.com/api',
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

void main() {
  group('DiscussionBoardRemoteDataSourceImpl', () {
    test('comment endpoints should include crowdfunding prefix', () {
      expect(
        DiscussionBoardApiPaths.commentPage,
        '/crowdfunding/offline/comment-page',
      );
      expect(DiscussionBoardApiPaths.commentSend, '/crowdfunding/comment/send');
      expect(
        DiscussionBoardApiPaths.commentDelete,
        '/crowdfunding/comment/delete',
      );
    });

    test('fetchCommentPage posts payload and parses rows', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, DiscussionBoardApiPaths.commentPage);
        expect(options.extra['auth_required'], false);
        expect(options.data, <String, dynamic>{
          'startPage': 1,
          'limit': 50,
          'projectId': 123,
        });

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"total":2,"limit":50,"currentPage":1,"rows":[{"id":101,"userId":1001,"username":"佐藤","content":"主贴内容","createTime":"2026-03-12T08:00:00Z","projectId":123,"projectName":"プレミアムレジデンス赤坂"},{"id":102,"userId":1002,"username":"高橋","content":"回复内容","createTime":"2026-03-12T08:30:00Z","projectId":123,"projectName":"プレミアムレジデンス赤坂","quote":{"id":101,"username":"佐藤","content":"主贴内容","createTime":"2026-03-12T08:00:00Z"}}]}}',
        );
      });
      final source = DiscussionBoardRemoteDataSourceImpl(client);

      final rows = await source.fetchCommentPage(projectId: 123);

      expect(rows, hasLength(2));
      expect(rows.first.id, 101);
      expect(rows.first.userId, 1001);
      expect(rows.first.username, '佐藤');
      expect(rows.first.projectId, 123);
      expect(rows.last.quote?.id, 101);
      expect(rows.last.quote?.username, '佐藤');
    });

    test('sendComment posts payload and validates success envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'POST');
        expect(options.path, DiscussionBoardApiPaths.commentSend);
        expect(options.extra['auth_required'], true);
        expect(options.data, <String, dynamic>{
          'content': '新留言',
          'parentId': 101,
          'projectId': 123,
        });
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final source = DiscussionBoardRemoteDataSourceImpl(client);

      await source.sendComment(content: '新留言', parentId: 101, projectId: 123);
    });

    test('deleteComment hits delete endpoint with commentId', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'DELETE');
        expect(options.path, DiscussionBoardApiPaths.commentDelete);
        expect(options.extra['auth_required'], true);
        expect(options.queryParameters, <String, dynamic>{'commentId': 101});
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final source = DiscussionBoardRemoteDataSourceImpl(client);

      await source.deleteComment(commentId: 101);
    });
  });
}
