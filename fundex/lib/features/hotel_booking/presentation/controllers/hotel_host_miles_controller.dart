import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../domain/entities/hotel_models.dart';
import '../../domain/usecases/search_hotels_usecase.dart';
import 'hotel_booking_controller.dart';

class HotelHostMilesState {
  const HotelHostMilesState({
    required this.hotels,
    this.account = const AsyncData(null),
    this.tier = const AsyncData(null),
  });
  final HotelBookingState hotels;
  final AsyncValue<HostMilesAccount?> account;
  final AsyncValue<HostMilesTier?> tier;
  HotelHostMilesState copyWith({
    HotelBookingState? hotels,
    AsyncValue<HostMilesAccount?>? account,
    AsyncValue<HostMilesTier?>? tier,
  }) => HotelHostMilesState(
    hotels: hotels ?? this.hotels,
    account: account ?? this.account,
    tier: tier ?? this.tier,
  );
}

/// Read-only host-mile home. Isolated from the legacy coupon booking flow.
class HotelHostMilesController extends StateNotifier<HotelHostMilesState> {
  HotelHostMilesController({
    required this.search,
    required this.membership,
    required this.languageCode,
    required this.canLoadMembership,
    DateTime? now,
  }) : super(
         HotelHostMilesState(
           hotels: HotelBookingState(
             criteria: HotelSearchCriteria.initial(
               now ?? DateTime.now(),
             ).copyWith(stayBenefit: true),
             isLoading: true,
           ),
         ),
       );
  final SearchHotelsUseCase search;
  final LoadHostMilesHomeUseCase membership;
  final String languageCode;
  final bool canLoadMembership;
  int _generation = 0;
  Future<void>? _summaryPending;
  Future<void> refresh() async {
    await Future.wait([refreshMembership(), refreshHotels()]);
  }

  Future<void> refreshMembership() => _summaryPending ??= _loadMembership()
      .whenComplete(() => _summaryPending = null);
  Future<void> _loadMembership() async {
    if (!mounted || !canLoadMembership) return;
    state = state.copyWith(
      account: const AsyncLoading<HostMilesAccount?>().copyWithPrevious(
        state.account,
      ),
      tier: const AsyncLoading<HostMilesTier?>().copyWithPrevious(state.tier),
    );
    await Future.wait([_loadAccount(), _loadTier()]);
  }

  Future<void> _loadAccount() async {
    try {
      final value = await membership.loadAccount();
      if (mounted) state = state.copyWith(account: AsyncData(value));
    } catch (e, st) {
      if (mounted) {
        state = state.copyWith(
          account: AsyncError<HostMilesAccount?>(
            e,
            st,
          ).copyWithPrevious(state.account),
        );
      }
    }
  }

  Future<void> _loadTier() async {
    try {
      final value = await membership.loadTier();
      if (mounted) state = state.copyWith(tier: AsyncData(value));
    } catch (e, st) {
      if (mounted) {
        state = state.copyWith(
          tier: AsyncError<HostMilesTier?>(e, st).copyWithPrevious(state.tier),
        );
      }
    }
  }

  Future<void> applyCriteria(HotelSearchCriteria criteria) {
    final start = criteria.checkInDate;
    final end = criteria.checkOutDate.isAfter(start)
        ? criteria.checkOutDate
        : start.add(const Duration(days: 1));
    state = state.copyWith(
      hotels: HotelBookingState(
        criteria: criteria.copyWith(
          checkOutDate: end,
          occupancy: criteria.occupancy.clamp(1, 20),
          kids: criteria.kids.clamp(0, 20),
          roomCount: criteria.roomCount.clamp(1, 10),
          stayBenefit: true,
        ),
      ),
    );
    return refreshHotels();
  }

  Future<void> refreshHotels() async {
    if (!mounted) return;
    final generation = ++_generation;
    final current = state.hotels;
    final criteria = current.criteria;
    state = state.copyWith(
      hotels: current.copyWith(
        isLoading: !current.hasContent,
        isRefreshing: current.hasContent,
        isLoadingMore: false,
        error: null,
        loadMoreError: null,
      ),
    );
    try {
      final result = await search(
        criteria: criteria,
        languageCode: languageCode,
        page: 1,
        limit: current.limit,
      );
      if (!mounted || generation != _generation) return;
      state = state.copyWith(
        hotels: state.hotels.copyWith(
          hotels: result.hotels,
          totalCount: result.totalCount,
          nextPage: 2,
          isLoading: false,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      if (!mounted || generation != _generation) return;
      state = state.copyWith(
        hotels: state.hotels.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: e,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.hotels;
    if (current.isLoading ||
        current.isRefreshing ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }
    final generation = _generation;
    state = state.copyWith(
      hotels: current.copyWith(isLoadingMore: true, loadMoreError: null),
    );
    try {
      final result = await search(
        criteria: current.criteria,
        languageCode: languageCode,
        page: current.nextPage,
        limit: current.limit,
      );
      if (!mounted || generation != _generation) return;
      final rows = [...current.hotels, ...result.hotels];
      state = state.copyWith(
        hotels: state.hotels.copyWith(
          hotels: rows,
          totalCount: result.hotels.isEmpty ? rows.length : result.totalCount,
          nextPage: current.nextPage + 1,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (!mounted || generation != _generation) return;
      state = state.copyWith(
        hotels: state.hotels.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }
}
