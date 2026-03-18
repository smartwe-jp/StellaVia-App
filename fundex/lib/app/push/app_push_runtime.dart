import 'package:core_tool_kit/core_tool_kit.dart';

abstract interface class AppPushRuntime {
  String get providerName;
  String? get latestToken;
  Stream<String> get tokenStream;

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
  Future<void> initialize({required AppLogger logger}) async {}
}
