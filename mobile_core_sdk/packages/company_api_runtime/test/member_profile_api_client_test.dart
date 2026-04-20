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

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

void main() {
  group('MemberProfileApiClient', () {
    late Directory tempDir;
    late File imageFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'member_profile_api_client_test',
      );
      imageFile = File('${tempDir.path}/avatar.jpg');
      await imageFile.writeAsBytes(const <int>[1, 2, 3, 4]);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('uploadAvatar posts multipart and returns uploaded url', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(MemberProfileApiPaths.uploadAvatar));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.contentType,
          startsWith(Headers.multipartFormDataContentType),
        );
        expect(options.data, isA<FormData>());

        return _jsonOk(
          '{"msg":"success","code":200,"data":"https://cdn.example.com/avatar.jpg"}',
        );
      });
      final api = MemberProfileApiClient(dioForPath: (_) => dio);

      final url = await api.uploadAvatar(filePath: imageFile.path);

      expect(url, equals('https://cdn.example.com/avatar.jpg'));
    });
  });
}
