import 'dart:typed_data';
import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

void main() {
  for (final scenario in [
    'success',
    'no permission',
    'upload refused',
    'confirm refused',
  ]) {
    test('electronic signature: $scenario', () async {
      final dio = Dio();
      final calls = <String>[];
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            final action = request.path.split('/').last;
            calls.add(action);
            expect(request.extra['auth_required'], isTrue);
            Object data;
            switch (action) {
              case 'details':
                expect(request.queryParameters, {'id': '92'});
                data = {
                  'noticeType': 7,
                  'opList': [if (scenario != 'no permission') 'done'],
                };
              case 'upload':
                final form = request.data as FormData;
                expect(Map.fromEntries(form.fields), {
                  'bizId': '92',
                  'index': '1',
                });
                expect(form.files.single.value.filename, 'signature.png');
                data = scenario != 'upload refused';
              case 'confirm':
                expect(request.data, {'bizId': '92', 'contractTypeValue': 7});
                data = scenario != 'confirm refused';
              default:
                throw StateError(action);
            }
            handler.resolve(
              Response(
                requestOptions: request,
                data: {'code': 0, 'data': data},
              ),
            );
          },
        ),
      );
      final result = ElectronicContractApiClient(dio).sign('92', Uint8List(8));
      if (scenario == 'success') {
        await result;
      } else {
        await expectLater(result, throwsStateError);
      }
      expect(calls, [
        'details',
        if (scenario != 'no permission') 'upload',
        if (scenario == 'success' || scenario == 'confirm refused') 'confirm',
      ]);
    });
  }
}
