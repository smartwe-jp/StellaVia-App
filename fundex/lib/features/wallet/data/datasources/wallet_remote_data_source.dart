import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../models/wallet_account_history_dto.dart';
import '../models/wallet_bank_account_info_dto.dart';

abstract class WalletRemoteDataSource {
  Future<List<WalletAccountHistoryDto>> fetchAccountHistory({
    int accountType = 0,
  });

  Future<WalletBankAccountInfoDto?> fetchBankAccountInfo();

  Future<void> applyBankAccount();
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
  Future<void> applyBankAccount() {
    return _apiClient.applyBankAccount();
  }
}
