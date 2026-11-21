import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../asset_statistics/presentation/providers/asset_statistics_providers.dart';
import '../../../asset_statistics/domain/entities/asset_statistics_models.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
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
final hostFundHoldingsProvider = FutureProvider.autoDispose
    .family<AssetInvestmentChart, HostFundTab>((ref, tab) {
      _requireMember(ref);
      final status = switch (tab) {
        HostFundTab.beforeOperation => const [1, 7, 3],
        HostFundTab.running => const [4],
        _ => throw ArgumentError.value(tab),
      };
      return ref
          .watch(assetStatisticsRepositoryProvider)
          .fetchInvestments(status: status);
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

enum HostFundBankSource {
  pool,
  domesticProject,
  overseasProject,
  unknownResidency,
}

typedef HostFundDepositAccount = ({
  WalletBankAccountInfo? bank,
  HostFundBankSource source,
});

final hostFundBankProvider = FutureProvider.autoDispose
    .family<HostFundDepositAccount, String?>((ref, projectId) async {
      _requireMember(ref);
      final wallet = ref.watch(walletRepositoryProvider);
      final fetchProject = ref.watch(fetchFundProjectDetailUseCaseProvider);
      final user = await ref.watch(currentAuthUserProvider.future);
      final residency = user?.liveJp;
      if (residency != 0 && residency != 1) {
        return (bank: null, source: HostFundBankSource.unknownResidency);
      }
      final resident = residency == 1;
      if (resident) {
        WalletBankAccountInfo? account;
        try {
          account = await wallet.fetchBankAccountInfo();
        } catch (_) {
          if (projectId == null || projectId.isEmpty) rethrow;
        }
        if (account?.hasDepositDetails == true) {
          return (bank: account, source: HostFundBankSource.pool);
        }
      }
      final source = resident
          ? HostFundBankSource.domesticProject
          : HostFundBankSource.overseasProject;
      if (projectId == null || projectId.isEmpty)
        return (bank: null, source: source);
      final project = await fetchProject(id: projectId);
      final b = resident ? project.liveJapanBank : project.notLiveJapanBank;
      if (b == null ||
          [
            b.bankName,
            b.bankNumber,
          ].any((v) => v == null || v.trim().isEmpty || v.trim() == '--')) {
        return (bank: null, source: source);
      }
      return (
        source: source,
        bank: WalletBankAccountInfo(
          bankName: b.bankName ?? '',
          branchName: b.branchBankName ?? '',
          branchNumber: b.branchBankNumber,
          accountType: b.bankAccountType ?? '',
          accountNumber: b.bankNumber ?? '',
          accountHolder: b.bankAccountOwnerName ?? '',
          swiftCode: b.bankAccountSwiftCode,
          bankCountry: b.bankCountry,
          branchAddress: b.branchBankAddress,
          accountHolderAddress: b.bankAccountOwnerAddress,
        ),
      );
    });
