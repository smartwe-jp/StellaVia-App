import 'app_observability_providers.dart';
import '../../l10n/app_localizations.dart';

extension AppUiMessageLocalizer on AppUiMessageKey {
  String resolve(AppLocalizations l10n) {
    return switch (this) {
      AppUiMessageKey.requestFailed => l10n.uiErrorRequestFailed,
      AppUiMessageKey.networkUnavailable => l10n.uiErrorNetworkUnavailable,
      AppUiMessageKey.networkAccessDenied => l10n.uiErrorNetworkAccessDenied,
      AppUiMessageKey.authExpired => l10n.uiErrorAuthExpired,
      AppUiMessageKey.forbidden => l10n.uiErrorForbidden,
      AppUiMessageKey.serverUnavailable => l10n.uiErrorServerUnavailable,
    };
  }
}
