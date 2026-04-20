import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/mypage_remote_data_source.dart';
import '../../data/repositories/mypage_repository_impl.dart';
import '../../domain/entities/mypage_models.dart';
import '../../domain/repositories/mypage_repository.dart';
import '../../domain/usecases/fetch_mypage_account_statistic_usecase.dart';
import '../../domain/usecases/fetch_mypage_apply_list_usecase.dart';
import '../../domain/usecases/fetch_mypage_asset_trend_usecase.dart';
import '../../domain/usecases/fetch_mypage_investment_list_usecase.dart';
import '../../domain/usecases/fetch_mypage_order_inquiry_list_usecase.dart';
import '../../domain/usecases/fetch_mypage_project_benefit_usecase.dart';
import '../../domain/usecases/submit_mypage_benefit_withdrawal_usecase.dart';
import '../../domain/usecases/submit_mypage_secondary_market_create_usecase.dart';
import '../../domain/usecases/submit_mypage_secondary_market_modify_usecase.dart';
import '../../domain/usecases/submit_mypage_secondary_market_purchase_usecase.dart';
import '../../domain/usecases/submit_mypage_user_withdraw_usecase.dart';

final myPageRemoteDataSourceProvider = Provider<MyPageRemoteDataSource>((ref) {
  return MyPageRemoteDataSourceImpl(
    ref.watch(oaCoreHttpClientProvider),
    memberClient: ref.watch(memberCoreHttpClientProvider),
    clusterRouter: ref.watch(apiClusterRouterProvider),
  );
});

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  return MyPageRepositoryImpl(
    remote: ref.watch(myPageRemoteDataSourceProvider),
  );
});

final fetchMyPageApplyListUseCaseProvider =
    Provider<FetchMyPageApplyListUseCase>((ref) {
      return FetchMyPageApplyListUseCase(ref.watch(myPageRepositoryProvider));
    });

final fetchMyPageAccountStatisticUseCaseProvider =
    Provider<FetchMyPageAccountStatisticUseCase>((ref) {
      return FetchMyPageAccountStatisticUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final fetchMyPageAssetTrendUseCaseProvider =
    Provider<FetchMyPageAssetTrendUseCase>((ref) {
      return FetchMyPageAssetTrendUseCase(ref.watch(myPageRepositoryProvider));
    });

final fetchMyPageOrderInquiryListUseCaseProvider =
    Provider<FetchMyPageOrderInquiryListUseCase>((ref) {
      return FetchMyPageOrderInquiryListUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final fetchMyPageInvestmentListUseCaseProvider =
    Provider<FetchMyPageInvestmentListUseCase>((ref) {
      return FetchMyPageInvestmentListUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final fetchMyPageProjectBenefitUseCaseProvider =
    Provider<FetchMyPageProjectBenefitUseCase>((ref) {
      return FetchMyPageProjectBenefitUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final submitMyPageBenefitWithdrawalUseCaseProvider =
    Provider<SubmitMyPageBenefitWithdrawalUseCase>((ref) {
      return SubmitMyPageBenefitWithdrawalUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final submitMyPageSecondaryMarketCreateUseCaseProvider =
    Provider<SubmitMyPageSecondaryMarketCreateUseCase>((ref) {
      return SubmitMyPageSecondaryMarketCreateUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final submitMyPageSecondaryMarketPurchaseUseCaseProvider =
    Provider<SubmitMyPageSecondaryMarketPurchaseUseCase>((ref) {
      return SubmitMyPageSecondaryMarketPurchaseUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final submitMyPageSecondaryMarketModifyUseCaseProvider =
    Provider<SubmitMyPageSecondaryMarketModifyUseCase>((ref) {
      return SubmitMyPageSecondaryMarketModifyUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final submitMyPageUserWithdrawUseCaseProvider =
    Provider<SubmitMyPageUserWithdrawUseCase>((ref) {
      return SubmitMyPageUserWithdrawUseCase(
        ref.watch(myPageRepositoryProvider),
      );
    });

final myPageApplyListProvider =
    FutureProvider.autoDispose<List<MyPageApplyRecord>>((ref) async {
      return ref.watch(fetchMyPageApplyListUseCaseProvider).call();
    });

final myPagePendingApplyListProvider =
    FutureProvider.autoDispose<List<MyPageApplyRecord>>((ref) async {
      return ref
          .watch(fetchMyPageApplyListUseCaseProvider)
          .call(statuses: const <int>[0, 2]);
    });

final myPageAccountStatisticProvider =
    FutureProvider.autoDispose<MyPageAccountStatistic?>((ref) async {
      final isAuthenticated = ref.watch(isAuthenticatedProvider).asData?.value;
      if (isAuthenticated != true) {
        return null;
      }

      await ref.watch(currentAuthUserProvider.future);
      return ref.watch(fetchMyPageAccountStatisticUseCaseProvider).call();
    });

final myPageAssetTrendProvider = FutureProvider.autoDispose
    .family<List<MyPageAssetTrend>, ({DateTime startDate, DateTime endDate})>((
      ref,
      ({DateTime startDate, DateTime endDate}) range,
    ) async {
      final isAuthenticated = ref.watch(isAuthenticatedProvider).asData?.value;
      if (isAuthenticated != true) {
        return const <MyPageAssetTrend>[];
      }

      await ref.watch(currentAuthUserProvider.future);
      return ref
          .watch(fetchMyPageAssetTrendUseCaseProvider)
          .call(startDate: range.startDate, endDate: range.endDate);
    });

final myPageOrderInquiryListProvider =
    FutureProvider.autoDispose<List<MyPageOrderInquiryRecord>>((ref) async {
      final user = await ref.watch(currentAuthUserProvider.future);
      final userId = user?.userId;
      if (userId == null) {
        return const <MyPageOrderInquiryRecord>[];
      }
      return ref
          .watch(fetchMyPageOrderInquiryListUseCaseProvider)
          .call(userId: userId);
    });

final secondaryMarketMarketplaceListProvider =
    FutureProvider.autoDispose<List<MyPageOrderInquiryRecord>>((ref) async {
      final isAuthenticated =
          ref.watch(isAuthenticatedProvider).asData?.value ?? false;
      return ref
          .watch(fetchMyPageOrderInquiryListUseCaseProvider)
          .call(
            startPage: 1,
            limit: 20,
            status: 'VALID',
            publicAccess: !isAuthenticated,
          );
    });

final myPageInvestmentListProvider =
    FutureProvider.autoDispose<List<MyPageInvestmentRecord>>((ref) async {
      return ref.watch(fetchMyPageInvestmentListUseCaseProvider).call();
    });

final myPageProjectBenefitProvider = FutureProvider.autoDispose
    .family<MyPageProjectBenefit, String>((ref, String projectId) async {
      return ref
          .watch(fetchMyPageProjectBenefitUseCaseProvider)
          .call(projectId: projectId);
    });
