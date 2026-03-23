import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class SettingsContractDocumentsRemoteDataSource {
  Future<List<UserInvestmentContractProjectPdfDto>> fetchContractProjects({
    int startPage = 1,
    int limit = 300,
  });
}

class SettingsContractDocumentsRemoteDataSourceImpl
    implements SettingsContractDocumentsRemoteDataSource {
  SettingsContractDocumentsRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
    UserInvestmentApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           UserInvestmentApiClient(
             dioForPath:
                 (clusterRouter ??
                         ApiClusterRouter.fromClients(
                           oaClient: oaClient,
                           memberClient: memberClient,
                         ))
                     .dioForPath,
             envelopeCodec: envelopeCodec,
           );

  final UserInvestmentApiClient _apiClient;

  @override
  Future<List<UserInvestmentContractProjectPdfDto>> fetchContractProjects({
    int startPage = 1,
    int limit = 300,
  }) {
    return _apiClient.fetchInvestPdfList(startPage: startPage, limit: limit);
  }
}
