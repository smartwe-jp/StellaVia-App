import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  throw UnimplementedError(
    'appLoggerProvider must be overridden from bootstrap.',
  );
});

enum AppUiMessageKey {
  requestFailed,
  networkUnavailable,
  networkAccessDenied,
  authExpired,
  forbidden,
  serverUnavailable,
}

class AppUiMessage {
  const AppUiMessage({required this.id, required this.key, this.customMessage});

  final int id;
  final AppUiMessageKey key;
  final String? customMessage;
}

class AppUiMessageController extends StateNotifier<AppUiMessage?> {
  AppUiMessageController() : super(null);

  void showError(AppUiMessageKey messageKey, {String? customMessage}) {
    final now = DateTime.now().microsecondsSinceEpoch;
    state = AppUiMessage(
      id: now,
      key: messageKey,
      customMessage: customMessage,
    );
  }

  void clearIfMatches(int messageId) {
    if (state?.id == messageId) {
      state = null;
    }
  }
}

final appUiMessageProvider =
    StateNotifierProvider<AppUiMessageController, AppUiMessage?>((ref) {
      return AppUiMessageController();
    });
