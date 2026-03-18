import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppPushTokenSyncLogger extends PushTokenSyncLogger {
  AppPushTokenSyncLogger(this._logger, {String? providerName})
    : _providerName = providerName?.trim();

  final AppLogger _logger;
  final String? _providerName;

  Map<String, Object?> _withProvider(Map<String, Object?> context) {
    final providerName = _providerName;
    if (providerName == null || providerName.isEmpty) {
      return context;
    }
    return <String, Object?>{'provider': providerName, ...context};
  }

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    _logger.info(message, context: _withProvider(context));
  }

  @override
  void warning(String message, {Map<String, Object?> context = const {}}) {
    _logger.warning(message, context: _withProvider(context));
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _logger.error(
      message,
      error: error,
      stackTrace: stackTrace,
      context: _withProvider(context),
    );
  }
}

Future<String> resolvePushSyncAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  final version = info.version.trim();
  if (version.isNotEmpty) {
    return version;
  }
  return '0.0.0';
}

int resolvePushSyncDeviceType() {
  if (kIsWeb) {
    return 0;
  }
  return defaultTargetPlatform == TargetPlatform.iOS ? 1 : 0;
}
