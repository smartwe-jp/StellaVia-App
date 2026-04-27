import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class FundProjectRemoteDataSource {
  Future<List<FundProjectDto>> fetchFundProjectList();
  Future<FundProjectDto> fetchFundProjectDetail({required String id});
  Future<FundProjectApplyDetailDto> fetchFundProjectApplyDetail({
    required String projectId,
  });
  Future<void> submitLotteryApply({
    required String projectId,
    required int units,
    required int amount,
  });
}

class FundProjectRemoteDataSourceImpl implements FundProjectRemoteDataSource {
  FundProjectRemoteDataSourceImpl(
    CoreHttpClient client, {
    FundProjectApiClient? apiClient,
    UserInvestmentApiClient? userInvestmentApiClient,
  }) : _apiClient = apiClient ?? FundProjectApiClient(client),
       _userInvestmentApiClient =
           userInvestmentApiClient ??
           UserInvestmentApiClient(dioForPath: (_) => client.dio);

  final FundProjectApiClient _apiClient;
  final UserInvestmentApiClient _userInvestmentApiClient;

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    return _apiClient.fetchFundProjectList();
  }

  @override
  Future<FundProjectDto> fetchFundProjectDetail({required String id}) async {
    return _apiClient.fetchFundProjectDetail(id: id);
  }

  @override
  Future<FundProjectApplyDetailDto> fetchFundProjectApplyDetail({
    required String projectId,
  }) async {
    return _apiClient.fetchProjectApplyDetail(projectId: projectId);
  }

  @override
  Future<void> submitLotteryApply({
    required String projectId,
    required int units,
    required int amount,
  }) async {
    return _userInvestmentApiClient.submitApply(
      projectId: projectId,
      units: units,
      amount: amount,
    );
  }
}
