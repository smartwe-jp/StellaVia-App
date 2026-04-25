import 'package:core_tool_kit/core_tool_kit.dart';

import '../firebase/app_firebase_runtime.dart';
import 'app_push_runtime.dart';

class FirebasePushRuntime implements AppPushRuntime {
  const FirebasePushRuntime();

  @override
  String get providerName => 'fcm';

  @override
  String? get latestToken => AppFirebaseRuntime.latestFcmToken;

  @override
  Stream<String> get tokenStream => AppFirebaseRuntime.tokenStream;

  @override
  Stream<AppPushNotificationEvent> get notificationEvents =>
      AppFirebaseRuntime.notificationEvents;

  @override
  Future<void> initialize({required AppLogger logger}) {
    return AppFirebaseRuntime.ensurePushConfigured(logger: logger);
  }
}
