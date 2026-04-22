import 'dart:typed_data';

import '../entities/mypage_models.dart';

abstract class MyPageRepository {
  Future<MyPageAccountStatistic> fetchAccountStatistic();
  Future<List<MyPageAssetTrend>> fetchAssetTrend({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<MyPageApplyRecord>> fetchApplyList({
    int? startPage,
    int? limit,
    List<int>? statuses,
  });

  Future<void> submitUserWithdraw({required String processId, String? remark});

  Future<List<MyPageOrderInquiryRecord>> fetchOrderInquiryList({
    int? userId,
    String? status,
    int startPage = 1,
    int limit = 20,
    bool publicAccess = false,
  });

  Future<List<MyPageInvestmentRecord>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  });

  Future<MyPageProjectBenefit> fetchProjectBenefit({required String projectId});

  Future<Uint8List> downloadBenefitReport({required String benefitId});

  Future<bool> submitBenefitWithdrawal({required String benefitId});

  Future<void> submitSecondaryMarketCreate({
    required String fromProcessId,
    required int sellNum,
    required int price,
  });

  Future<void> submitSecondaryMarketModify({
    required String id,
    required String fromProcessId,
    required int sellNum,
    required int price,
    required String status,
    int thisTimeSoldNum = 0,
  });

  Future<void> submitSecondaryMarketPurchase({
    required String id,
    required int buyNum,
  });
}
