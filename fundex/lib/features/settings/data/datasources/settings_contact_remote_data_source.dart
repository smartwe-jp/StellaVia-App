import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

class SettingsContactSubmission {
  const SettingsContactSubmission({
    required this.familyName,
    required this.givenName,
    required this.furiganaFamilyName,
    required this.furiganaGivenName,
    required this.email,
    required this.questionCategory,
    required this.question,
  });

  final String familyName;
  final String givenName;
  final String furiganaFamilyName;
  final String furiganaGivenName;
  final String email;
  final String questionCategory;
  final String question;
}

abstract class SettingsContactRemoteDataSource {
  Future<void> submitContact(SettingsContactSubmission submission);
}

class SettingsContactRemoteDataSourceImpl
    implements SettingsContactRemoteDataSource {
  SettingsContactRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
    ContactApiClient? apiClient,
  }) : _apiClient =
           apiClient ??
           ContactApiClient(
             dioForPath:
                 (clusterRouter ??
                         ApiClusterRouter.fromClients(
                           oaClient: oaClient,
                           memberClient: memberClient,
                         ))
                     .dioForPath,
             envelopeCodec: envelopeCodec,
           );

  final ContactApiClient _apiClient;

  @override
  Future<void> submitContact(SettingsContactSubmission submission) {
    return _apiClient.submitContactWe(
      ContactWeRequestDto(
        familyName: submission.familyName,
        name: submission.givenName,
        furiganaFamilyName: submission.furiganaFamilyName,
        furiganaName: submission.furiganaGivenName,
        email: submission.email,
        questionCategory: submission.questionCategory,
        question: submission.question,
      ),
    );
  }
}
