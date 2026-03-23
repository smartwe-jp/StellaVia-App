import '../entities/mypage_models.dart';

abstract class MyPageRepository {
  Future<MyPageAccountStatistic> fetchAccountStatistic();

  Future<List<MyPageApplyRecord>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
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
