import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../support/secondary_market_trade_support.dart';

final tradeOfferingsProvider = FutureProvider.autoDispose<List<FundProject>>((
  ref,
) async {
  ref.watch(myPageMembershipIdentityProvider);
  final projects = await ref.watch(fetchFundProjectListUseCaseProvider).call();
  return projects
      .where(
        (project) =>
            project.projectStatus == 1 &&
            project.id.isNotEmpty &&
            (project.currentOpenInvestor?.availableApplyTotal ?? 0) > 0,
      )
      .toList();
});

enum TradeList { sell, offerings, buy, salesHistory, purchaseHistory }

class TradePageData {
  const TradePageData({
    required this.total,
    this.holdings = const [],
    this.offerings = const [],
    this.orders = const [],
    this.applications = const [],
  });
  final int total;
  final List<FundProject> offerings;
  final List<SecondaryMarketHolding> holdings;
  final List<MyPageOrderInquiryRecord> orders;
  final List<MyPageApplyRecord> applications;
  bool get empty =>
      offerings.isEmpty &&
      holdings.isEmpty &&
      orders.isEmpty &&
      applications.isEmpty;
  int get pages => (total / 10).ceil();
}

final tradePageProvider = FutureProvider.autoDispose
    .family<TradePageData, ({TradeList list, int page})>((ref, query) async {
      final identity = ref.watch(myPageMembershipIdentityProvider);
      if (identity == null || identity.$2 == null) {
        throw StateError('Authenticated member required');
      }
      if (query.list == TradeList.offerings) {
        final projects = await ref.watch(tradeOfferingsProvider.future);
        return TradePageData(
          total: projects.length,
          offerings: projects.skip((query.page - 1) * 10).take(10).toList(),
        );
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
