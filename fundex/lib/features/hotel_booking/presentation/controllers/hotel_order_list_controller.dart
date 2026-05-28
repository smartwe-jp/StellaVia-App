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
    this.expiredOrderIds = const <String>{},
    this.error,
  });

  final HotelOrderStatusFilter status;
  final List<HotelOrderSummary> orders;
  final int totalCount;
  final int nextPage;
  final int limit;
  final bool isLoading;
  final bool isLoadingMore;
  final Set<String> expiredOrderIds;
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
    Set<String>? expiredOrderIds,
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
      expiredOrderIds: expiredOrderIds ?? this.expiredOrderIds,
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
        orders: _applyExpiredOverrides(result.orders),
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
        orders: _applyExpiredOverrides(<HotelOrderSummary>[
          ...state.orders,
          ...result.orders,
        ]),
        totalCount: result.totalCount,
        nextPage: result.page + 1,
        isLoadingMore: false,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(isLoadingMore: false, error: error);
    }
  }

  Future<void> markPaymentExpired(String orderId) async {
    final trimmed = orderId.trim();
    if (trimmed.isEmpty) {
      return;
    }
    state = state.copyWith(
      expiredOrderIds: <String>{...state.expiredOrderIds, trimmed},
      orders: _applyExpiredOverrides(state.orders, extraExpiredId: trimmed),
    );
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    await refresh();
  }

  List<HotelOrderSummary> _applyExpiredOverrides(
    List<HotelOrderSummary> orders, {
    String? extraExpiredId,
  }) {
    final expiredIds = <String>{
      ...state.expiredOrderIds,
      if (extraExpiredId != null) extraExpiredId,
    };
    if (expiredIds.isEmpty) {
      return orders;
    }
    return orders
        .map((order) {
          if (!expiredIds.contains(order.id)) {
            return order;
          }
          return HotelOrderSummary(
            id: order.id,
            hotelName: order.hotelName,
            buildingName: order.buildingName,
            hotelImageUrl: order.hotelImageUrl,
            hotelAddress: order.hotelAddress,
            checkIn: order.checkIn,
            checkOut: order.checkOut,
            bookingOrderTime: order.bookingOrderTime,
            paymentStatus: order.paymentStatus,
            paymentStatusCode: order.paymentStatusCode,
            orderStatus: '',
            orderStatusCode: 5,
            payCode: order.payCode,
            totalAmount: order.totalAmount,
            canPay: false,
            canRefund: false,
          );
        })
        .toList(growable: false);
  }
}

const Object _unchanged = Object();
