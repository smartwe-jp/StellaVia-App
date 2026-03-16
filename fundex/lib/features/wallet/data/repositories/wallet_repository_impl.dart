import '../../domain/entities/wallet_account_history.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import '../models/wallet_account_history_dto.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({required WalletRemoteDataSource remote})
    : _remote = remote;

  final WalletRemoteDataSource _remote;

  @override
  Future<List<WalletAccountHistory>> fetchAccountHistory({
    int accountType = 0,
  }) async {
    final dtos = await _remote.fetchAccountHistory(accountType: accountType);
    return dtos.map((WalletAccountHistoryDto dto) => dto.toEntity()).toList();
  }
}
