import '../../domain/entities/wallet_account_history.dart';
import '../../domain/entities/wallet_bank_account_draft.dart';
import '../../domain/entities/wallet_bank_account_info.dart';
import '../../domain/entities/wallet_withdraw_apply_draft.dart';
import '../../domain/entities/wallet_withdraw_record.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import '../models/wallet_account_history_dto.dart';
import '../models/wallet_bank_account_info_dto.dart';
import '../models/wallet_bank_account_pool_dto.dart';
import '../models/wallet_withdraw_dto.dart';

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

  @override
  Future<WalletBankAccountInfo?> fetchBankAccountInfo() async {
    final dto = await _remote.fetchBankAccountInfo();
    return dto?.toEntityOrNull();
  }

  @override
  Future<List<WalletBankAccountInfo>> fetchBankAccountList() async {
    final dtos = await _remote.fetchBankAccountList();
    return dtos
        .map((WalletBankAccountPoolDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> applyBankAccount() {
    return _remote.applyBankAccount();
  }

  @override
  Future<void> addBankAccount(WalletBankAccountDraft draft) {
    return _remote.addBankAccount(draft.toDto());
  }

  @override
  Future<void> deleteBankAccount({required Object id}) {
    return _remote.deleteBankAccount(id: id);
  }

  @override
  Future<void> sendWithdrawApplyCode() {
    return _remote.sendWithdrawApplyCode();
  }

  @override
  Future<void> confirmPayment({required Object amount}) {
    return _remote.confirmPayment(amount: amount);
  }

  @override
  Future<bool> autoFundDeduction({required String processId}) {
    return _remote.autoFundDeduction(processId: processId);
  }

  @override
  Future<void> applyWithdraw(WalletWithdrawApplyDraft draft) {
    return _remote.applyWithdraw(draft.toDto());
  }

  @override
  Future<void> cancelWithdraw(WalletWithdrawRecord record) {
    return _remote.cancelWithdraw(record.toCancelDto());
  }

  @override
  Future<num> fetchWithdrawCost({required Object bankId}) {
    return _remote.fetchWithdrawCost(bankId: bankId);
  }

  @override
  Future<List<WalletWithdrawRecord>> fetchWithdrawHistory() async {
    final dtos = await _remote.fetchWithdrawHistory();
    return dtos
        .map((WalletWithdrawRecordDto dto) => dto.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<WalletWithdrawRecord>> fetchWithdrawingList() async {
    final dtos = await _remote.fetchWithdrawingList();
    return dtos
        .map((WalletWithdrawRecordDto dto) => dto.toEntity())
        .toList(growable: false);
  }
}
