import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../models/wallet_account_history_dto.dart';
import '../models/wallet_bank_account_info_dto.dart';
import '../models/wallet_bank_account_pool_dto.dart';
import '../models/wallet_payment_confirmation_dto.dart';
import '../models/wallet_withdraw_dto.dart';

abstract class WalletRemoteDataSource {
  Future<List<WalletAccountHistoryDto>> fetchAccountHistory({
    int accountType = 0,
  });

  Future<WalletBankAccountInfoDto?> fetchBankAccountInfo();

  Future<List<WalletBankAccountPoolDto>> fetchBankAccountList();

  Future<void> applyBankAccount();

  Future<void> addBankAccount(WalletBankAccountAddRequestDto request);

  Future<void> deleteBankAccount({required Object id});

  Future<void> sendWithdrawApplyCode();

  Future<void> confirmPayment({required Object amount, Object? bizId});

  Future<List<WalletPaymentConfirmationRecordDto>> fetchPaymentConfirmations({
    required String bizId,
    int startPage = 1,
    int limit = 10,
  });

  Future<bool> autoFundDeduction({required String processId});

  Future<void> applyWithdraw(WalletWithdrawApplyRequestDto request);

  Future<void> cancelWithdraw(WalletWithdrawCancelRequestDto request);

  Future<num> fetchWithdrawCost({required Object bankId});

  Future<List<WalletWithdrawRecordDto>> fetchWithdrawHistory();

  Future<List<WalletWithdrawRecordDto>> fetchWithdrawingList();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    UserWalletApiClient? apiClient,
  }) : this._(
         clusterRouter:
             clusterRouter ??
             ApiClusterRouter.fromClients(
               oaClient: oaClient,
               memberClient: memberClient,
             ),
         apiClient: apiClient,
       );

  WalletRemoteDataSourceImpl._({
    required ApiClusterRouter clusterRouter,
    UserWalletApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           UserWalletApiClient(
             dioForPath: (String path) => clusterRouter.dioForPath(path),
           );

  final UserWalletApiClient _apiClient;

  @override
  Future<List<WalletAccountHistoryDto>> fetchAccountHistory({
    int accountType = 0,
  }) {
    return _apiClient.fetchAccountHistory(accountType: accountType);
  }

  @override
  Future<WalletBankAccountInfoDto?> fetchBankAccountInfo() {
    return _apiClient.fetchBankAccountInfo();
  }

  @override
  Future<List<WalletBankAccountPoolDto>> fetchBankAccountList() {
    return _apiClient.fetchBankAccountList();
  }

  @override
  Future<void> applyBankAccount() {
    return _apiClient.applyBankAccount();
  }

  @override
  Future<void> addBankAccount(WalletBankAccountAddRequestDto request) {
    return _apiClient.addBankAccount(request);
  }

  @override
  Future<void> deleteBankAccount({required Object id}) {
    return _apiClient.deleteBankAccount(id: id);
  }

  @override
  Future<void> sendWithdrawApplyCode() {
    return _apiClient.sendWithdrawApplyCode();
  }

  @override
  Future<void> confirmPayment({required Object amount, Object? bizId}) {
    return _apiClient.confirmPayment(amount: amount, bizId: bizId);
  }

  @override
  Future<List<WalletPaymentConfirmationRecordDto>> fetchPaymentConfirmations({
    required String bizId,
    int startPage = 1,
    int limit = 10,
  }) {
    return _apiClient.fetchPaymentConfirmations(
      bizId: bizId,
      startPage: startPage,
      limit: limit,
    );
  }

  @override
  Future<bool> autoFundDeduction({required String processId}) {
    return _apiClient.autoFundDeduction(processId: processId);
  }

  @override
  Future<void> applyWithdraw(WalletWithdrawApplyRequestDto request) {
    return _apiClient.applyWithdraw(request);
  }

  @override
  Future<void> cancelWithdraw(WalletWithdrawCancelRequestDto request) {
    return _apiClient.cancelWithdraw(request);
  }

  @override
  Future<num> fetchWithdrawCost({required Object bankId}) {
    return _apiClient.fetchWithdrawCost(bankId: bankId);
  }

  @override
  Future<List<WalletWithdrawRecordDto>> fetchWithdrawHistory() {
    return _apiClient.fetchWithdrawHistory();
  }

  @override
  Future<List<WalletWithdrawRecordDto>> fetchWithdrawingList() {
    return _apiClient.fetchWithdrawingList();
  }
}
