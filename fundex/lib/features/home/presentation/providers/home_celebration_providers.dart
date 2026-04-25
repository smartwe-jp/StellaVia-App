import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/push/app_push_runtime.dart';
import '../../../../app/push/app_push_action.dart';
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
    final command = parseAppPushCommand(event);
    if (command?.action != AppPushAction.homeCelebration) {
      return;
    }
    _queueEvent(
      HomeCelebrationEvent(
        token: command!.token,
        source: event.kind,
        lottieUrl: command.lottieUrl,
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
