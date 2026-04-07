import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/push/app_push_runtime.dart';
import '../../../../app/push/app_push_runtime_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class HomeCelebrationEvent {
  const HomeCelebrationEvent({
    required this.token,
    required this.source,
    this.lottieUrl,
  });

  final String token;
  final String source;
  final String? lottieUrl;
}

class HomeCelebrationState {
  const HomeCelebrationState({
    this.pendingEvent,
    this.recentTokens = const <String>[],
  });

  final HomeCelebrationEvent? pendingEvent;
  final List<String> recentTokens;

  HomeCelebrationState copyWith({
    Object? pendingEvent = _sentinel,
    List<String>? recentTokens,
  }) {
    return HomeCelebrationState(
      pendingEvent: pendingEvent == _sentinel
          ? this.pendingEvent
          : pendingEvent as HomeCelebrationEvent?,
      recentTokens: recentTokens ?? this.recentTokens,
    );
  }
}

const Object _sentinel = Object();

class HomeCelebrationController extends StateNotifier<HomeCelebrationState> {
  HomeCelebrationController() : super(const HomeCelebrationState());

  void queueFromPush(AppPushNotificationEvent event) {
    if (!_isHomeCelebrationEvent(event.payload)) {
      return;
    }
    _queueEvent(
      HomeCelebrationEvent(
        token: _resolvePushToken(event),
        source: event.kind,
        lottieUrl: _readCelebrationUrl(event.payload),
      ),
    );
  }

  void consumePending(String token) {
    if (state.pendingEvent?.token != token) {
      return;
    }
    state = state.copyWith(pendingEvent: null);
  }

  void clearPending() {
    if (state.pendingEvent == null) {
      return;
    }
    state = state.copyWith(pendingEvent: null);
  }

  void _queueEvent(HomeCelebrationEvent event) {
    if (state.pendingEvent?.token == event.token ||
        state.recentTokens.contains(event.token)) {
      return;
    }
    final nextRecentTokens = <String>[...state.recentTokens, event.token];
    if (nextRecentTokens.length > 20) {
      nextRecentTokens.removeRange(0, nextRecentTokens.length - 20);
    }
    state = state.copyWith(
      pendingEvent: event,
      recentTokens: List<String>.unmodifiable(nextRecentTokens),
    );
  }

  bool _isHomeCelebrationEvent(Map<String, Object?> payload) {
    final targetPage =
        _readString(payload, 'TARGET_PAGE') ??
        _readString(_readMap(payload, 'exts'), 'TARGET_PAGE');
    return targetPage == 'homeCelebration';
  }

  String _resolvePushToken(AppPushNotificationEvent event) {
    final payload = event.payload;
    final extraMap = _readMap(payload, 'extraMap');
    final messageId =
        _readString(extraMap, '_ALIYUN_NOTIFICATION_MSG_ID_') ??
        _readString(payload, '_ALIYUN_NOTIFICATION_MSG_ID_') ??
        _readString(payload, 'msg_id');
    if (messageId != null && messageId.isNotEmpty) {
      return 'push-$messageId';
    }
    return 'push-${event.kind}-${payload.toString()}';
  }

  String? _readCelebrationUrl(Map<String, Object?> payload) {
    return _readString(payload, 'LOTTIE_URL') ??
        _readString(_readMap(payload, 'exts'), 'LOTTIE_URL');
  }

  Map<String, Object?> _readMap(Map<String, Object?> payload, String key) {
    final value = payload[key];
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (dynamic mapKey, dynamic mapValue) =>
            MapEntry('$mapKey', mapValue as Object?),
      );
    }
    return const <String, Object?>{};
  }

  String? _readString(Map<String, Object?> payload, String key) {
    final value = payload[key];
    if (value == null) {
      return null;
    }
    final normalized = '$value'.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}

final homeCelebrationControllerProvider =
    StateNotifierProvider<HomeCelebrationController, HomeCelebrationState>((
      ref,
    ) {
      return HomeCelebrationController();
    });

final homeCelebrationBootstrapProvider = Provider<void>((ref) {
  final controller = ref.watch(homeCelebrationControllerProvider.notifier);
  final pushRuntime = ref.watch(appPushRuntimeProvider);

  final pushSubscription = pushRuntime.notificationEvents.listen(
    controller.queueFromPush,
  );
  ref.onDispose(pushSubscription.cancel);

  ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
    final wasAuthenticated = previous?.asData?.value ?? false;
    final isAuthenticated = next.asData?.value ?? false;
    if (wasAuthenticated == isAuthenticated) {
      return;
    }
    if (!isAuthenticated) {
      controller.clearPending();
    }
  });
});
