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
  group('ContactApiClient', () {
    test('submitContactWe posts request and checks success envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(ContactApiPaths.contactWe));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'familyName': '山田',
            'name': '太郎',
            'furiganaFamilyName': 'ヤマダ',
            'furiganaName': 'タロウ',
            'email': 'taro@example.com',
            'questionCategory': 'アカウントについて',
            'question': 'ログインできません。',
          }),
        );
        return _jsonOk('{"msg":"success","code":200,"data":true}');
      });
      final api = ContactApiClient(dioForPath: (_) => dio);

      await api.submitContactWe(
        const ContactWeRequestDto(
          familyName: '山田',
          name: '太郎',
          furiganaFamilyName: 'ヤマダ',
          furiganaName: 'タロウ',
          email: 'taro@example.com',
          questionCategory: 'アカウントについて',
          question: 'ログインできません。',
        ),
      );
    });

    test('submitContactWe throws when data is false', () async {
      final dio = _buildDio((_) async {
        return _jsonOk('{"msg":"success","code":200,"data":false}');
      });
      final api = ContactApiClient(dioForPath: (_) => dio);

      expect(
        () => api.submitContactWe(
          const ContactWeRequestDto(
            familyName: '山田',
            name: '太郎',
            furiganaFamilyName: '',
            furiganaName: '',
            email: 'taro@example.com',
            questionCategory: 'その他',
            question: '問い合わせ内容',
          ),
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
