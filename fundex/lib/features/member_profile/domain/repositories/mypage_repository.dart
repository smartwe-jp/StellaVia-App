import '../entities/mypage_models.dart';

abstract class MyPageRepository {
  Future<MyPageAccountStatistic> fetchAccountStatistic();

  Future<List<MyPageApplyRecord>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  });

  Future<List<MyPageOrderInquiryRecord>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
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
}
