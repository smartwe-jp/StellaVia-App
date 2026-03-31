import 'dart:async';

import 'package:core_storage/core_storage.dart';
import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/firebase_options.dart';

import 'app.dart';
import 'config/app_environment.dart';
import 'config/app_flavor.dart';
import 'config/environment_provider.dart';
import 'firebase/app_firebase_runtime.dart';
import 'observability/app_observability_providers.dart';
import 'push/app_push_runtime_factory.dart';
import 'push/app_push_runtime_provider.dart';
import 'push/app_push_runtime.dart';
import 'push/app_push_settings.dart';

bool? _parseOptionalBool(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }
  if (normalized == 'true') {
    return true;
  }
  if (normalized == 'false') {
    return false;
  }
  return null;
}

const Duration _startupRuntimeInitTimeout = Duration(seconds: 8);

Future<void> _runStartupRuntimeInitializers({
  required AppLogger logger,
  required AppPushRuntime pushRuntime,
}) async {
  Future<void> runGuarded(String label, Future<void> Function() action) async {
    try {
      await action().timeout(_startupRuntimeInitTimeout);
    } on TimeoutException {
      logger.warning(
        '$label timed out during startup. Continue without blocking UI.',
        context: <String, Object?>{
          'timeoutMs': _startupRuntimeInitTimeout.inMilliseconds,
        },
      );
    } catch (error, stackTrace) {
      logger.error(
        '$label failed during startup.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  await runGuarded(
    'Firebase runtime initialization',
    () => AppFirebaseRuntime.initialize(logger: logger, enablePush: false),
  );
  await runGuarded(
    'Push runtime initialization',
    () => pushRuntime.initialize(logger: logger),
  );
}

Future<void> bootstrap({
  required AppFlavor flavor,
  String? memberApiBaseUrlOverride,
  String? hotelApiBaseUrlOverride,
  String? oaApiBaseUrlOverride,
  bool? enableHttpLogOverride,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreStorageBootstrap.initializeHive();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const enableHttpLogDefine = String.fromEnvironment('ENABLE_HTTP_LOG');
  final enableHttpLogFromDefine = _parseOptionalBool(enableHttpLogDefine);

  final environment = EnvironmentFactory.fromFlavor(
    flavor,
    memberApiBaseUrlOverride:
        memberApiBaseUrlOverride ??
        const String.fromEnvironment('API_BASE_URL'),
    hotelApiBaseUrlOverride:
        hotelApiBaseUrlOverride ??
        const String.fromEnvironment('HOTEL_API_BASE_URL'),
    oaApiBaseUrlOverride:
        oaApiBaseUrlOverride ?? const String.fromEnvironment('OA_API_BASE_URL'),
    enableHttpLogOverride: enableHttpLogOverride ?? enableHttpLogFromDefine,
  );
  final logger = await FileAppLogger.create(
    enableDebugLogs: environment.enableHttpLog,
    loggerName: 'StellaVia',
  );

  final pushSettings = AppPushSettings.fromDartDefine();
  final pushRuntime = createAppPushRuntime(settings: pushSettings);
  logger.info(
    'Push runtime selected.',
    context: <String, Object?>{'provider': pushSettings.provider.name},
  );

  runApp(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
        appLoggerProvider.overrideWithValue(logger),
        appPushRuntimeProvider.overrideWithValue(pushRuntime),
      ],
      child: const MemberTemplateApp(),
    ),
  );

  unawaited(
    _runStartupRuntimeInitializers(logger: logger, pushRuntime: pushRuntime),
  );
}
