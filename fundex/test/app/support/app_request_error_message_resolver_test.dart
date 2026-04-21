import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/support/app_request_error_message_resolver.dart';

void main() {
  group('resolveAppRequestErrorMessage', () {
    test('returns backend message for 4xx responses', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/member/email/verify'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/member/email/verify'),
          statusCode: 400,
          data: <String, dynamic>{'message': '验证码错误'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        resolveAppRequestErrorMessage(error, 'fallback'),
        '验证码错误',
      );
    });

    test('returns fallback for 5xx responses', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/member/email/verify'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/member/email/verify'),
          statusCode: 500,
          data: <String, dynamic>{'message': 'internal server error'},
        ),
        type: DioExceptionType.badResponse,
      );

      expect(
        resolveAppRequestErrorMessage(error, 'fallback'),
        'fallback',
      );
    });

    test('returns fallback for mapped 5xx network failures', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/member/email/verify'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/member/email/verify'),
          statusCode: 500,
          data: <String, dynamic>{'message': 'internal server error'},
        ),
        type: DioExceptionType.badResponse,
      );
      final failure = mapDioExceptionToFailure(dioError);

      expect(
        resolveAppRequestErrorMessage(failure, 'fallback'),
        'fallback',
      );
    });

    test('returns fallback for internal server error state errors', () {
      expect(
        resolveAppRequestErrorMessage(
          StateError('internal server error'),
          'fallback',
        ),
        'fallback',
      );
    });
  });
}
