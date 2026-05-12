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
  final dio = Dio(BaseOptions(baseUrl: 'https://hotel.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);

  return CoreHttpClient(
    baseUrl: 'https://hotel.example.com/api',
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

void main() {
  group('HotelApiClient', () {
    test('searchHotels posts legacy payload and parses hotel list', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.hotelSearch));
        expect(options.extra['auth_required'], isFalse);
        expect(
          options.data,
          equals(<String, dynamic>{
            'startPage': 1,
            'limit': 20,
            'startDate': '2026-06-01',
            'endDate': '2026-06-03',
            'keyWord': 'Tokyo',
            'lang': 'JP',
            'area': 'tokyo',
            'buildingCode': 'hotel',
            'priceSort': 'asc',
            'occupancy': 2,
            'kids': 1,
            'roomNum': 1,
          }),
        );

        return _jsonOk(
          '{"code":200,"msg":"success","data":{"count":1,"showStatus":"2","showStatusStr":"limited","hotels":[{"id":"h1","hotelName":"Tokyo Business Stay","address":"Shinagawa","image":"https://cdn.example.com/h1.jpg","price":18000,"bookingType":2,"bookingStatus":true,"lat":35.628,"lng":139.738,"tags":["station","business"]}]}}',
        );
      });
      final api = HotelApiClient(client);

      final result = await api.searchHotels(
        const HotelSearchRequestDto(
          startDate: '2026-06-01',
          endDate: '2026-06-03',
          keyWord: 'Tokyo',
          lang: 'JP',
          area: 'tokyo',
          buildingCode: 'hotel',
          priceSort: 'asc',
          occupancy: 2,
          kids: 1,
        ),
      );

      expect(result.count, equals(1));
      expect(result.showStatus, equals('2'));
      expect(result.hotels, hasLength(1));
      expect(result.hotels.first.id, equals('h1'));
      expect(result.hotels.first.hotelName, equals('Tokyo Business Stay'));
      expect(result.hotels.first.price, equals(18000));
      expect(result.hotels.first.tags, equals(<String>['station', 'business']));
    });

    test('fetchHotelDetail accepts code 0 and parses rooms/pictures', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.hotelDetail));
        expect(options.extra['auth_required'], isFalse);
        expect(
          options.data,
          equals(<String, dynamic>{
            'id': 'h1',
            'lang': 'JP',
            'startDate': '2026-06-01',
            'endDate': '2026-06-03',
            'occupancy': 2,
          }),
        );

        return _jsonOk(
          '{"code":0,"msg":"success","data":{"id":"h1","name":"Tokyo Business Stay","address":"Shinagawa","bookingType":0,"bookingStatus":true,"entirePrice":36000,"checkInMessage":"ok","hotelPictures":[{"relativeUrl":"https://cdn.example.com/h1-1.jpg","description":"front"}],"roomTypeDTO4APPs":[{"id":"r1","name":"Twin","price":18000,"occupancy":2,"roomIds":["101","102"],"roomPictures":[{"relativeUrl":"https://cdn.example.com/r1.jpg"}],"roomTypeBeds":[{"name":"Single","num":2}]}]}}',
        );
      });
      final api = HotelApiClient(client);

      final detail = await api.fetchHotelDetail(
        const HotelDetailRequestDto(
          id: 'h1',
          lang: 'JP',
          startDate: '2026-06-01',
          endDate: '2026-06-03',
          occupancy: 2,
        ),
      );

      expect(detail.id, equals('h1'));
      expect(detail.bookingType, equals(0));
      expect(detail.pictures.first.relativeUrl, contains('h1-1.jpg'));
      expect(detail.roomTypes, hasLength(1));
      expect(detail.roomTypes.first.id, equals('r1'));
      expect(detail.roomTypes.first.price, equals(18000));
      expect(detail.roomTypes.first.beds.first.num, equals(2));
    });

    test(
      'createBooking posts nested booking entity and returns order id',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(HotelApiPaths.bookingOrderSaveV2));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.data,
            equals(<String, dynamic>{
              'couponsCounts': <Map<String, dynamic>>[],
              'parent': <String, dynamic>{
                'bookingOrderEntity': <String, dynamic>{
                  'brandStr': 'glhotel_app',
                  'adultCount': '2',
                  'checkIn': '2026-06-01 00:00:00',
                  'checkOut': '2026-06-03 00:00:00',
                  'bookingDate': '2026-05-12 10:00:00',
                  'firstName': 'Taro',
                  'lastName': 'Yamada',
                  'nationality': 'JP',
                  'nationalityText': '日本',
                  'lang': 'JP',
                  'hotelInfoID': 'h1',
                  'roomCount': '1',
                  'totalCount': '2',
                  'kidsCount': '0',
                  'infantsCount': '0',
                  'contactIntlCode': '81',
                  'contactMobile': '09000000000',
                  'contactEmail': 'taro@example.com',
                  'siteID': '146671713176780822',
                  'orderRoomTypeData': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'roomTypeID': 'r1',
                      'roomCount': 1,
                      'roomIds': <String>['101'],
                      'roomCusts': <Map<String, dynamic>>[
                        <String, dynamic>{'firstName': 'Taro', 'count': 2},
                      ],
                    },
                  ],
                },
              },
              'site': '38',
            }),
          );
          return _jsonOk('{"code":200,"msg":"success","data":"order-1"}');
        });
        final api = HotelApiClient(client);

        final orderId = await api.createBooking(
          const HotelBookingCreateRequestDto(
            parent: HotelBookingCreateParentDto(
              bookingOrderEntity: HotelBookingOrderEntityDto(
                adultCount: '2',
                checkIn: '2026-06-01 00:00:00',
                checkOut: '2026-06-03 00:00:00',
                bookingDate: '2026-05-12 10:00:00',
                firstName: 'Taro',
                lastName: 'Yamada',
                nationality: 'JP',
                nationalityText: '日本',
                lang: 'JP',
                hotelInfoId: 'h1',
                totalCount: '2',
                contactIntlCode: '81',
                contactMobile: '09000000000',
                contactEmail: 'taro@example.com',
                orderRoomTypeData: <HotelOrderRoomTypeDataDto>[
                  HotelOrderRoomTypeDataDto(
                    roomTypeId: 'r1',
                    roomCount: 1,
                    roomIds: <String>['101'],
                    roomCusts: <HotelRoomCustomerDto>[
                      HotelRoomCustomerDto(firstName: 'Taro', count: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(orderId, equals('order-1'));
      },
    );

    test('fetchOrderList and cancelOrder use authenticated endpoints', () async {
      var call = 0;
      final client = _buildClient((options) async {
        call++;
        if (call == 1) {
          expect(options.method, equals('POST'));
          expect(options.path, equals(HotelApiPaths.orderList));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.data,
            equals(<String, dynamic>{
              'lang': 'JP',
              'startPage': 1,
              'limit': 20,
              'status': 'paid',
            }),
          );
          return _jsonOk(
            '{"code":200,"msg":"success","data":{"count":1,"bookingOrderList":[{"orderId":"order-1","hotelName":"Tokyo Business Stay","paidAmount":36000,"pay":false,"refund":true,"roomTypeCount":1}]}}',
          );
        }

        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.cancelOrder));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{'bookingOrderId': 'order-1', 'lang': 'JP'}),
        );
        return _jsonOk('{"code":200,"msg":"success","data":true}');
      });
      final api = HotelApiClient(client);

      final orders = await api.fetchOrderList(lang: 'JP', status: 'paid');
      await api.cancelOrder(bookingOrderId: 'order-1', lang: 'JP');

      expect(orders.count, equals(1));
      expect(orders.orders.first.orderId, equals('order-1'));
      expect(orders.orders.first.paidAmount, equals(36000));
      expect(call, equals(2));
    });
  });
}
