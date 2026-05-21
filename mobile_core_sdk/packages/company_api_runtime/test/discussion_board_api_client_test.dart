import 'dart:async';
import 'dart:io';

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
    late Directory tempDir;
    late File imageFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'discussion_board_api_client_test',
      );
      imageFile = File('${tempDir.path}/comment.jpg');
      await imageFile.writeAsBytes(const <int>[1, 2, 3, 4]);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

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
          '{"msg":"success","code":200,"data":{"rows":[{"id":101,"userId":1001,"username":"佐藤","avatar":"https://cdn.example.com/avatar-root.png","content":"主贴内容","imageUrls":["https://cdn.example.com/comment.png"],"createTime":"2026-03-12T08:00:00Z","projectId":123,"projectName":"プレミアムレジデンス赤坂","quote":{"id":99,"username":"山田","avatar":"https://cdn.example.com/avatar-quote.png","content":"前文","imageUrls":["https://cdn.example.com/quote.png"],"createTime":"2026-03-12T07:00:00Z"}}]}}',
        );
      });
      final api = DiscussionBoardApiClient(client);

      final rows = await api.fetchCommentPage(projectId: 123);

      expect(rows, hasLength(1));
      expect(rows.first.id, equals(101));
      expect(
        rows.first.avatar,
        equals('https://cdn.example.com/avatar-root.png'),
      );
      expect(rows.first.quote?.id, equals(99));
      expect(
        rows.first.imageUrls,
        equals(<String>['https://cdn.example.com/comment.png']),
      );
      expect(
        rows.first.quote?.avatar,
        equals('https://cdn.example.com/avatar-quote.png'),
      );
      expect(
        rows.first.quote?.imageUrls,
        equals(<String>['https://cdn.example.com/quote.png']),
      );
    });

    test(
      'fetchCommentPage uses primary client when image upload client exists',
      () async {
        var primaryCallCount = 0;
        var imageUploadCallCount = 0;
        final client = _buildClient((options) async {
          primaryCallCount += 1;
          expect(options.path, equals(DiscussionBoardApiPaths.commentPage));
          expect(options.extra['auth_required'], isFalse);
          return _jsonOk('{"msg":"success","code":200,"data":{"rows":[]}}');
        });
        final imageUploadClient = _buildClient((options) async {
          imageUploadCallCount += 1;
          fail('comment page should not use image upload client');
        });
        final api = DiscussionBoardApiClient(
          client,
          imageUploadClient: imageUploadClient,
        );

        final rows = await api.fetchCommentPage();

        expect(rows, isEmpty);
        expect(primaryCallCount, equals(1));
        expect(imageUploadCallCount, equals(0));
      },
    );

    test('sendComment posts payload and checks success envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(DiscussionBoardApiPaths.commentSend));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'content': '新留言',
            'imageUrls': <String>['https://cdn.example.com/comment.png'],
            'parentId': 101,
            'projectId': 123,
          }),
        );
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = DiscussionBoardApiClient(client);

      await api.sendComment(
        content: '新留言',
        imageUrls: const <String>['https://cdn.example.com/comment.png'],
        parentId: 101,
        projectId: 123,
      );
    });

    test(
      'uploadImages posts multipart files and returns uploaded urls',
      () async {
        final client = _buildClient((options) async {
          fail('uploadImages should use image upload client when provided');
        });
        final imageUploadClient = _buildClient((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(DiscussionBoardApiPaths.imageUpload));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.contentType,
            startsWith(Headers.multipartFormDataContentType),
          );
          expect(options.data, isA<FormData>());
          final formData = options.data as FormData;
          expect(formData.files, hasLength(1));
          expect(formData.files.single.key, equals('files'));
          return _jsonOk(
            '{"msg":"success","code":200,"data":["https://cdn.example.com/comment.jpg"]}',
          );
        });
        final api = DiscussionBoardApiClient(
          client,
          imageUploadClient: imageUploadClient,
        );

        final urls = await api.uploadImages(
          filePaths: <String>[imageFile.path],
        );

        expect(urls, equals(<String>['https://cdn.example.com/comment.jpg']));
      },
    );

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
