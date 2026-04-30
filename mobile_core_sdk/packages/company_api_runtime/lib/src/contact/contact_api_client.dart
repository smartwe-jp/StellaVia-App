import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'contact_dtos.dart';

typedef ContactDioForPath = Dio Function(String path);

class ContactApiPaths {
  const ContactApiPaths._();

  static const String contactWe = '/crowdfunding/offline/contact/we';
}

class ContactApiClient {
  ContactApiClient({
    required ContactDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.contactWePath = ContactApiPaths.contactWe,
  }) : _dioForPath = dioForPath,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec();

  final ContactDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String contactWePath;

  Future<void> submitContactWe(ContactWeRequestDto request) async {
    final response = await _dioForPath(contactWePath)
        .post<Map<String, dynamic>>(
          contactWePath,
          data: request.toJson(),
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to submit contact inquiry.',
      requireTruthyData: true,
    );
  }
}
