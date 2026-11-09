import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../asset_statistics/presentation/providers/asset_statistics_providers.dart';
import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../../wallet/domain/entities/wallet_bank_account_info.dart';
import '../../domain/entities/mypage_models.dart';
import '../support/host_fund_management.dart';
import 'mypage_providers.dart';
import 'mypage_membership_providers.dart';

void _requireMember(Ref ref) {
  if (ref.watch(myPageMembershipIdentityProvider) == null) {
    throw StateError('Authenticated user required');
  }
}

final hostFundApplicationsProvider = FutureProvider.autoDispose
    .family<
      ({List<MyPageApplyRecord> rows, int total}),
      ({int status, int page})
    >((ref, query) {
      _requireMember(ref);
      return ref
          .watch(myPageRepositoryProvider)
          .fetchFundManagementApplications(
            page: query.page,
            status: query.status,
          );
    });
final hostFundHoldingsProvider =
    FutureProvider.autoDispose<AssetInvestmentChart>((ref) {
      _requireMember(ref);
      return ref.watch(assetStatisticsRepositoryProvider).fetchInvestments();
    });
final hostFundForecastProvider = FutureProvider.autoDispose
    .family<List<FundForecastMonth>, int>((ref, years) async {
      _requireMember(ref);
      final now = DateTime.now();
      final data = await ref
          .watch(assetStatisticsRepositoryProvider)
          .fetchForecast(
            endYearMonth: DateTime(now.year, now.month + 12 * years + 1),
          );
      return forecastMonths(data, now, years);
    });
final hostFundDividendsProvider = FutureProvider.autoDispose
    .family<
      ({AssetCumulativeBenefit chart, List<AssetYearlyBenefit> years}),
      int
    >((ref, years) async {
      _requireMember(ref);
      final repo = ref.watch(assetStatisticsRepositoryProvider);
      final now = DateTime.now();
      final start = DateTime(now.year - years, now.month, now.day);
      final (chart, annual) = await (
        repo.fetchCumulativeBenefit(startDate: start, endDate: now),
        repo.fetchYearlyBenefits(startYear: start.year),
      ).wait;
      return (
        chart: chart,
        years: annual.where((row) => row.year != null).toList()
          ..sort((a, b) => b.year!.compareTo(a.year!)),
      );
    });

final hostFundBankProvider = FutureProvider.autoDispose
    .family<({WalletBankAccountInfo? bank, bool projectAccount}), String?>((
      ref,
      projectId,
    ) async {
      _requireMember(ref);
      final wallet = ref.watch(walletRepositoryProvider);
      final fetchProject = ref.watch(fetchFundProjectDetailUseCaseProvider);
      WalletBankAccountInfo? account;
      try {
        account = await wallet.fetchBankAccountInfo();
      } catch (_) {
        if (projectId == null) rethrow;
      }
      if (account != null &&
          [
            account.bankName,
            account.branchName,
            account.accountNumber,
            account.accountHolder,
          ].any((s) => s.trim().isNotEmpty && s != '--')) {
        return (bank: account, projectAccount: false);
      }
      if (projectId == null || projectId.isEmpty) {
        return (bank: null, projectAccount: false);
      }
      final b = (await fetchProject(id: projectId)).liveJapanBank;
      if (b == null) return (bank: null, projectAccount: false);
      return (
        projectAccount: true,
        bank: WalletBankAccountInfo(
          bankName: b.bankName ?? '',
          branchName: b.branchBankName ?? '',
          branchNumber: b.branchBankNumber,
          accountType: b.bankAccountType ?? '',
          accountNumber: b.bankNumber ?? '',
          accountHolder: b.bankAccountOwnerName ?? '',
        ),
      );
    });
