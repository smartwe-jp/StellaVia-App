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

ResponseBody _textOk(String body) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['text/plain;charset=utf-8'],
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

    test(
      'attachment bytes require credentials only on the API origin',
      () async {
        final requests = <RequestOptions>[];
        final api = MemberProfileApiClient(
          dioForPath: (_) => _buildDio((options) async {
            requests.add(options);
            return ResponseBody.fromBytes([37, 80, 68, 70, 45], 200);
          }),
        );
        for (final url in [
          '/files/registry',
          'https://cdn.example.com/files/registry',
        ]) {
          expect(await api.fetchCorporateAttachment(url), [37, 80, 68, 70, 45]);
        }
        expect(requests.map((o) => o.extra['auth_required']), [true, false]);
        await expectLater(
          api.fetchCorporateAttachment('file:///private/document'),
          throwsFormatException,
        );
        expect(requests, hasLength(2));
      },
    );
    test(
      'member review validates and sends authenticated mail actions',
      () async {
        final requests = <dynamic>[];
        var body = '{"code":200}';
        final api = MemberProfileApiClient(
          dioForPath: (_) => _buildDio((options) async {
            expect(options.path, MemberProfileApiPaths.corporateReview);
            expect(options.method, 'POST');
            expect(options.extra['auth_required'], true);
            requests.add(options.data);
            return _jsonOk(body);
          }),
        );
        expect(
          () => api.reviewCorporate(
            id: 7,
            reviewOp: 'CUSTOMER_MAILED',
            customerMessage: '  ',
          ),
          throwsArgumentError,
        );
        expect(
          () => api.reviewCorporate(
            id: 7,
            reviewOp: 'APPROVED',
            customerMessage: 'no',
          ),
          throwsArgumentError,
        );
        await api.reviewCorporate(
          id: 7,
          reviewOp: 'CUSTOMER_MAILED',
          customerMessage: '  本日郵送しました  ',
        );
        await api.reviewCorporate(
          id: 7,
          reviewOp: 'RECEIVED',
          customerMessage: '',
        );
        expect(requests, [
          {
            'id': 7,
            'reviewOp': 'CUSTOMER_MAILED',
            'customerMessage': '本日郵送しました',
          },
          {'id': 7, 'reviewOp': 'RECEIVED'},
        ]);
        body = '{"code":403}';
        await expectLater(
          api.reviewCorporate(
            id: 7,
            reviewOp: 'RECEIVED',
            customerMessage: 'ok',
          ),
          throwsStateError,
        );
      },
    );

    test(
      'corporate submit sends authenticated JSON and requires a successful business code',
      () async {
        var body = '{"code":200,"data":{"verificationStatus":"SUBMITTED"}}';
        final app = {
          'applicantType': 'corporate',
          'declarations': {'antiSocial': true, 'mail': true},
        };
        final api = MemberProfileApiClient(
          dioForPath: (_) => _buildDio((options) async {
            expect(options.path, MemberProfileApiPaths.corporateSubmit);
            expect(options.method, 'POST');
            expect(options.extra['auth_required'], true);
            expect(options.data, app);
            return _jsonOk(body);
          }),
        );
        await api.submitCorporate(app);
        body = '{"code":400,"msg":"invalid documents"}';
        await expectLater(api.submitCorporate(app), throwsStateError);
        body = '{}';
        await expectLater(api.submitCorporate(app), throwsFormatException);
      },
    );
    test(
      'uploads corporate material with auth and reads its file reference',
      () async {
        final dio = _buildDio((options) async {
          expect(options.path, MemberProfileApiPaths.corporateUpload);
          expect(options.method, 'POST');
          expect(options.extra['auth_required'], isTrue);
          final part = (options.data as FormData).files.single;
          expect(part.key, 'file');
          expect(part.value.filename, 'registry.pdf');
          expect(part.value.contentType.toString(), 'application/pdf');
          return _jsonOk('{"code":200,"data":{"fileId":17,"url":"/files/17"}}');
        });
        final result = await MemberProfileApiClient(dioForPath: (_) => dio)
            .uploadCorporateDocument(
              filename: 'registry.pdf',
              bytes: '%PDF-test'.codeUnits,
              mimeType: 'application/pdf',
            );
        expect(result, (fileId: '17', url: '/files/17'));
      },
    );

    test('accepts corporate upload URL strings only on success', () async {
      const url = 'https://example.com/uploads/registry.pdf';
      var body = '{"msg":"success","code":200,"data":"$url"}';
      final api = MemberProfileApiClient(
        dioForPath: (_) => _buildDio((_) async => _jsonOk(body)),
      );
      Future<({String fileId, String url})> upload() =>
          api.uploadCorporateDocument(
            filename: 'registry.pdf',
            bytes: '%PDF-test'.codeUnits,
            mimeType: 'application/pdf',
          );
      expect(await upload(), (fileId: '', url: url));
      body = '{"code":400,"data":"$url"}';
      await expectLater(upload(), throwsStateError);
      body = '{"code":200,"data":" "}';
      await expectLater(upload(), throwsFormatException);
    });

    test(
      'fetchRegionsByZip maps ZipCloud address fields to existing regions',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('GET'));
          expect(
            options.uri.toString(),
            equals('https://zipcloud.ibsnet.co.jp/api/search?zipcode=9201154'),
          );
          expect(options.extra['auth_required'], isFalse);

          return _textOk(
            '{"message":null,"results":[{"address1":"石川県",'
            '"address2":"金沢市","address3":"太陽が丘",'
            '"kana1":"ｲｼｶﾜｹﾝ","kana2":"ｶﾅｻﾞﾜｼ","kana3":"ﾀｲﾖｳｶﾞｵｶ",'
            '"prefcode":"17","zipcode":"9201154"}],"status":200}',
          );
        });
        final api = MemberProfileApiClient(dioForPath: (_) => dio);

        final regions = await api.fetchRegionsByZip(zip: '9201154');

        expect(regions, hasLength(2));
        expect(regions[0].jpName, equals('石川県'));
        expect(regions[0].regionType, equals(0));
        expect(regions[1].jpName, equals('金沢市太陽が丘'));
        expect(regions[1].regionType, equals(1));
        expect(regions.every((region) => region.regionId == null), isTrue);
      },
    );

    test(
      'fetchRegionsByZip returns empty regions when no result exists',
      () async {
        final dio = _buildDio(
          (_) async => _jsonOk('{"message":null,"results":null,"status":200}'),
        );
        final api = MemberProfileApiClient(dioForPath: (_) => dio);

        final regions = await api.fetchRegionsByZip(zip: '0000000');

        expect(regions, isEmpty);
      },
    );

    test('fetchRegionsByZip throws ZipCloud business error', () async {
      final dio = _buildDio(
        (_) async => _jsonOk(
          '{"message":"パラメータ「郵便番号」の桁数が不正です。",'
          '"results":null,"status":400}',
        ),
      );
      final api = MemberProfileApiClient(dioForPath: (_) => dio);

      expect(
        () => api.fetchRegionsByZip(zip: '123'),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'パラメータ「郵便番号」の桁数が不正です。',
          ),
        ),
      );
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
