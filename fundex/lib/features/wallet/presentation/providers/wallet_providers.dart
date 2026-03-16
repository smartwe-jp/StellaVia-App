import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../data/datasources/wallet_remote_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_account_history.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/add_wallet_bank_account_usecase.dart';
import '../../domain/usecases/apply_wallet_bank_account_usecase.dart';
import '../../domain/usecases/fetch_wallet_bank_account_list_usecase.dart';
import '../../domain/usecases/fetch_wallet_bank_account_info_usecase.dart';
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

final fetchWalletBankAccountInfoUseCaseProvider =
    Provider<FetchWalletBankAccountInfoUseCase>((ref) {
      return FetchWalletBankAccountInfoUseCase(
        ref.watch(walletRepositoryProvider),
      );
    });

final applyWalletBankAccountUseCaseProvider =
    Provider<ApplyWalletBankAccountUseCase>((ref) {
      return ApplyWalletBankAccountUseCase(ref.watch(walletRepositoryProvider));
    });

final fetchWalletBankAccountListUseCaseProvider =
    Provider<FetchWalletBankAccountListUseCase>((ref) {
      return FetchWalletBankAccountListUseCase(
        ref.watch(walletRepositoryProvider),
      );
    });

final addWalletBankAccountUseCaseProvider =
    Provider<AddWalletBankAccountUseCase>((ref) {
      return AddWalletBankAccountUseCase(ref.watch(walletRepositoryProvider));
    });

final walletBankAccountApplyingProvider = StateProvider<bool>((ref) => false);
final walletBankAccountAddingProvider = StateProvider<bool>((ref) => false);

final walletHistoryProvider = FutureProvider<List<WalletAccountHistory>>((ref) {
  return ref
      .watch(fetchWalletAccountHistoryUseCaseProvider)
      .call(accountType: 0);
});

final walletBankAccountListProvider =
    FutureProvider<List<WalletBankAccountInfo>>((ref) {
      return ref.watch(fetchWalletBankAccountListUseCaseProvider).call();
    });

final walletDepositPageViewDataProvider =
    FutureProvider<WalletDepositPageViewData>((ref) async {
      WalletDedicatedBankInfo? bankInfo;
      try {
        final account = await ref
            .watch(fetchWalletBankAccountInfoUseCaseProvider)
            .call();
        if (account != null) {
          bankInfo = WalletDedicatedBankInfo(
            bankName: account.bankName,
            branchName: account.branchName,
            accountType: account.accountType,
            accountNumber: account.accountNumber,
            accountHolder: account.accountHolder,
            expireTime: account.expireTime,
          );
        }
      } catch (_) {
        bankInfo = null;
      }

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
        bankInfo: bankInfo,
        standbyBalance: standbyBalance,
        recentHistory: preview,
      );
    });
