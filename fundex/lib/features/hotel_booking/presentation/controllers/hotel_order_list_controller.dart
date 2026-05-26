import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/hotel_models.dart';
import '../../domain/usecases/fetch_hotel_order_list_usecase.dart';

@immutable
class HotelOrderListState {
  const HotelOrderListState({
    this.status = HotelOrderStatusFilter.all,
    this.orders = const <HotelOrderSummary>[],
    this.totalCount = 0,
    this.nextPage = 1,
    this.limit = 5,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final HotelOrderStatusFilter status;
  final List<HotelOrderSummary> orders;
  final int totalCount;
  final int nextPage;
  final int limit;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  bool get hasContent => orders.isNotEmpty;
  bool get hasMore => orders.length < totalCount;

  HotelOrderListState copyWith({
    HotelOrderStatusFilter? status,
    List<HotelOrderSummary>? orders,
    int? totalCount,
    int? nextPage,
    int? limit,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error = _unchanged,
  }) {
    return HotelOrderListState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      totalCount: totalCount ?? this.totalCount,
      nextPage: nextPage ?? this.nextPage,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _unchanged) ? this.error : error,
    );
  }
}

class HotelOrderListController extends StateNotifier<HotelOrderListState> {
  HotelOrderListController({
    required FetchHotelOrderListUseCase fetchOrderList,
    required String languageCode,
  }) : _fetchOrderList = fetchOrderList,
       _languageCode = languageCode,
       super(const HotelOrderListState()) {
    refresh();
  }

  final FetchHotelOrderListUseCase _fetchOrderList;
  final String _languageCode;

  Future<void> setStatus(HotelOrderStatusFilter status) async {
    if (state.status == status) {
      return;
    }
    state = state.copyWith(
      status: status,
      orders: const <HotelOrderSummary>[],
      totalCount: 0,
      nextPage: 1,
      error: null,
    );
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, isLoadingMore: false, error: null);
    try {
      final result = await _fetchOrderList(
        languageCode: _languageCode,
        status: state.status,
        page: 1,
        limit: state.limit,
      );
      state = state.copyWith(
        orders: result.orders,
        totalCount: result.totalCount,
        nextPage: 2,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final result = await _fetchOrderList(
        languageCode: _languageCode,
        status: state.status,
        page: state.nextPage,
        limit: state.limit,
      );
      state = state.copyWith(
        orders: <HotelOrderSummary>[...state.orders, ...result.orders],
        totalCount: result.totalCount,
        nextPage: result.page + 1,
        isLoadingMore: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(isLoadingMore: false, error: error);
    }
  }
}

const Object _unchanged = Object();
