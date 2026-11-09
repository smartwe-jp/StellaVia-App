import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../support/secondary_market_trade_support.dart';

enum TradeList { sell, buy, salesHistory, purchaseHistory }

class TradePageData {
  const TradePageData({
    required this.total,
    this.holdings = const [],
    this.orders = const [],
    this.applications = const [],
  });
  final int total;
  final List<SecondaryMarketHolding> holdings;
  final List<MyPageOrderInquiryRecord> orders;
  final List<MyPageApplyRecord> applications;
  bool get empty => holdings.isEmpty && orders.isEmpty && applications.isEmpty;
  int get pages => (total / 10).ceil();
}

final tradePageProvider = FutureProvider.autoDispose
    .family<TradePageData, ({TradeList list, int page})>((ref, query) async {
      final identity = ref.watch(myPageMembershipIdentityProvider);
      if (identity == null || identity.$2 == null) {
        throw StateError('Authenticated member required');
      }
      if (query.list == TradeList.sell) {
        final holdings = (await ref.watch(
          secondaryMarketHoldingsProvider.future,
        )).where((h) => h.availableNum > 0).toList();
        return TradePageData(
          total: holdings.length,
          holdings: holdings.skip((query.page - 1) * 10).take(10).toList(),
        );
      }
      final repo = ref.watch(myPageRepositoryProvider);
      if (query.list == TradeList.purchaseHistory) {
        final result = await repo.fetchTradeApplications(page: query.page);
        return TradePageData(total: result.total, applications: result.rows);
      }
      final buying = query.list == TradeList.buy;
      final result = await repo.fetchTradeListings(
        page: query.page,
        status: buying ? 'VALID' : null,
        userId: buying ? null : identity.$2,
      );
      return TradePageData(
        total: result.total,
        orders: buying
            ? result.rows
                  .where((r) => remainingUnitsForSecondaryMarketRecord(r) > 0)
                  .toList()
            : result.rows,
      );
    });
