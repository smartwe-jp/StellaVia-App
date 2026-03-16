import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/network/app_network_providers.dart';
import '../../data/datasources/fund_project_remote_data_source.dart';
import '../../data/repositories/fund_project_repository_impl.dart';
import '../../domain/entities/fund_project.dart';
import '../../domain/repositories/fund_project_repository.dart';
import '../../domain/usecases/fetch_fund_project_detail_usecase.dart';
import '../../domain/usecases/fetch_fund_project_list_usecase.dart';
import '../../domain/usecases/submit_fund_lottery_apply_usecase.dart';
import '../support/fund_detail_static_content.dart';

final fundProjectRemoteDataSourceProvider =
    Provider<FundProjectRemoteDataSource>((ref) {
      return FundProjectRemoteDataSourceImpl(
        ref.watch(oaCoreHttpClientProvider),
      );
    });

final fundProjectRepositoryProvider = Provider<FundProjectRepository>((ref) {
  return FundProjectRepositoryImpl(
    remote: ref.watch(fundProjectRemoteDataSourceProvider),
  );
});

final fetchFundProjectListUseCaseProvider =
    Provider<FetchFundProjectListUseCase>((ref) {
      return FetchFundProjectListUseCase(
        ref.watch(fundProjectRepositoryProvider),
      );
    });

final fetchFundProjectDetailUseCaseProvider =
    Provider<FetchFundProjectDetailUseCase>((ref) {
      return FetchFundProjectDetailUseCase(
        ref.watch(fundProjectRepositoryProvider),
      );
    });

final submitFundLotteryApplyUseCaseProvider =
    Provider<SubmitFundLotteryApplyUseCase>((ref) {
      return SubmitFundLotteryApplyUseCase(
        ref.watch(fundProjectRepositoryProvider),
      );
    });

final fundProjectListProvider = FutureProvider<List<FundProject>>((ref) async {
  return ref.watch(fetchFundProjectListUseCaseProvider).call();
});

final fundProjectDetailProvider = FutureProvider.family<FundProject, String>((
  ref,
  String id,
) async {
  return ref.watch(fetchFundProjectDetailUseCaseProvider).call(id: id);
});

final fundDetailStaticContentProvider =
    FutureProvider.family<FundDetailStaticContent, String>((
      ref,
      String localeTag,
    ) async {
      return FundDetailStaticContent.load(localeTag);
    });
