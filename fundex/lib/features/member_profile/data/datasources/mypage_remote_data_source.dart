import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../models/mypage_dtos.dart';

abstract class MyPageRemoteDataSource {
  Future<MyPageAccountStatisticDto> fetchAccountStatistic();

  Future<List<MyPageApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  });

  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  });

  Future<List<MyPageInvestmentRecordDto>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  });

  Future<MyPageProjectBenefitDto> fetchProjectBenefit({
    required String projectId,
  });

  Future<bool> submitBenefitWithdrawal({required String benefitId});
}

class MyPageRemoteDataSourceImpl implements MyPageRemoteDataSource {
  MyPageRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    UserInvestmentApiClient? apiClient,
  }) : this._(
         clusterRouter:
             clusterRouter ??
             ApiClusterRouter.fromClients(
               oaClient: oaClient,
               memberClient: memberClient,
             ),
         apiClient: apiClient,
       );

  MyPageRemoteDataSourceImpl._({
    required ApiClusterRouter clusterRouter,
    UserInvestmentApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           UserInvestmentApiClient(
             dioForPath: (String path) {
               return clusterRouter.dioForPath(path);
             },
           );

  final UserInvestmentApiClient _apiClient;

  @override
  Future<MyPageAccountStatisticDto> fetchAccountStatistic() async {
    return _apiClient.fetchAccountStatistic();
  }

  @override
  Future<List<MyPageApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  }) async {
    return _apiClient.fetchApplyList(startPage: startPage, limit: limit);
  }

  @override
  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  }) async {
    return _apiClient.fetchOrderInquiryList(
      userId: userId,
      startPage: startPage,
      limit: limit,
    );
  }

  @override
  Future<List<MyPageInvestmentRecordDto>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  }) async {
    return _apiClient.fetchInvestmentList(startPage: startPage, limit: limit);
  }

  @override
  Future<MyPageProjectBenefitDto> fetchProjectBenefit({
    required String projectId,
  }) async {
    return _apiClient.fetchProjectBenefit(projectId: projectId);
  }

  @override
  Future<bool> submitBenefitWithdrawal({required String benefitId}) async {
    return _apiClient.submitBenefitWithdrawal(benefitId: benefitId);
  }
}
