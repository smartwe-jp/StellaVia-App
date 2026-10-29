import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

void main() {
  test('hotel descriptions and nullable point quote survive decoding', () {
    expect(
      HotelSummaryDto.fromJson({'hotelId': '66', 'detail': '紹介'}).detail,
      '紹介',
    );
    expect(
      HotelRoomExtraPersonResultDto.fromJson({'pointTotal': '1200'}).pointTotal,
      1200,
    );
    expect(HotelRoomExtraPersonResultDto.fromJson({}).pointTotal, isNull);
    expect(
      HotelRoomExtraPersonResultDto.fromJson({'pointTotal': 0}).pointTotal,
      0,
    );
  });
  test(
    'investment filter is optional and forwarded without changing old calls',
    () async {
      final bodies = <Object?>[];
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            bodies.add(options.data);
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'code': 200,
                  'data': {'rows': []},
                },
              ),
            );
          },
        ),
      );
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);
      await api.fetchInvestmentList();
      await api.fetchInvestmentList(projectStatus: 1, startPage: 2, limit: 100);
      expect(bodies, [
        {'startPage': 1, 'limit': 20},
        {'startPage': 2, 'limit': 100, 'projectStatus': 1},
      ]);
    },
  );
}
