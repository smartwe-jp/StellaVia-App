import '../../domain/entities/fund_project.dart';
import '../../domain/repositories/fund_project_repository.dart';
import '../datasources/fund_project_remote_data_source.dart';
import '../models/fund_project_dto.dart';

class FundProjectRepositoryImpl implements FundProjectRepository {
  FundProjectRepositoryImpl({required FundProjectRemoteDataSource remote})
    : _remote = remote;

  final FundProjectRemoteDataSource _remote;

  @override
  Future<List<FundProject>> fetchFundProjectList() async {
    final dtos = await _remote.fetchFundProjectList();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<FundProject> fetchFundProjectDetail({required String id}) async {
    final dto = await _remote.fetchFundProjectDetail(id: id);
    return dto.toEntity();
  }

  @override
  Future<void> submitLotteryApply({
    required String projectId,
    required int units,
    required int amount,
  }) async {
    await _remote.submitLotteryApply(
      projectId: projectId,
      units: units,
      amount: amount,
    );
  }
}
