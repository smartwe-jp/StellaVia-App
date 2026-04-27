import '../entities/fund_project.dart';

abstract class FundProjectRepository {
  Future<List<FundProject>> fetchFundProjectList();
  Future<FundProject> fetchFundProjectDetail({required String id});
  Future<FundProjectApplyDetail> fetchFundProjectApplyDetail({
    required String projectId,
  });
  Future<void> submitLotteryApply({
    required String projectId,
    required int units,
    required int amount,
  });
}
