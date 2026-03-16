import '../../../../l10n/app_localizations.dart';

String resolveIdentityAuthMessage(
  AppLocalizations l10n, {
  String? reasonCode,
  String? errorMessage,
  String? fallbackMessage,
}) {
  final normalizedReason = reasonCode?.trim() ?? '';
  final normalizedError = errorMessage?.trim() ?? '';

  switch (normalizedReason) {
    case 'security_center_already_verified':
      return l10n.identityAuthAlreadyVerified;
    case 'biometric_authenticator_not_configured':
      return l10n.identityAuthBiometricNotConfigured;
    case 'liveness_collector_not_configured':
      return l10n.identityAuthLivenessNotConfigured;
    case 'real_person_identify_failed':
      return l10n.identityAuthVerifyFailed;
    case 'real_person_identify_error':
      return normalizedError.isEmpty
          ? l10n.identityAuthVerifyFailed
          : normalizedError;
    case 'liveness_collect_failed':
      return _resolveLivenessErrorMessage(l10n, normalizedError);
    case 'empty_liveness_photo':
      return l10n.identityAuthCollectFailed;
    case 'device_biometric_failed_blocked':
      return l10n.identityAuthSensitiveBlocked;
    default:
      if (normalizedError.isNotEmpty) {
        return _resolveLivenessErrorMessage(l10n, normalizedError);
      }
      return fallbackMessage ?? l10n.uiErrorRequestFailed;
  }
}

String _resolveLivenessErrorMessage(AppLocalizations l10n, String message) {
  final normalized = message.trim();
  if (normalized.isEmpty) {
    return l10n.identityAuthCollectFailed;
  }

  final normalizedLower = normalized.toLowerCase();
  if (normalizedLower.contains('license') ||
      normalizedLower.contains('licence')) {
    return l10n.identityAuthBaiduLicenseMissing;
  }

  switch (normalized) {
    case 'baidu_face_license_missing':
      return l10n.identityAuthBaiduLicenseMissing;
    case 'baidu_face_collect_empty':
      return l10n.identityAuthCollectFailed;
    default:
      return normalized;
  }
}
