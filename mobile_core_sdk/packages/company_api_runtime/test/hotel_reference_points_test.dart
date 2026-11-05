import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:test/test.dart';

void main() {
  test(
    'assignment and confirmation decode new pointsRequired independently of old pointTotal',
    () {
      for (final value in ['12345', 12345, 0, null]) {
        final assigned = HotelAssignOccupancyResultDto.fromJson({
          'pointsRequired': value,
        });
        final quoted = HotelRoomExtraPersonResultDto.fromJson({
          'pointsRequired': value,
          'pointTotal': 999,
        });
        expect(assigned.pointsRequired, value is String ? 12345 : value);
        expect(quoted.pointsRequired, assigned.pointsRequired);
      }
      expect(
        HotelRoomExtraPersonResultDto.fromJson({
          'pointTotal': 999,
        }).pointsRequired,
        isNull,
      );
      const request = HotelRoomExtraPersonRequestDto(
        hotelId: '1',
        checkIn: '2026-11-10',
        checkOut: '2026-11-11',
        lang: 'JP',
      );
      expect(request.toJson().containsKey('stayBenefit'), false);
      expect(request.copyWith(stayBenefit: true).toJson()['stayBenefit'], true);
      const assign = HotelAssignOccupancyRequestDto(
        lang: 'JP',
        hotelId: '1',
        checkIn: '2026-11-10',
        checkOut: '2026-11-11',
        occupancy: 4,
      );
      expect(assign.toJson().containsKey('stayBenefit'), false);
      expect(assign.copyWith(stayBenefit: true).toJson()['stayBenefit'], true);
    },
  );

  test('reference points decode strings, numbers, zero and missing fields', () {
    for (final raw in ['12800', 12800, ' 12800 ']) {
      expect(
        HotelSummaryDto.fromJson({'startingPoints': raw}).startingPoints,
        12800,
      );
      expect(
        HotelRoomTypeDto.fromJson({'pointsRequired': raw}).pointsRequired,
        12800,
      );
    }
    expect(HotelSummaryDto.fromJson({}).startingPoints, isNull);
    expect(HotelRoomTypeDto.fromJson({}).pointsRequired, isNull);
    expect(
      HotelRoomTypeDto.fromJson({'pointsRequired': '0'}).pointsRequired,
      0,
    );
    for (final raw in ['', 'oops', '-1', 'NaN', 'Infinity']) {
      expect(
        () => HotelSummaryDto.fromJson({'startingPoints': raw}),
        throwsFormatException,
      );
      expect(
        () => HotelRoomTypeDto.fromJson({'pointsRequired': raw}),
        throwsFormatException,
      );
    }
  });
  test('detail request adds benefits only when supplied', () {
    const request = HotelDetailRequestDto(
      id: '1',
      lang: 'JP',
      startDate: '2026-11-10',
      endDate: '2026-11-13',
    );
    expect(request.toJson().containsKey('stayBenefit'), false);
    expect(request.copyWith(stayBenefit: true).toJson()['stayBenefit'], true);
  });
}
