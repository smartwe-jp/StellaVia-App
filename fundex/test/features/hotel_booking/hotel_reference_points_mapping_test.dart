import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/data/datasources/hotel_booking_remote_data_source.dart';
import 'package:fundex/features/hotel_booking/data/repositories/hotel_booking_repository_impl.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';

class Remote extends Fake implements HotelBookingRemoteDataSource {
  HotelRoomExtraPersonRequestDto? quoteRequest;
  @override
  Future<HotelRoomExtraPersonResultDto> fetchRoomExtraPerson(
    HotelRoomExtraPersonRequestDto request,
  ) async {
    quoteRequest = request;
    return const HotelRoomExtraPersonResultDto(
      pointsRequired: 45678,
      pointTotal: 999,
    );
  }

  HotelAssignOccupancyRequestDto? assignmentRequest;
  @override
  Future<HotelAssignOccupancyResultDto> assignOccupancy(
    HotelAssignOccupancyRequestDto request,
  ) async {
    assignmentRequest = request;
    return HotelAssignOccupancyResultDto.fromJson({
      'pointsRequired': '32100',
      'price': 123,
    });
  }

  HotelDetailRequestDto? detailRequest;
  HotelSearchRequestDto? searchRequest;
  @override
  Future<HotelDetailDto> fetchHotelDetail(HotelDetailRequestDto request) async {
    detailRequest = request;
    return HotelDetailDto.fromJson({
      'id': '1',
      'roomTypeDTO4APPs': [
        {'id': 'room', 'pointsRequired': '34567'},
      ],
    });
  }

  @override
  Future<HotelSearchResultDto> searchHotels(
    HotelSearchRequestDto request,
  ) async {
    searchRequest = request;
    return HotelSearchResultDto.fromJson({
      'hotels': [
        {'hotelId': '1', 'startingPoints': '12800'},
      ],
    });
  }

  @override
  Future<String> fetchRefundStrategyText({
    required String languageCode,
    required String siteCode,
    required String checkIn,
    required String hotelId,
  }) async => '';
  @override
  Future<HotelPriceCalendarDto> fetchPriceByDate({
    required String hotelInfoId,
  }) async => const HotelPriceCalendarDto();
}

void main() {
  test(
    'benefit assignment forwards flag and quote strips ordinary coupons',
    () async {
      final remote = Remote();
      final repo = HotelBookingRepositoryImpl(remote: remote);
      final criteria = HotelSearchCriteria.initial(
        DateTime(2026, 11, 10),
      ).copyWith(stayBenefit: true, occupancy: 4);
      final assigned = await repo.assignOccupancy(
        hotelId: '1',
        criteria: criteria,
        selectedRooms: [],
        languageCode: 'JP',
      );
      expect(remote.assignmentRequest!.stayBenefit, true);
      expect(remote.assignmentRequest!.occupancy, 4);
      expect(assigned.pointsRequired, 32100);
      for (final benefit in [true, false]) {
        await repo.quoteBookingPrice(
          HotelBookingQuoteRequest(
            stayBenefit: benefit,
            hotelId: '1',
            checkIn: criteria.checkInDate,
            checkOut: criteria.checkOutDate,
            languageCode: 'JP',
            rooms: const [HotelBookingQuoteRoom(roomTypeId: '1', occupancy: 4)],
            coupons: const [HotelBookingSelectedCoupon(couponId: 99)],
            usesRoomPlanSelection: true,
            selectedRooms: [],
          ),
        );
        expect(remote.quoteRequest!.stayBenefit, benefit ? true : null);
        expect(remote.quoteRequest!.couponsCounts.isEmpty, benefit);
      }
      await repo.assignOccupancy(
        hotelId: '1',
        criteria: criteria.copyWith(stayBenefit: false),
        selectedRooms: [],
        languageCode: 'JP',
      );
      expect(
        remote.assignmentRequest!.toJson().containsKey('stayBenefit'),
        false,
      );
    },
  );
  test(
    'room quote sends allocated guests and date-only stay to backend',
    () async {
      final remote = Remote();
      final repository = HotelBookingRepositoryImpl(remote: remote);
      final quote = await repository.quoteBookingPrice(
        HotelBookingQuoteRequest(
          hotelId: '1',
          checkIn: DateTime(2026, 11, 10),
          checkOut: DateTime(2026, 11, 13),
          languageCode: 'JP',
          rooms: const [
            HotelBookingQuoteRoom(roomTypeId: 'room', occupancy: 3),
          ],
          coupons: const [],
          usesRoomPlanSelection: true,
          selectedRooms: const [],
        ),
      );
      expect(remote.quoteRequest!.checkIn, '2026-11-10');
      expect(remote.quoteRequest!.checkOut, '2026-11-13');
      expect(remote.quoteRequest!.roomTypeCustNums.single.occupancy, '3');
      expect(
        remote.quoteRequest!.roomTypeCustNums.single.toJson()['roomTypeID'],
        'room',
      );
      expect(quote.pointsRequired, 45678);
      expect(remote.quoteRequest!.toJson().containsKey('stayBenefit'), false);
    },
  );

  test(
    'repository forwards mode and maps full-stay points without night multiplication',
    () async {
      final remote = Remote();
      final repository = HotelBookingRepositoryImpl(remote: remote);
      final criteria = HotelSearchCriteria.initial(
        DateTime(2026, 11, 10),
      ).copyWith(checkOutDate: DateTime(2026, 11, 13), stayBenefit: true);
      final hotels = await repository.searchHotels(
        criteria: criteria,
        languageCode: 'JP',
      );
      expect(remote.searchRequest!.stayBenefit, true);
      expect(hotels.hotels.single.startingPoints, 12800);
      final detail = await repository.fetchHotelDetail(
        hotelId: '1',
        criteria: criteria,
        languageCode: 'JP',
      );
      expect(remote.detailRequest!.stayBenefit, true);
      expect(remote.detailRequest!.endDate, '2026-11-13');
      expect(detail.roomPlans.single.pointsRequired, 34567);
      await repository.fetchHotelDetail(
        hotelId: '1',
        criteria: criteria.copyWith(stayBenefit: false),
        languageCode: 'JP',
      );
      expect(remote.detailRequest!.toJson().containsKey('stayBenefit'), false);
    },
  );
}
