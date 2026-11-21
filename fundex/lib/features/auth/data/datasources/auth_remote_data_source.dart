import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendLoginCode({required String account, String? intlCode});
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  });
  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  });
  Future<AuthLoginResultDto> loginWithRegistrationUuid(String uuid);
  Future<AuthUserDto?> fetchCurrentUser();
  Future<String?> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
    String? inviteCode,
  });
  Future<AuthSessionDto?> refreshSession({required String refreshToken});
  Future<void> logout({required String accessToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
    AuthApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           AuthApiClient(
             dioForPath:
                 (clusterRouter ??
                         ApiClusterRouter.fromClients(
                           oaClient: oaClient,
                           memberClient: memberClient,
                         ))
                     .dioForPath,
             envelopeCodec: envelopeCodec,
           );

  final AuthApiClient _apiClient;

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    return _apiClient.sendLoginCode(account: account, intlCode: intlCode);
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {
    return _apiClient.sendRegisterCode(account: account, intlCode: intlCode);
  }

  @override
  Future<AuthLoginResultDto> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    return _apiClient.loginWithCode(
      account: account,
      code: code,
      intlCode: intlCode,
    );
  }

  @override
  Future<AuthLoginResultDto> loginWithRegistrationUuid(String uuid) =>
      _apiClient.loginWithRegistrationUuid(uuid);

  @override
  Future<AuthUserDto?> fetchCurrentUser() async {
    return _apiClient.fetchCurrentUser();
  }

  @override
  Future<String?> registerApply({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
    String? inviteCode,
  }) async {
    return _apiClient.registerApply(
      account: account,
      code: code,
      intlCode: intlCode,
      contact: contact,
      inviteCode: inviteCode,
    );
  }

  @override
  Future<AuthSessionDto?> refreshSession({required String refreshToken}) async {
    return _apiClient.refreshSession(refreshToken: refreshToken);
  }

  @override
  Future<void> logout({required String accessToken}) async {
    return _apiClient.logout(accessToken: accessToken);
  }
}
