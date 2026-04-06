import 'package:core_tool_kit/core_tool_kit.dart';

class AppPushNotificationEvent {
  const AppPushNotificationEvent({required this.kind, required this.payload});

  final String kind;
  final Map<String, Object?> payload;
}

abstract interface class AppPushRuntime {
  String get providerName;
  String? get latestToken;
  Stream<String> get tokenStream;
  Stream<AppPushNotificationEvent> get notificationEvents;

  Future<void> initialize({required AppLogger logger});
}

class NoopPushRuntime implements AppPushRuntime {
  const NoopPushRuntime();

  @override
  String get providerName => 'noop';

  @override
  String? get latestToken => null;

  @override
  Stream<String> get tokenStream => const Stream<String>.empty();

  @override
  Stream<AppPushNotificationEvent> get notificationEvents =>
      const Stream<AppPushNotificationEvent>.empty();

  @override
  Future<void> initialize({required AppLogger logger}) async {}
}
