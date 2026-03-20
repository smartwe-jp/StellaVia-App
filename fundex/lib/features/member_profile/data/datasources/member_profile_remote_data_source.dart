import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import '../../domain/constants/member_profile_upload_markers.dart';

abstract class MemberProfileRemoteDataSource {
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({required String zip});
  Future<Map<String, dynamic>> fetchCurrentMemberProfilePayload();

  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  });

  Future<void> saveMemberInfo({required Map<String, dynamic> payload});
}

class MemberProfileRemoteDataSourceImpl
    implements MemberProfileRemoteDataSource {
  MemberProfileRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
    MemberProfileApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           MemberProfileApiClient(
             dioForPath:
                 (clusterRouter ??
                         ApiClusterRouter.fromClients(
                           oaClient: oaClient,
                           memberClient: memberClient,
                         ))
                     .dioForPath,
             envelopeCodec: envelopeCodec,
           ),
       _authApiClient = AuthApiClient(
         dioForPath:
             (clusterRouter ??
                     ApiClusterRouter.fromClients(
                       oaClient: oaClient,
                       memberClient: memberClient,
                     ))
                 .dioForPath,
         envelopeCodec: envelopeCodec,
       );

  final MemberProfileApiClient _apiClient;
  final AuthApiClient _authApiClient;

  @override
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    return _apiClient.fetchRegionsByZip(zip: zip);
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentMemberProfilePayload() async {
    return _authApiClient.fetchCurrentUserPayload();
  }

  @override
  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  }) async {
    if (isSelfie) {
      await _apiClient.uploadSelfiePhoto(filePath: filePath);
      return selfieUploadCompletedMarker;
    }

    return _apiClient.uploadDocumentPhoto(filePath: filePath);
  }

  @override
  Future<void> saveMemberInfo({required Map<String, dynamic> payload}) async {
    return _apiClient.saveMemberInfo(payload: payload);
  }
}
