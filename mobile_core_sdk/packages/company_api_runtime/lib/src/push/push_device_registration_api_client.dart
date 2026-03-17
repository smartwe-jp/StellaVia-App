import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';

typedef PushDeviceRegistrationDioForPath = Dio Function(String path);

class PushDeviceRegistrationApiPaths {
  const PushDeviceRegistrationApiPaths._();

  static const String registerDevice = '/member/login/index';
}

class PushDeviceRegistrationApiClient {
  PushDeviceRegistrationApiClient({
    required PushDeviceRegistrationDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.registerDevicePath = PushDeviceRegistrationApiPaths.registerDevice,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'200', '0'}),
           );

  final PushDeviceRegistrationDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String registerDevicePath;

  Future<void> registerDevice({
    required String deviceId,
    required int deviceType,
    required String version,
  }) async {
    final normalizedDeviceId = deviceId.trim();
    final normalizedVersion = version.trim();
    if (normalizedDeviceId.isEmpty || normalizedVersion.isEmpty) {
      return;
    }

    final response = await _dioForPath(registerDevicePath)
        .post<Map<String, dynamic>>(
          registerDevicePath,
          data: <String, dynamic>{
            'deviceId': normalizedDeviceId,
            'deviceType': deviceType,
            'version': normalizedVersion,
          },
          options: authRequired(true),
        );

    final payload = _envelopeCodec.toJsonMap(response.data);
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Failed to register push device.',
    );
  }
}
