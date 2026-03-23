import '../../domain/entities/mypage_models.dart';
import '../../domain/repositories/mypage_repository.dart';
import '../datasources/mypage_remote_data_source.dart';
import '../models/mypage_dtos.dart';

class MyPageRepositoryImpl implements MyPageRepository {
  MyPageRepositoryImpl({required MyPageRemoteDataSource remote})
    : _remote = remote;

  final MyPageRemoteDataSource _remote;

  @override
  Future<MyPageAccountStatistic> fetchAccountStatistic() async {
    final dto = await _remote.fetchAccountStatistic();
    return dto.toEntity();
  }

  @override
  Future<List<MyPageApplyRecord>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
    List<int>? statuses,
  }) async {
    final dtos = await _remote.fetchApplyList(
      startPage: startPage,
      limit: limit,
      statuses: statuses,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<void> submitUserWithdraw({required String processId, String? remark}) {
    return _remote.submitUserWithdraw(processId: processId, remark: remark);
  }

  @override
  Future<List<MyPageOrderInquiryRecord>> fetchOrderInquiryList({
    int? userId,
    String? status,
    int startPage = 1,
    int limit = 20,
    bool publicAccess = false,
  }) async {
    final dtos = await _remote.fetchOrderInquiryList(
      userId: userId,
      status: status,
      startPage: startPage,
      limit: limit,
      publicAccess: publicAccess,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<List<MyPageInvestmentRecord>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final dtos = await _remote.fetchInvestmentList(
      startPage: startPage,
      limit: limit,
    );
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<MyPageProjectBenefit> fetchProjectBenefit({
    required String projectId,
  }) async {
    final dto = await _remote.fetchProjectBenefit(projectId: projectId);
    return dto.toEntity();
  }

  @override
  Future<bool> submitBenefitWithdrawal({required String benefitId}) {
    return _remote.submitBenefitWithdrawal(benefitId: benefitId);
  }

  @override
  Future<void> submitSecondaryMarketCreate({
    required String fromProcessId,
    required int sellNum,
    required int price,
  }) {
    return _remote.submitSecondaryMarketCreate(
      fromProcessId: fromProcessId,
      sellNum: sellNum,
      price: price,
    );
  }

  @override
  Future<void> submitSecondaryMarketPurchase({
    required String id,
    required int buyNum,
  }) {
    return _remote.submitSecondaryMarketPurchase(id: id, buyNum: buyNum);
  }
}
