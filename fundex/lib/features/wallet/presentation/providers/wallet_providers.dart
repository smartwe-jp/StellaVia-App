import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../data/datasources/wallet_remote_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_account_history.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/fetch_wallet_account_history_usecase.dart';
import '../support/wallet_view_data.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl(
    ref.watch(oaCoreHttpClientProvider),
    memberClient: ref.watch(memberCoreHttpClientProvider),
    clusterRouter: ref.watch(apiClusterRouterProvider),
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remote: ref.watch(walletRemoteDataSourceProvider),
  );
});

final fetchWalletAccountHistoryUseCaseProvider =
    Provider<FetchWalletAccountHistoryUseCase>((ref) {
      return FetchWalletAccountHistoryUseCase(
        ref.watch(walletRepositoryProvider),
      );
    });

final walletHistoryProvider = FutureProvider<List<WalletAccountHistory>>((ref) {
  return ref
      .watch(fetchWalletAccountHistoryUseCaseProvider)
      .call(accountType: 0);
});

final walletDepositPageViewDataProvider =
    FutureProvider<WalletDepositPageViewData>((ref) async {
      List<WalletAccountHistory> history = const <WalletAccountHistory>[];
      try {
        final all = await ref
            .watch(fetchWalletAccountHistoryUseCaseProvider)
            .call(accountType: 0);
        history = all;
      } catch (_) {
        history = const <WalletAccountHistory>[];
      }

      final preview = history.take(2).toList(growable: false);
      num? standbyBalance;
      try {
        final statistic = await ref.watch(
          myPageAccountStatisticProvider.future,
        );
        standbyBalance = statistic?.firstLevelAccountTotal;
      } catch (_) {
        standbyBalance = null;
      }
      standbyBalance ??= history.isNotEmpty ? history.first.balance : null;

      return WalletDepositPageViewData(
        bankInfo: _mockDedicatedBankInfo,
        standbyBalance: standbyBalance,
        recentHistory: preview,
      );
    });

const WalletDedicatedBankInfo _mockDedicatedBankInfo = WalletDedicatedBankInfo(
  bankName: 'GMOあおぞらネット銀行',
  branchName: '法人営業部（101）',
  accountType: '普通',
  accountNumber: '8401258',
  accountHolder: 'ファンデックス（カ',
);
