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
    test('searchHotels follows Swagger path and parses hotel list', () async {
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
            'price': <String, dynamic>{'minPrice': 10000, 'maxPrice': 30000},
            'filterVal': <Object?>['wifi'],
            'area': 'tokyo',
            'bookingType': 2,
            'buildingCode': 'hotel',
            'priceSort': 'asc',
            'occupancy': 2,
            'kids': 1,
            'roomNum': 1,
          }),
        );

        return _jsonOk(
          '{"code":200,"msg":"success","data":{"count":1,"showStatus":"2","showStatusStr":"limited","hotels":[{"hotelId":"h1","hotelName":"Tokyo Business Stay","address":"Shinagawa","image":"https://cdn.example.com/h1.jpg","basePrice":18000,"basePrice2":12000,"discountName2":"T1会員割引","discount2":59,"bookingType":"2","bookingStatus":true,"remainRoomNum":"残り4部屋以上","lat":35.628,"lng":139.738,"tags":["station","business"]}]}}',
        );
      });
      final api = HotelApiClient(client);

      final result = await api.searchHotels(
        const HotelSearchRequestDto(
          startDate: '2026-06-01',
          endDate: '2026-06-03',
          keyWord: 'Tokyo',
          lang: 'JP',
          price: <String, Object?>{'minPrice': 10000, 'maxPrice': 30000},
          filterVal: <Object?>['wifi'],
          area: 'tokyo',
          bookingType: 2,
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
      expect(result.hotels.first.basePrice, equals(18000));
      expect(result.hotels.first.basePrice2, equals(12000));
      expect(result.hotels.first.discountName2, equals('T1会員割引'));
      expect(result.hotels.first.discount2, equals(59));
      expect(result.hotels.first.bookingType, equals('2'));
      expect(result.hotels.first.remainRoomNum, equals('残り4部屋以上'));
      expect(result.hotels.first.tags, equals(<String>['station', 'business']));
    });

    test('fetchBuildingCodes preserves all option and localized names', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.buildingCode));
        expect(options.extra['auth_required'], isFalse);
        expect(options.data, equals(<String, dynamic>{'lang': 'CH'}));

        return _jsonOk(
          '{"code":200,"msg":"success","data":[{"buildingCode":"","buildingName":"すべて","localizedNames":{"EN":"All","CH":"全部","JP":"すべて"}},{"buildingCode":"01","buildingName":"アパートメントホテル","localizedNames":{"EN":"Aparthotel","CH":"公寓式酒店","JP":"アパートメントホテル"}}]}',
        );
      });
      final api = HotelApiClient(client);

      final result = await api.fetchBuildingCodes(lang: 'CH');

      expect(result, hasLength(2));
      expect(result.first.buildingCode, isEmpty);
      expect(result.first.localizedNames['CH'], equals('全部'));
      expect(result.last.buildingCode, equals('01'));
      expect(result.last.localizedNames['EN'], equals('Aparthotel'));
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
          '{"code":0,"msg":"success","data":{"id":"h1","name":"Tokyo Business Stay","address":"Shinagawa","tags":"{\\"tags\\":[]}","bookingType":0,"bookingStatus":true,"entirePrice":36000,"checkInMessage":"ok","hotelPictures":[{"relativeUrl":"https://cdn.example.com/h1-1.jpg","description":"front"}],"roomTypeDTO4APPs":[{"id":"r1","name":"Twin","price":18000,"occupancy":2,"roomIds":[101,"102"],"roomPictures":[{"relativeUrl":"https://cdn.example.com/r1.jpg"}],"roomTypeBeds":[{"name":"Single","num":2}]}]}}',
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
      expect(detail.tags, isEmpty);
      expect(detail.roomTypes.first.roomIds, equals(<String>['101', '102']));
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
              'parent': <String, dynamic>{
                'bookingOrderEntity': <String, dynamic>{
                  'brandStr': 'gl_web',
                  'checkIn': '2026-06-01 00:00:00',
                  'checkOut': '2026-06-03 00:00:00',
                  'bookingDate': '',
                  'firstName': 'Taro',
                  'lastName': 'Yamada',
                  'name': 'Yamada Taro',
                  'nationality': 'JP',
                  'lang': 'JP',
                  'hotelInfoID': 'h1',
                  'roomCount': 1,
                  'totalCount': 2,
                  'totalRoomCount': 1,
                  'contactIntlCode': '81',
                  'contactMobile': '09000000000',
                  'contactEmail': 'taro@example.com',
                  'comment': '',
                  'receiptTitle': '',
                  'siteID': '146671713176780822',
                  'orderRoomTypeData': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'roomTypeID': 'r1',
                      'roomCount': 1,
                      'roomTypename': 'Twin',
                      'roomPrice': 5740,
                      'occupancy': 2,
                      'roomTypeExtraGuestPrices': <String, dynamic>{
                        'roomTypeId': 1,
                        'roomTypeName': 'Twin',
                        'roomCount': 1,
                        'totalGuestCount': 2,
                        'extraGuestCount': 0,
                        'extraGuestPrice': 0,
                      },
                      'roomCusts': <Map<String, dynamic>>[
                        <String, dynamic>{
                          'roomTypeID': 1,
                          'name': 'Yamada Taro',
                          'firstName': 'Taro',
                          'lastName': 'Yamada',
                          'nationality': 'JP',
                          'email': 'taro@example.com',
                          'count': 2,
                          'childCount': 0,
                          'maxcount': 2,
                        },
                      ],
                    },
                  ],
                  'totalAmount': 5740,
                },
              },
              'site': '38',
            }),
          );
          return _jsonOk('{"code":200,"msg":"success","data":1290827}');
        });
        final api = HotelApiClient(client);

        final orderId = await api.createBooking(
          const HotelBookingCreateRequestDto(
            parent: HotelBookingCreateParentDto(
              bookingOrderEntity: HotelBookingOrderEntityDto(
                checkIn: '2026-06-01 00:00:00',
                checkOut: '2026-06-03 00:00:00',
                firstName: 'Taro',
                lastName: 'Yamada',
                name: 'Yamada Taro',
                nationality: 'JP',
                lang: 'JP',
                hotelInfoId: 'h1',
                roomCount: 1,
                totalCount: 2,
                totalRoomCount: 1,
                contactIntlCode: '81',
                contactMobile: '09000000000',
                contactEmail: 'taro@example.com',
                orderRoomTypeData: <HotelOrderRoomTypeDataDto>[
                  HotelOrderRoomTypeDataDto(
                    roomTypeId: 'r1',
                    roomCount: 1,
                    roomTypename: 'Twin',
                    roomPrice: 5740,
                    occupancy: 2,
                    roomTypeExtraGuestPrices: HotelRoomTypeExtraGuestPriceDto(
                      roomTypeId: 1,
                      roomTypeName: 'Twin',
                      roomCount: 1,
                      totalGuestCount: 2,
                      extraGuestCount: 0,
                      extraGuestPrice: 0,
                    ),
                    roomCusts: <HotelRoomCustomerDto>[
                      HotelRoomCustomerDto(
                        roomTypeId: 1,
                        name: 'Yamada Taro',
                        firstName: 'Taro',
                        lastName: 'Yamada',
                        nationality: 'JP',
                        email: 'taro@example.com',
                        count: 2,
                        childCount: 0,
                        maxcount: 2,
                      ),
                    ],
                  ),
                ],
                totalAmount: 5740,
              ),
            ),
          ),
        );

        expect(orderId, equals('1290827'));
      },
    );

    test(
      'fetchRefundStrategyText and fetchPriceByDate use PMS endpoints',
      () async {
        var call = 0;
        final client = _buildClient((options) async {
          call++;
          if (call == 1) {
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.refundStrategyText));
            expect(options.extra['auth_required'], isFalse);
            expect(
              options.data,
              equals(<String, dynamic>{
                'lang': 'CH',
                'siteCode': 'gl',
                'checkIn': '2026-05-13',
                'hotelId': '1',
              }),
            );
            return _jsonOk(
              '{"code":200,"msg":"success","data":"Free cancellation before check-in."}',
            );
          }

          expect(options.method, equals('POST'));
          expect(options.path, equals(HotelApiPaths.priceByDate));
          expect(options.extra['auth_required'], isFalse);
          expect(options.data, equals(<String, dynamic>{'hotelInfoID': '1'}));
          return _jsonOk(
            '{"code":200,"msg":"success","data":{"2026-05-13":"20100","2026-05-14":"21900"}}',
          );
        });
        final api = HotelApiClient(client);

        final refundText = await api.fetchRefundStrategyText(
          lang: 'CH',
          siteCode: 'gl',
          checkIn: '2026-05-13',
          hotelId: '1',
        );
        final priceCalendar = await api.fetchPriceByDate(hotelInfoId: '1');

        expect(refundText, equals('Free cancellation before check-in.'));
        expect(priceCalendar.pricesByDate['2026-05-13'], equals('20100'));
        expect(call, equals(2));
      },
    );

    test('booking confirmation helpers use PMS endpoints', () async {
      var call = 0;
      final client = _buildClient((options) async {
        call++;
        switch (call) {
          case 1:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.assignOccupancy));
            expect(options.extra['auth_required'], isFalse);
            expect(
              options.data,
              equals(<String, dynamic>{
                'lang': 'CH',
                'hotelId': '1',
                'checkIn': '2026-05-13',
                'checkOut': '2026-05-14',
                'occupancy': 1,
                'roomTypeRoomNums': <Map<String, dynamic>>[
                  <String, dynamic>{'roomTypeID': '10', 'roomNumber': 1},
                ],
              }),
            );
            return _jsonOk(
              '{"code":200,"msg":"success","data":{"roomTypeCustNums":[{"roomTypeID":10,"occupancy":1}],"roomTypeExtraGuestPrices":[{"roomTypeID":10,"custNumber":2,"price":3000}],"message":null,"price":30586}}',
            );
          case 2:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.page));
            expect(options.extra['auth_required'], isFalse);
            expect(
              options.data,
              equals(<String, dynamic>{'lang': 'CH', 'pageCode': 'APP011'}),
            );
            return _jsonOk(
              '{"code":200,"msg":"success","data":{"pageTemplateDetailDTO":[{"pageTemplateDetailEntity":{"resCatalog":"TITLE","resID":"001","showName":"入住说明"}}]}}',
            );
          case 3:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.countryCodeList));
            expect(options.extra['auth_required'], isFalse);
            expect(options.data, equals(<String, dynamic>{'lang': 'CH'}));
            return _jsonOk(
              '{"code":200,"msg":"success","data":{"JP-日本":"JP","CN-中国":"CN"}}',
            );
          case 4:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.roomExtraPerson));
            expect(options.extra['auth_required'], isTrue);
            expect(
              options.data,
              equals(<String, dynamic>{
                'checkIn': '2026-05-13',
                'checkOut': '2026-05-14',
                'hotelId': '1',
                'lang': 'CH',
                'roomTypeCustNums': <Map<String, dynamic>>[
                  <String, dynamic>{'roomTypeID': '10', 'occupancy': '1'},
                ],
                'couponsCounts': <Object?>[],
              }),
            );
            return _jsonOk(
              '{"code":200,"msg":"success","data":{"priceElement":{"price":30586,"originalPrice":33000,"roomPriceElements":[{"roomTypeId":10,"freeUserPrice":0,"priceTip":"base"}]}}}',
            );
          case 5:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.couponsOrderCustList));
            expect(options.extra['auth_required'], isTrue);
            expect(
              options.data,
              equals(<String, dynamic>{'lang': 'CH', 'hotelId': '1'}),
            );
            return _jsonOk(
              '{"code":200,"msg":"success","data":{"list":[{"id":"c1"}]}}',
            );
          case 6:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.memberContactsList));
            expect(options.extra['auth_required'], isTrue);
            expect(options.data, equals(<String, dynamic>{'lang': 'CH'}));
            return _jsonOk('{"code":200,"msg":"success","data":[{"id":"m1"}]}');
          case 7:
            expect(options.method, equals('POST'));
            expect(options.path, equals(HotelApiPaths.cardRegisterList));
            expect(options.extra['auth_required'], isTrue);
            expect(options.data, equals(<String, dynamic>{}));
            return _jsonOk(
              '{"code":200,"msg":"success","data":[{"cardId":"card1"}]}',
            );
        }
        fail('Unexpected call $call to ${options.path}');
      });
      final api = HotelApiClient(client);

      final assigned = await api.assignOccupancy(
        const HotelAssignOccupancyRequestDto(
          lang: 'CH',
          hotelId: '1',
          checkIn: '2026-05-13',
          checkOut: '2026-05-14',
          occupancy: 1,
          roomTypeRoomNums: <HotelRoomTypeRoomNumDto>[
            HotelRoomTypeRoomNumDto(roomTypeId: '10', roomNumber: 1),
          ],
        ),
      );
      final pageText = await api.fetchPageText(lang: 'CH', pageCode: 'APP011');
      final countries = await api.fetchCountryCodeList(lang: 'CH');
      final extra = await api.fetchRoomExtraPerson(
        const HotelRoomExtraPersonRequestDto(
          checkIn: '2026-05-13',
          checkOut: '2026-05-14',
          hotelId: '1',
          lang: 'CH',
          roomTypeCustNums: <HotelRoomTypeCustNumRequestDto>[
            HotelRoomTypeCustNumRequestDto(roomTypeId: '10', occupancy: '1'),
          ],
        ),
      );
      final coupons = await api.fetchOrderCoupons(lang: 'CH', hotelId: '1');
      final contacts = await api.fetchMemberContacts(lang: 'CH');
      final cards = await api.fetchRegisteredCards();

      expect(assigned.price, equals(30586));
      expect(assigned.roomTypeCustNums.first.roomTypeId, equals(10));
      expect(pageText['TITLE001'], equals('入住说明'));
      expect(countries['JP-日本'], equals('JP'));
      expect(extra.priceElement?.price, equals(30586));
      expect(coupons['list'], isA<List<Object?>>());
      expect(contacts, hasLength(1));
      expect(cards, hasLength(1));
      expect(cards.first.cardId, equals('card1'));
      expect(call, equals(7));
    });

    test('registerCreditCard posts token payload to hotel API', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.cardRegister));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'cardToken': <String, dynamic>{
              'token': 'token-1',
              'token_expire_date': '20260527135802',
              'req_card_number': '537772********09',
              'status': 'success',
              'code': 'success',
              'message': 'created',
            },
            'bookingOrderId': '',
            'defaultFlag': 1,
            'cardholderMobilePhoneCountry': '81',
            'cardholderMobilePhoneNumber': '111111',
            'cardholderEmail': 'card@example.com',
          }),
        );
        return _jsonOk('{"code":200,"msg":"success","data":"card-id"}');
      });
      final api = HotelApiClient(client);

      final result = await api.registerCreditCard(
        const HotelCreditCardRegisterRequestDto(
          cardToken: HotelCreditCardTokenDto(
            token: 'token-1',
            tokenExpireDate: '20260527135802',
            reqCardNumber: '537772********09',
            status: 'success',
            code: 'success',
            message: 'created',
          ),
          defaultFlag: 1,
          cardholderMobilePhoneCountry: '81',
          cardholderMobilePhoneNumber: '111111',
          cardholderEmail: 'card@example.com',
        ),
      );

      expect(result, equals('card-id'));
    });

    test('payWithRegisteredCard posts card id and parses secure url', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.cardPayById));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'cardId': 'card-id',
            'bookingOrderId': '1290827',
          }),
        );
        return _jsonOk(
          '{"code":200,"msg":"success","data":{"pay":true,"url":"https://secure.example.com/verify"}}',
        );
      });
      final api = HotelApiClient(client);

      final result = await api.payWithRegisteredCard(
        const HotelRegisteredCardPaymentRequestDto(
          cardId: 'card-id',
          bookingOrderId: '1290827',
        ),
      );

      expect(result.pay, isTrue);
      expect(result.url, equals('https://secure.example.com/verify'));
    });

    test(
      'createAirhostBooking follows Swagger /booking/order contract',
      () async {
        final client = _buildClient((options) async {
          expect(options.method, equals('POST'));
          expect(options.path, equals(HotelApiPaths.bookingOrder));
          expect(options.extra['auth_required'], isTrue);
          expect(
            options.data,
            equals(<String, dynamic>{
              'checkIn': '2026-06-01',
              'checkOut': '2026-06-03',
              'firstName': 'Taro',
              'lastName': 'Yamada',
              'lang': 'JP',
              'hotelInfoID': 1001,
              'roomCount': 1,
              'totalCount': 2,
              'receiptTitle': 'Yamada Taro',
              'contactIntlCode': '81',
              'contactMobile': '09000000000',
              'contactEmail': 'taro@example.com',
              'siteID': 146671713176780822,
              'totalAmount': 36000,
              'brandStr': 'glhotel_app',
              'nationality': 'JP',
              'orderRoomTypeData': <Map<String, dynamic>>[
                <String, dynamic>{
                  'roomTypeID': 2001,
                  'roomCount': 1,
                  'roomCusts': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'firstName': 'Taro',
                      'lastName': 'Yamada',
                      'contactEmail': 'taro@example.com',
                      'adultCount': 2,
                      'nationality': 'JP',
                    },
                  ],
                },
              ],
              'couponsCounts': <int>[],
            }),
          );
          return _jsonOk('{"code":200,"msg":"success","data":12345}');
        });
        final api = HotelApiClient(client);

        final orderId = await api.createAirhostBooking(
          const AirhostBookingOrderRequestDto(
            checkIn: '2026-06-01',
            checkOut: '2026-06-03',
            firstName: 'Taro',
            lastName: 'Yamada',
            lang: 'JP',
            hotelInfoId: 1001,
            roomCount: 1,
            totalCount: 2,
            receiptTitle: 'Yamada Taro',
            contactIntlCode: '81',
            contactMobile: '09000000000',
            contactEmail: 'taro@example.com',
            siteId: 146671713176780822,
            totalAmount: 36000,
            brandStr: 'glhotel_app',
            nationality: 'JP',
            orderRoomTypeData: <AirhostOrderRoomTypeDataDto>[
              AirhostOrderRoomTypeDataDto(
                roomTypeId: 2001,
                roomCount: 1,
                roomCusts: <AirhostOrderRoomCustDto>[
                  AirhostOrderRoomCustDto(
                    firstName: 'Taro',
                    lastName: 'Yamada',
                    contactEmail: 'taro@example.com',
                    adultCount: 2,
                    nationality: 'JP',
                  ),
                ],
              ),
            ],
          ),
        );

        expect(orderId, equals(12345));
      },
    );

    test('sendAirhostPaymentLink follows Swagger contract', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.bookingOrderSendPaymentLink));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'id': 12345,
            'lang': 'JP',
            'email': 'taro@example.com',
          }),
        );
        return _jsonOk(
          '{"code":200,"msg":"success","data":"https://pay.example.com/order/12345"}',
        );
      });
      final api = HotelApiClient(client);

      final link = await api.sendAirhostPaymentLink(
        const OrderSendPaymentLinkRequestDto(
          id: 12345,
          lang: 'JP',
          email: 'taro@example.com',
        ),
      );

      expect(link, equals('https://pay.example.com/order/12345'));
    });

    test('fetchMemberInfo uses authenticated profile endpoint', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.memberInfo));
        expect(options.extra['auth_required'], isTrue);
        expect(options.data, equals(<String, dynamic>{}));

        return _jsonOk(
          '{"code":200,"msg":"success","data":{"id":7,"memberName":"侯景雁","email":"aaron@example.com","phoneCountryCode":"+81","phoneNumber":"08042039590","生日":"1990-01-02","gender":1,"joinDate":"2026-05-01","membersLevel":"T1","membersLevelCode":1,"discount":7,"expireDate":"2027-05-01","sourceUserId":10,"membersStatus":"ACTIVE"}}',
        );
      });
      final api = HotelApiClient(client);

      final profile = await api.fetchMemberInfo();

      expect(profile.id, equals(7));
      expect(profile.memberName, equals('侯景雁'));
      expect(profile.email, equals('aaron@example.com'));
      expect(profile.phoneCountryCode, equals('+81'));
      expect(profile.phoneNumber, equals('08042039590'));
      expect(profile.birthday, equals('1990-01-02'));
      expect(profile.gender, equals(1));
      expect(profile.membersLevel, equals('T1'));
      expect(profile.membersLevelCode, equals(1));
      expect(profile.discount, equals(7));
      expect(profile.sourceUserId, equals(10));
      expect(profile.membersStatus, equals('ACTIVE'));
    });

    test('updateMemberInfo posts authenticated customer payload', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.memberInfoUpdate));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'id': 7,
            'memberName': '侯景雁',
            'email': 'aaron@example.com',
            'phoneCountryCode': '+81',
            'phoneNumber': '08042039590',
            'birthday': '1990-01-02',
            'gender': 1,
            'sourceUserId': 10,
          }),
        );

        return _jsonOk('{"code":200,"msg":"success","data":true}');
      });
      final api = HotelApiClient(client);

      await api.updateMemberInfo(
        const HotelMemberInfoUpdateRequestDto(
          id: 7,
          memberName: '侯景雁',
          email: 'aaron@example.com',
          phoneCountryCode: '+81',
          phoneNumber: '08042039590',
          birthday: '1990-01-02',
          gender: 1,
          sourceUserId: 10,
        ),
      );
    });

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
              'status': 0,
            }),
          );
          return _jsonOk(
            '{"code":200,"msg":"success","data":{"startPage":1,"limit":20,"count":1,"bookingOrderList":[{"id":"order-1","hotelName":"Tokyo Business Stay","buildingName":"Tokyo Stay","hotelImage":"https://cdn.example.com/hotel.jpg","hotelAddress":"Shinagawa","paymentStatus":"支払い待ち","paymentStatusCode":40,"orderStatusStr":"キャンセル済み","orderStatusCode":5,"totalAmount":36000,"checkIn":"2026-06-01 15:00:00","checkOut":"2026-06-03 10:00:00","pay":false,"refund":true,"roomTypeCount":1}]}}',
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

      final orders = await api.fetchOrderList(lang: 'JP', status: 0);
      await api.cancelOrder(bookingOrderId: 'order-1', lang: 'JP');

      expect(orders.startPage, equals(1));
      expect(orders.limit, equals(20));
      expect(orders.count, equals(1));
      expect(orders.orders.first.orderId, equals('order-1'));
      expect(orders.orders.first.totalAmount, equals(36000));
      expect(orders.orders.first.hotelImage, contains('hotel.jpg'));
      expect(orders.orders.first.paymentStatusCode, equals(40));
      expect(orders.orders.first.orderStatusCode, equals(5));
      expect(call, equals(2));
    });

    test('fetchOrderDetail parses authenticated detail payload', () async {
      final client = _buildClient((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(HotelApiPaths.orderDetail));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{'orderId': '1290689', 'lang': 'JP'}),
        );
        return _jsonOk(
          '{"code":200,"msg":"success","data":{"orderId":1290689,"hotelId":7,"hotelName":"谷町君・ホテル・恵美須町72","buildingName":"谷町君･ホテル･恵美須72","hotelHomeImage":"https://img.example.com/hotel.jpg","address":"大阪府大阪市浪速区日本橋東3丁目8-5","lng":135.5,"lat":34.6,"checkIn":"2026-05-25 15:00:00","checkOut":"2026-05-26 10:00:00","contactIntlCode":"81","contactMobile":"08042039590","nationalityText":"日本","checkInGuide":"guide","cancelRule":"policy","priceElement":{"price":8528,"originalPrice":10000},"roomTypeCount":[{"name":"スーペリアツイン","roomCount":1,"roomPictures":[{"relativeUrl":"https://img.example.com/room.jpg"}],"roomIdCustNums":[{"roomTypeName":"スーペリアツイン","custName":"侯 景雁","custNum":1,"password":"1234"}]}]}}',
        );
      });
      final api = HotelApiClient(client);

      final detail = await api.fetchOrderDetail(orderId: '1290689', lang: 'JP');

      expect(detail.orderId, equals('1290689'));
      expect(detail.hotelId, equals('7'));
      expect(detail.hotelHomeImage, contains('hotel.jpg'));
      expect(detail.address, contains('大阪府'));
      expect(detail.priceElement['price'], equals(8528));
      expect(detail.roomTypeCount, hasLength(1));
      expect(detail.roomTypeCount.first['name'], equals('スーペリアツイン'));
    });
  });
}
