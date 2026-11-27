import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

void main() {
  for (final status in [400, 503]) {
    test('preserves backend messages for HTTP $status', () {
      final request = RequestOptions(path: '/login');
      final error = DioException(
        requestOptions: request,
        response: Response(
          requestOptions: request,
          statusCode: status,
          data: {
            'msg': '  ',
            'message': {'error_description': '  再試行してください  '},
          },
        ),
      );
      expect(authErrorMessage(error), '再試行してください');
    });
  }
  test('missing backend text allows localized fallback', () {
    expect(
      authResponseMessage({'code': 500, 'message': '  ', 'data': false}),
      isNull,
    );
    expect(authErrorMessage(StateError(' ')), isNull);
    expect(
      authErrorMessage(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          message: 'Connection error',
        ),
      ),
      isNull,
    );
  });
}
