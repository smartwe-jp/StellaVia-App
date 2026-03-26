import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';

import '../observability/app_observability_providers.dart';

class AppAuthFailureHandler implements AuthFailureHandler {
  AppAuthFailureHandler({
    required AppLogger logger,
    required Future<void> Function() onSignedOut,
    required void Function(AppUiMessageKey messageKey, {String? customMessage})
    reportErrorMessage,
  }) : _logger = logger,
       _onSignedOut = onSignedOut,
       _reportErrorMessage = reportErrorMessage;

  final AppLogger _logger;
  final Future<void> Function() _onSignedOut;
  final void Function(AppUiMessageKey messageKey, {String? customMessage})
  _reportErrorMessage;

  @override
  Future<void> onAuthFailure(AuthFailureReason reason) async {
    _logger.warning(
      'Authentication failure handled',
      context: <String, Object?>{'reason': reason.name},
    );
    _reportErrorMessage(AppUiMessageKey.authExpired);
    await _onSignedOut();
  }
}
