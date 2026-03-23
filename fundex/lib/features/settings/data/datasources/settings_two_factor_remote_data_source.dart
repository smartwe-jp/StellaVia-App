import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class SettingsTwoFactorRemoteDataSource {
  Future<AuthMemberLoginIndexDto?> fetchMemberLoginIndexStatus({
    required String deviceId,
    required int deviceType,
    required String version,
  });

  Future<void> sendOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
  });

  Future<void> verifyOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
    required String code,
  });
}

class SettingsTwoFactorRemoteDataSourceImpl
    implements SettingsTwoFactorRemoteDataSource {
  SettingsTwoFactorRemoteDataSourceImpl(
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
  Future<AuthMemberLoginIndexDto?> fetchMemberLoginIndexStatus({
    required String deviceId,
    required int deviceType,
    required String version,
  }) {
    return _apiClient.fetchMemberLoginIndexStatus(
      app: 'STELLAVIA',
      deviceId: deviceId,
      deviceType: deviceType,
      version: version,
    );
  }

  @override
  Future<void> sendOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
  }) {
    return _apiClient.sendOnlinePhoneChangeCode(mobile: mobile, bizId: bizId);
  }

  @override
  Future<void> verifyOnlinePhoneChangeCode({
    required String mobile,
    required String bizId,
    required String code,
  }) {
    return _apiClient.verifyOnlinePhoneChangeCode(
      mobile: mobile,
      bizId: bizId,
      code: code,
    );
  }
}
