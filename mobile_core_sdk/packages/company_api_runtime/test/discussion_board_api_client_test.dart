import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

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
  group('DiscussionBoardApiClient', () {
    test('fetchCommentPage posts payload and parses rows', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(DiscussionBoardApiPaths.commentPage));
        expect(options.extra['auth_required'], isFalse);
        expect(
          options.data,
          equals(<String, dynamic>{
            'startPage': 1,
            'limit': 50,
            'projectId': 123,
          }),
        );

        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"id":101,"userId":1001,"username":"佐藤","content":"主贴内容","createTime":"2026-03-12T08:00:00Z","projectId":123,"projectName":"プレミアムレジデンス赤坂","quote":{"id":99,"username":"山田","content":"前文","createTime":"2026-03-12T07:00:00Z"}}]}}',
        );
      });
      final api = DiscussionBoardApiClient(client);

      final rows = await api.fetchCommentPage(projectId: 123);

      expect(rows, hasLength(1));
      expect(rows.first.id, equals(101));
      expect(rows.first.quote?.id, equals(99));
    });

    test('sendComment posts payload and checks success envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(DiscussionBoardApiPaths.commentSend));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'content': '新留言',
            'parentId': 101,
            'projectId': 123,
          }),
        );
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = DiscussionBoardApiClient(client);

      await api.sendComment(content: '新留言', parentId: 101, projectId: 123);
    });

    test('deleteComment hits endpoint with commentId query', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('DELETE'));
        expect(options.path, equals(DiscussionBoardApiPaths.commentDelete));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.queryParameters,
          equals(<String, dynamic>{'commentId': 101}),
        );
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = DiscussionBoardApiClient(client);

      await api.deleteComment(commentId: 101);
    });
  });
}
