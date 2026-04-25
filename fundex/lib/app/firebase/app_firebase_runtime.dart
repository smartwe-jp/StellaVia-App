import 'dart:async';

import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fundex/firebase_options.dart';

import '../push/app_push_runtime.dart';

class AppFirebaseRuntime {
  AppFirebaseRuntime._();

  static const int _tokenResolveAttempts = 2;
  static const Duration _tokenResolveRetryDelay = Duration(seconds: 2);
  static const int _apnsTokenPollAttempts = 12;
  static const Duration _apnsTokenPollDelay = Duration(milliseconds: 500);

  static bool _crashlyticsConfigured = false;
  static bool _pushConfigured = false;
  static String? _latestFcmToken;
  static final StreamController<String> _tokenController =
      StreamController<String>.broadcast();
  static final StreamController<AppPushNotificationEvent>
  _notificationController =
      StreamController<AppPushNotificationEvent>.broadcast();
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static StreamSubscription<RemoteMessage>? _onMessageSubscription;
  static StreamSubscription<RemoteMessage>? _onMessageOpenedSubscription;

  static String? get latestFcmToken => _latestFcmToken;
  static Stream<String> get tokenStream => _tokenController.stream;
  static Stream<AppPushNotificationEvent> get notificationEvents =>
      _notificationController.stream;

  static Future<void> initialize({
    required AppLogger logger,
    bool enablePush = true,
  }) async {
    await _ensureCrashlyticsConfigured(logger: logger);
    if (enablePush) {
      await ensurePushConfigured(logger: logger);
    }
  }

  static Future<void> ensurePushConfigured({required AppLogger logger}) async {
    if (_pushConfigured) {
      return;
    }
    await _configurePush(logger: logger);
    _pushConfigured = true;
  }

  static Future<void> _ensureCrashlyticsConfigured({
    required AppLogger logger,
  }) async {
    if (_crashlyticsConfigured) {
      return;
    }
    await _configureCrashlytics(logger: logger);
    _crashlyticsConfigured = true;
  }

  static Future<void> _configureCrashlytics({required AppLogger logger}) async {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = (FlutterErrorDetails details) {
      logger.error(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
      );
      crashlytics.recordFlutterFatalError(details);
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError =
        (Object error, StackTrace stackTrace) {
          logger.error(
            'Unhandled platform error',
            error: error,
            stackTrace: stackTrace,
          );
          crashlytics.recordError(error, stackTrace, fatal: true);
          return true;
        };
  }

  static Future<void> _configurePush({required AppLogger logger}) async {
    final messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(
      appFirebaseMessagingBackgroundHandler,
    );

    final permission = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    logger.info(
      'Push permission requested',
      context: <String, Object?>{
        'authorizationStatus': permission.authorizationStatus.name,
        'soundSetting': permission.sound.name,
        'alertSetting': permission.alert.name,
        'badgeSetting': permission.badge.name,
      },
    );
    if (permission.sound != AppleNotificationSetting.enabled) {
      logger.warning(
        'Push sound is not enabled at OS notification settings.',
        context: <String, Object?>{'soundSetting': permission.sound.name},
      );
    }

    final canResolveToken =
        permission.authorizationStatus == AuthorizationStatus.authorized ||
        permission.authorizationStatus == AuthorizationStatus.provisional;

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = messaging.onTokenRefresh.listen(
      (String token) {
        _latestFcmToken = token;
        _tokenController.add(token);
        logger.info('FCM token refreshed', context: _tokenLogContext(token));
      },
      onError: (Object error, StackTrace stackTrace) {
        logger.error(
          'Failed while listening token refresh',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    if (canResolveToken) {
      // Do not block startup while waiting APNs token propagation.
      unawaited(
        _resolveAndLogCurrentToken(logger: logger, messaging: messaging),
      );
    } else {
      logger.warning(
        'Skipping FCM token resolve because push permission is not granted.',
        context: <String, Object?>{
          'authorizationStatus': permission.authorizationStatus.name,
        },
      );
    }

    await _onMessageSubscription?.cancel();
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      logger.info(
        'Push message received in foreground',
        context: _messageContext(message),
      );
      _emitRemoteMessageEvent(kind: 'foreground', message: message);
    });

    await _onMessageOpenedSubscription?.cancel();
    _onMessageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      logger.info('Push message opened app', context: _messageContext(message));
      _emitRemoteMessageEvent(kind: 'opened', message: message);
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      logger.info(
        'Push message opened app from terminated state',
        context: _messageContext(initialMessage),
      );
      _emitRemoteMessageEvent(kind: 'initial', message: initialMessage);
    }
  }

  static Future<void> _resolveAndLogCurrentToken({
    required AppLogger logger,
    required FirebaseMessaging messaging,
  }) async {
    for (int attempt = 1; attempt <= _tokenResolveAttempts; attempt++) {
      try {
        if (_isApplePlatform) {
          final apnsReady = await _waitForApnsToken(
            logger: logger,
            messaging: messaging,
          );
          if (!apnsReady) {
            if (attempt == _tokenResolveAttempts) {
              logger.warning(
                'APNs token is not ready yet; skip current FCM token resolve attempt.',
                context: <String, Object?>{'attempt': attempt},
              );
              return;
            }
            await Future<void>.delayed(_tokenResolveRetryDelay);
            continue;
          }
        }

        final token = await messaging.getToken();
        _latestFcmToken = token;
        if (token == null || token.isEmpty) {
          if (attempt == _tokenResolveAttempts) {
            logger.warning('FCM token is unavailable yet.');
            return;
          }
          await Future<void>.delayed(_tokenResolveRetryDelay);
          continue;
        }
        _tokenController.add(token);
        logger.info('FCM token resolved', context: _tokenLogContext(token));
        return;
      } catch (error, stackTrace) {
        if (_isApnsTokenNotReadyError(error)) {
          if (attempt == _tokenResolveAttempts) {
            logger.warning(
              'FCM token is waiting for APNs token; will rely on onTokenRefresh.',
            );
            return;
          }
          await Future<void>.delayed(_tokenResolveRetryDelay);
          continue;
        }
        logger.error(
          'Failed to resolve FCM token',
          error: error,
          stackTrace: stackTrace,
        );
        return;
      }
    }
  }

  static bool get _isApplePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static bool _isApnsTokenNotReadyError(Object error) {
    if (error is FirebaseException) {
      return error.plugin == 'firebase_messaging' &&
          error.code == 'apns-token-not-set';
    }
    return error.toString().contains('apns-token-not-set');
  }

  static Future<bool> _waitForApnsToken({
    required AppLogger logger,
    required FirebaseMessaging messaging,
  }) async {
    for (int i = 0; i < _apnsTokenPollAttempts; i++) {
      try {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.trim().isNotEmpty) {
          logger.info(
            'APNs token resolved',
            context: _tokenLogContext(apnsToken),
          );
          return true;
        }
      } catch (_) {
        // APNs token not ready is expected at early startup.
      }
      await Future<void>.delayed(_apnsTokenPollDelay);
    }
    return false;
  }

  static Map<String, Object?> _messageContext(RemoteMessage message) {
    return <String, Object?>{
      'messageId': message.messageId,
      'from': message.from,
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data.toString(),
    };
  }

  static void _emitRemoteMessageEvent({
    required String kind,
    required RemoteMessage message,
  }) {
    _notificationController.add(
      AppPushNotificationEvent(
        kind: kind,
        payload: _remoteMessagePayload(message),
      ),
    );
  }

  static Map<String, Object?> _remoteMessagePayload(RemoteMessage message) {
    final payload = <String, Object?>{...message.data};
    payload.putIfAbsent('MESSAGE_ID', () => message.messageId);
    payload.putIfAbsent('FROM', () => message.from);
    payload.putIfAbsent('TITLE', () => message.notification?.title);
    payload.putIfAbsent('BODY', () => message.notification?.body);
    return payload;
  }

  static Map<String, Object?> _tokenLogContext(String token) {
    if (kReleaseMode) {
      return const <String, Object?>{};
    }
    return <String, Object?>{'token': _maskToken(token)};
  }

  static String _maskToken(String token) {
    if (token.length <= 10) {
      return token;
    }
    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }
}

@pragma('vm:entry-point')
Future<void> appFirebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
