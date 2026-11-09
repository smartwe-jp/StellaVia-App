import 'trade_management_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';

enum SecondaryMarketListKind { market, purchases, sales }

class SecondaryMarketState {
  const SecondaryMarketState({
    this.orders = const [],
    this.applications = const [],
    this.loading = false,
    this.hasMore = true,
    this.error,
  });
  final List<MyPageOrderInquiryRecord> orders;
  final List<MyPageApplyRecord> applications;
  final bool loading, hasMore;
  final Object? error;
}

final secondaryMarketControllerProvider = StateNotifierProvider.autoDispose
    .family<
      SecondaryMarketController,
      SecondaryMarketState,
      SecondaryMarketListKind
    >((ref, kind) {
      final user = ref.watch(currentAuthUserProvider).asData?.value;
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      final controller = SecondaryMarketController(
        fetchOrders: (page) async {
          if (kind != SecondaryMarketListKind.market && user?.userId == null) {
            return [];
          }
          return ref
              .read(fetchMyPageOrderInquiryListUseCaseProvider)
              .call(
                startPage: page,
                limit: 20,
                status: kind == SecondaryMarketListKind.market ? 'VALID' : null,
                userId: kind == SecondaryMarketListKind.sales
                    ? user?.userId
                    : null,
                publicAccess: !authenticated,
              );
        },
        fetchApplications: (page) async {
          if (user?.userId == null) return [];
          return ref
              .read(fetchMyPageApplyListUseCaseProvider)
              .call(startPage: page, limit: 20, marketType: 2);
        },
        purchases: kind == SecondaryMarketListKind.purchases,
      );
      controller.refresh();
      return controller;
    });

class SecondaryMarketController extends StateNotifier<SecondaryMarketState> {
  SecondaryMarketController({
    required this.fetchOrders,
    required this.fetchApplications,
    required this.purchases,
  }) : super(const SecondaryMarketState());
  final Future<List<MyPageOrderInquiryRecord>> Function(int) fetchOrders;
  final Future<List<MyPageApplyRecord>> Function(int) fetchApplications;
  final bool purchases;
  int _page = 1, _generation = 0;

  Future<void> refresh() => _load(reset: true);
  Future<void> loadMore() async {
    if (state.loading || !state.hasMore) return;
    await _load(reset: false);
  }

  Future<void> _load({required bool reset}) async {
    final generation = ++_generation;
    final page = reset ? 1 : _page;
    state = SecondaryMarketState(
      orders: state.orders,
      applications: state.applications,
      loading: true,
      hasMore: state.hasMore,
    );
    try {
      final orders = purchases
          ? <MyPageOrderInquiryRecord>[]
          : await fetchOrders(page);
      final applications = purchases
          ? await fetchApplications(page)
          : <MyPageApplyRecord>[];
      if (!mounted || generation != _generation) return;
      final allOrders = reset
          ? <MyPageOrderInquiryRecord>[]
          : [...state.orders];
      final allApplications = reset
          ? <MyPageApplyRecord>[]
          : [...state.applications];
      // Identity is a listing/process, never a project: one project can have many trades.
      for (final order in orders) {
        final index = allOrders.indexWhere(
          (old) => order.id != null && old.id == order.id,
        );
        if (index < 0) {
          allOrders.add(order);
        } else {
          allOrders[index] = order;
        }
      }
      for (final application in applications) {
        final index = allApplications.indexWhere(
          (old) =>
              application.processId != null &&
              old.processId == application.processId,
        );
        if (index < 0) {
          allApplications.add(application);
        } else {
          allApplications[index] = application;
        }
      }
      _page = page + 1;
      state = SecondaryMarketState(
        orders: allOrders,
        applications: allApplications,
        hasMore: (purchases ? applications.length : orders.length) == 20,
      );
    } catch (error) {
      if (!mounted || generation != _generation) return;
      state = SecondaryMarketState(
        orders: state.orders,
        applications: state.applications,
        hasMore: state.hasMore,
        error: error,
      );
    }
  }
}

// There is no single-listing GET in the contract. Search paginated fresh data,
// including invalid/sold listings, rather than trusting a navigation snapshot.
final secondaryMarketOrderProvider = FutureProvider.autoDispose
    .family<MyPageOrderInquiryRecord?, String>((ref, id) async {
      final authenticated =
          ref.watch(isAuthenticatedProvider).asData?.value == true;
      ref.watch(currentAuthUserProvider);
      for (var page = 1; ; page++) {
        final rows = await ref
            .read(fetchMyPageOrderInquiryListUseCaseProvider)
            .call(startPage: page, limit: 100, publicAccess: !authenticated);
        for (final row in rows) {
          if (row.id == id) return row;
        }
        if (rows.length < 100) return null;
      }
    });

final secondaryMarketApplicationProvider = FutureProvider.autoDispose
    .family<MyPageApplyRecord?, String>((ref, processId) async {
      final user = await ref.watch(currentAuthUserProvider.future);
      if (user?.userId == null) return null;
      for (var page = 1; ; page++) {
        final rows = await ref
            .read(fetchMyPageApplyListUseCaseProvider)
            .call(marketType: 2, startPage: page, limit: 100);
        for (final row in rows) {
          if (row.processId == processId) return row;
        }
        if (rows.length < 100) return null;
      }
    });

void refreshSecondaryMarket(WidgetRef ref) {
  ref.invalidate(tradePageProvider);
  ref.invalidate(secondaryMarketActiveSalesProvider);
  ref.invalidate(secondaryMarketControllerProvider);
  ref.invalidate(secondaryMarketOrderProvider);
  ref.invalidate(secondaryMarketApplicationProvider);
  ref.invalidate(secondaryMarketMarketplaceListProvider);
  ref.invalidate(myPageOrderInquiryListProvider);
  ref.invalidate(myPageInvestmentListProvider);
  ref.invalidate(secondaryMarketHoldingsProvider);
  ref.invalidate(myPageAccountStatisticProvider);
}

/// Current account's active listings for one purchase record. Fetch every page
/// before declaring the scoped list empty: its listings may be on later pages.
final secondaryMarketActiveSalesProvider = FutureProvider.autoDispose
    .family<
      List<MyPageOrderInquiryRecord>,
      ({String projectId, String processId})
    >((ref, source) async {
      final user = await ref.watch(currentAuthUserProvider.future);
      if (user?.userId == null ||
          source.projectId.isEmpty ||
          source.processId.isEmpty) {
        return [];
      }
      var disposed = false;
      ref.onDispose(() => disposed = true);
      final fetch = ref.read(fetchMyPageOrderInquiryListUseCaseProvider);
      final result = <String, MyPageOrderInquiryRecord>{};
      for (var page = 1; !disposed; page++) {
        final rows = await fetch.call(
          startPage: page,
          limit: 100,
          status: 'VALID',
          userId: user!.userId,
        );
        if (disposed) return [];
        for (final row in rows) {
          if (row.projectId == source.projectId &&
              row.fromProcessId == source.processId &&
              row.status?.toUpperCase() == 'VALID' &&
              (row.sellNum ?? 0) > (row.soldNum ?? 0) &&
              row.id != null) {
            result[row.id!] = row;
          }
        }
        if (rows.length < 100) break;
      }
      return result.values.toList(growable: false);
    });
