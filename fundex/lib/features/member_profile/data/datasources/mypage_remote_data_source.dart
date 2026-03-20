import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../models/mypage_dtos.dart';

abstract class MyPageRemoteDataSource {
  Future<MyPageAccountStatisticDto> fetchAccountStatistic();

  Future<List<MyPageApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
    List<int>? statuses,
  });

  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    int? userId,
    String? status,
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

  Future<void> submitSecondaryMarketCreate({
    required String fromProcessId,
    required int sellNum,
    required int price,
  });

  Future<void> submitSecondaryMarketPurchase({
    required String id,
    required int buyNum,
  });
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
    List<int>? statuses,
  }) async {
    return _apiClient.fetchApplyList(
      startPage: startPage,
      limit: limit,
      statuses: statuses,
    );
  }

  @override
  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    int? userId,
    String? status,
    int startPage = 1,
    int limit = 20,
  }) async {
    return _apiClient.fetchOrderInquiryList(
      userId: userId,
      status: status,
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

  @override
  Future<void> submitSecondaryMarketCreate({
    required String fromProcessId,
    required int sellNum,
    required int price,
  }) async {
    await _apiClient.submitSecondaryMarketCreate(
      fromProcessId: fromProcessId,
      sellNum: sellNum,
      price: price,
    );
  }

  @override
  Future<void> submitSecondaryMarketPurchase({
    required String id,
    required int buyNum,
  }) async {
    await _apiClient.submitSecondaryMarketPurchase(id: id, buyNum: buyNum);
  }
}
