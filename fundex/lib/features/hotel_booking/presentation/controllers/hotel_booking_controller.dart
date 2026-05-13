import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/hotel_models.dart';
import '../../domain/usecases/search_hotels_usecase.dart';

class HotelBookingState {
  const HotelBookingState({
    required this.criteria,
    this.hotels = const <HotelSummary>[],
    this.totalCount = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  final HotelSearchCriteria criteria;
  final List<HotelSummary> hotels;
  final int totalCount;
  final bool isLoading;
  final bool isRefreshing;
  final Object? error;

  bool get hasContent => hotels.isNotEmpty;

  HotelBookingState copyWith({
    HotelSearchCriteria? criteria,
    List<HotelSummary>? hotels,
    int? totalCount,
    bool? isLoading,
    bool? isRefreshing,
    Object? error = _unchanged,
  }) {
    return HotelBookingState(
      criteria: criteria ?? this.criteria,
      hotels: hotels ?? this.hotels,
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: identical(error, _unchanged) ? this.error : error,
    );
  }
}

class HotelBookingController extends StateNotifier<HotelBookingState> {
  HotelBookingController({
    required SearchHotelsUseCase searchHotels,
    required String languageCode,
    DateTime? now,
  }) : _searchHotels = searchHotels,
       _languageCode = languageCode,
       super(
         HotelBookingState(
           criteria: HotelSearchCriteria.initial(now ?? DateTime.now()),
           isLoading: true,
         ),
       ) {
    refresh();
  }

  final SearchHotelsUseCase _searchHotels;
  final String _languageCode;

  Future<void> refresh() async {
    final keepContent = state.hotels.isNotEmpty;
    state = state.copyWith(
      isLoading: !keepContent,
      isRefreshing: keepContent,
      error: null,
    );
    try {
      final result = await _searchHotels(
        criteria: state.criteria,
        languageCode: _languageCode,
        limit: 9,
      );
      state = state.copyWith(
        hotels: result.hotels,
        totalCount: result.totalCount,
        isLoading: false,
        isRefreshing: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    }
  }

  Future<void> submitSearch({
    String? keyword,
    String? area,
    DateTime? checkInDate,
    DateTime? checkOutDate,
  }) {
    final nextCheckIn = checkInDate ?? state.criteria.checkInDate;
    var nextCheckOut = checkOutDate ?? state.criteria.checkOutDate;
    if (!nextCheckOut.isAfter(nextCheckIn)) {
      nextCheckOut = nextCheckIn.add(const Duration(days: 1));
    }
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        keyword: keyword,
        area: area,
        checkInDate: nextCheckIn,
        checkOutDate: nextCheckOut,
      ),
    );
    return refresh();
  }

  Future<void> selectBuildingCode(String? buildingCode) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(buildingCode: buildingCode),
    );
    return refresh();
  }

  Future<void> setPriceSort(HotelPriceSort priceSort) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(priceSort: priceSort),
    );
    return refresh();
  }

  Future<void> setGuestCounts({
    required int adults,
    required int children,
    required int rooms,
  }) {
    state = state.copyWith(
      criteria: state.criteria.copyWith(
        occupancy: adults.clamp(1, 20),
        kids: children.clamp(0, 20),
        roomCount: rooms.clamp(1, 10),
      ),
    );
    return refresh();
  }
}

const Object _unchanged = Object();
