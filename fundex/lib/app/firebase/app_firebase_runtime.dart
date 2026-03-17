import 'dart:async';

import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fundex/firebase_options.dart';

class AppFirebaseRuntime {
  AppFirebaseRuntime._();

  static bool _initialized = false;
  static String? _latestFcmToken;
  static final StreamController<String> _tokenController =
      StreamController<String>.broadcast();
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static StreamSubscription<RemoteMessage>? _onMessageSubscription;
  static StreamSubscription<RemoteMessage>? _onMessageOpenedSubscription;

  static String? get latestFcmToken => _latestFcmToken;
  static Stream<String> get tokenStream => _tokenController.stream;

  static Future<void> initialize({required AppLogger logger}) async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _configureCrashlytics(logger: logger);
    await _configurePush(logger: logger);
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
      },
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _resolveAndLogCurrentToken(logger: logger, messaging: messaging);

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = messaging.onTokenRefresh.listen(
      (String token) {
        _latestFcmToken = token;
        _tokenController.add(token);
        logger.info(
          'FCM token refreshed',
          context: <String, Object?>{'token': token},
        );
      },
      onError: (Object error, StackTrace stackTrace) {
        logger.error(
          'Failed while listening token refresh',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );

    await _onMessageSubscription?.cancel();
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      logger.info(
        'Push message received in foreground',
        context: _messageContext(message),
      );
    });

    await _onMessageOpenedSubscription?.cancel();
    _onMessageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      logger.info('Push message opened app', context: _messageContext(message));
    });
  }

  static Future<void> _resolveAndLogCurrentToken({
    required AppLogger logger,
    required FirebaseMessaging messaging,
  }) async {
    try {
      final token = await messaging.getToken();
      _latestFcmToken = token;
      if (token == null || token.isEmpty) {
        logger.warning('FCM token is unavailable yet');
        return;
      }
      _tokenController.add(token);
      logger.info(
        'FCM token resolved',
        context: <String, Object?>{'token': token},
      );
    } catch (error, stackTrace) {
      logger.error(
        'Failed to resolve FCM token',
        error: error,
        stackTrace: stackTrace,
      );
    }
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
