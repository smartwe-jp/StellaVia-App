import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppPushTokenSyncLogger extends PushTokenSyncLogger {
  AppPushTokenSyncLogger(this._logger);

  final AppLogger _logger;

  @override
  void info(String message, {Map<String, Object?> context = const {}}) {
    _logger.info(message, context: context);
  }

  @override
  void warning(String message, {Map<String, Object?> context = const {}}) {
    _logger.warning(message, context: context);
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
      context: context,
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
