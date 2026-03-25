import 'package:core_identity_auth/core_identity_auth.dart';
import 'package:test/test.dart';

void main() {
  group('RealPersonIdentifyRequest.toJson', () {
    test('includes photo only when groupId is empty', () {
      const request = RealPersonIdentifyRequest(
        photoBase64: 'photo-base64',
        groupId: '  ',
      );

      expect(request.toJson(), <String, dynamic>{
        'photo': 'photo-base64',
        'app': 'STELLAVIA',
      });
    });

    test('includes groupId when provided', () {
      const request = RealPersonIdentifyRequest(
        photoBase64: 'photo-base64',
        groupId: 'group-a',
      );

      expect(request.toJson(), <String, dynamic>{
        'photo': 'photo-base64',
        'app': 'STELLAVIA',
        'groupId': 'group-a',
      });
    });
  });

  group('RealPersonIdentifyResponse.isVerified', () {
    test('is true when userId is positive', () {
      const response = RealPersonIdentifyResponse(
        userId: 1,
        rawData: <String, dynamic>{},
      );

      expect(response.isVerified, isTrue);
    });

    test('is false when userId is null or non-positive', () {
      const nullResponse = RealPersonIdentifyResponse(
        userId: null,
        rawData: <String, dynamic>{},
      );
      const zeroResponse = RealPersonIdentifyResponse(
        userId: 0,
        rawData: <String, dynamic>{},
      );

      expect(nullResponse.isVerified, isFalse);
      expect(zeroResponse.isVerified, isFalse);
    });
  });
}
