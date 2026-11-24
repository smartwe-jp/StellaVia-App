const String selfieUploadCompletedMarker = '__selfie_uploaded__';

const testSelfieUploadFallbackMarker = '__test_selfie_upload_fallback__';

bool isUploadedSelfie(String? path) {
  final value = path?.trim() ?? '';
  return value == selfieUploadCompletedMarker ||
      value.startsWith('https://') ||
      value.startsWith('http://');
}
