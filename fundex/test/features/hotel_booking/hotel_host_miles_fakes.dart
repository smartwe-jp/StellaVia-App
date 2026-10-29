import 'dart:async';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import 'package:fundex/features/hotel_booking/domain/entities/hotel_models.dart';
import 'package:fundex/features/hotel_booking/domain/repositories/hotel_booking_repository.dart';
import 'package:fundex/features/hotel_booking/domain/usecases/search_hotels_usecase.dart';
import 'package:fundex/features/hotel_booking/presentation/controllers/hotel_host_miles_controller.dart';

const liveHotel = HotelSummary(
  id: 'live-42',
  name: 'API Hotel',
  address: 'Kyoto',
  area: 'kyoto',
  imageUrl: '',
  latitude: null,
  longitude: null,
  lowestPrice: 18000,
  beforeDiscountPrice: null,
  discount: null,
  discountName: '',
  bookingType: 0,
  buildingCode: '1',
  bookingTypeLabel: '',
  buildingType: '',
  isBookable: true,
  remainingRooms: 4,
  stayBenefitParticipate: false,
  tags: [],
);

class MilesFake extends HostMilesRepository {
  int calls = 0;
  bool fail = false;
  @override
  Future<HostMilesAccount> fetchAccount() async {
    calls++;
    if (fail) throw StateError('offline');
    return const HostMilesAccount(availablePoints: 23456);
  }

  @override
  Future<HostMilesTier> fetchTier() async {
    calls++;
    return const HostMilesTier(
      currentTier: 'GOLD',
      maxRooms: 5,
      currentBookingRooms: 2,
      leadTimeMonths: 5,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class HotelsFake extends HotelBookingRepository {
  final criteria = <HotelSearchCriteria>[];
  final pages = <int>[];
  final pending = <Completer<HotelSearchResult>>[];
  bool deferred = false, fail = false;
  @override
  Future<HotelSearchResult> searchHotels({
    required HotelSearchCriteria criteria,
    required String languageCode,
    int page = 1,
    int limit = 20,
  }) async {
    this.criteria.add(criteria);
    pages.add(page);
    if (fail) throw StateError('offline');
    if (deferred) {
      final c = Completer<HotelSearchResult>();
      pending.add(c);
      return c.future;
    }
    return HotelSearchResult(
      hotels: page == 1 ? [liveHotel] : [],
      totalCount: 2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

HotelHostMilesController milesController(
  HotelsFake hotels,
  MilesFake miles, {
  bool member = true,
}) => HotelHostMilesController(
  search: SearchHotelsUseCase(hotels),
  membership: LoadHostMilesHomeUseCase(miles),
  languageCode: 'JP',
  canLoadMembership: member,
  now: DateTime(2026, 11, 1),
);
