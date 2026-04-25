import 'dart:async';

import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../storage/app_storage_providers.dart';
import 'app_push_action.dart';
import 'app_push_runtime.dart';
import 'app_push_runtime_provider.dart';

class AppPushDialogState {
  const AppPushDialogState({
    this.activeBlockingCommand,
    this.activeDialogCommand,
    this.queue = const <AppPushCommand>[],
    this.recentTokens = const <String>[],
  });

  final AppPushCommand? activeBlockingCommand;
  final AppPushCommand? activeDialogCommand;
  final List<AppPushCommand> queue;
  final List<String> recentTokens;

  AppPushDialogState copyWith({
    Object? activeBlockingCommand = _sentinel,
    Object? activeDialogCommand = _sentinel,
    List<AppPushCommand>? queue,
    List<String>? recentTokens,
  }) {
    return AppPushDialogState(
      activeBlockingCommand: activeBlockingCommand == _sentinel
          ? this.activeBlockingCommand
          : activeBlockingCommand as AppPushCommand?,
      activeDialogCommand: activeDialogCommand == _sentinel
          ? this.activeDialogCommand
          : activeDialogCommand as AppPushCommand?,
      queue: queue ?? this.queue,
      recentTokens: recentTokens ?? this.recentTokens,
    );
  }
}

const Object _sentinel = Object();

class AppPushDialogController extends StateNotifier<AppPushDialogState> {
  AppPushDialogController({
    required KeyValueStorage storage,
    Future<PackageInfo> Function()? packageInfoResolver,
  }) : _storage = storage,
       _packageInfoResolver = packageInfoResolver ?? PackageInfo.fromPlatform,
       super(const AppPushDialogState());

  final KeyValueStorage _storage;
  final Future<PackageInfo> Function() _packageInfoResolver;

  Future<void> queueFromPush(AppPushNotificationEvent event) async {
    final command = parseAppPushCommand(event);
    if (command == null || command.action == AppPushAction.homeCelebration) {
      return;
    }
    if (_hasCommandToken(command.token) || await _shouldSkip(command)) {
      return;
    }

    if (command.action == AppPushAction.appBlock) {
      state = state.copyWith(
        activeBlockingCommand: command,
        recentTokens: _rememberToken(command.token),
      );
      return;
    }

    final nextQueue = _sortQueue(<AppPushCommand>[...state.queue, command]);
    if (state.activeDialogCommand == null) {
      final next = nextQueue.removeAt(0);
      state = state.copyWith(
        activeDialogCommand: next,
        queue: List<AppPushCommand>.unmodifiable(nextQueue),
        recentTokens: _rememberToken(command.token),
      );
      return;
    }

    state = state.copyWith(
      queue: List<AppPushCommand>.unmodifiable(nextQueue),
      recentTokens: _rememberToken(command.token),
    );
  }

  Future<void> dismissDialog(AppPushCommand command) async {
    if (state.activeDialogCommand?.token != command.token) {
      return;
    }
    await _markSeenIfNeeded(command);
    _promoteNextDialog();
  }

  Future<void> markSeen(AppPushCommand command) {
    return _markSeenIfNeeded(command);
  }

  bool _hasCommandToken(String token) {
    return state.activeBlockingCommand?.token == token ||
        state.activeDialogCommand?.token == token ||
        state.queue.any((command) => command.token == token) ||
        state.recentTokens.contains(token);
  }

  Future<bool> _shouldSkip(AppPushCommand command) async {
    if (command.isExpired || !await _matchesBuildRange(command)) {
      return true;
    }
    if (!command.showOnce) {
      return false;
    }
    final seen = await _storage.read(_seenKey(command.token));
    return seen != null && seen.trim().isNotEmpty;
  }

  Future<bool> _matchesBuildRange(AppPushCommand command) async {
    if (command.minBuild == null && command.maxBuild == null) {
      return true;
    }
    final info = await _packageInfoResolver();
    final currentBuild = int.tryParse(info.buildNumber.trim());
    if (currentBuild == null) {
      return true;
    }
    final minBuild = command.minBuild;
    if (minBuild != null && currentBuild < minBuild) {
      return false;
    }
    final maxBuild = command.maxBuild;
    if (maxBuild != null && currentBuild > maxBuild) {
      return false;
    }
    return true;
  }

  Future<void> _markSeenIfNeeded(AppPushCommand command) async {
    if (!command.showOnce) {
      return;
    }
    await _storage.write(
      _seenKey(command.token),
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  void _promoteNextDialog() {
    if (state.queue.isEmpty) {
      state = state.copyWith(activeDialogCommand: null);
      return;
    }
    final nextQueue = <AppPushCommand>[...state.queue];
    final next = nextQueue.removeAt(0);
    state = state.copyWith(
      activeDialogCommand: next,
      queue: List<AppPushCommand>.unmodifiable(nextQueue),
    );
  }

  List<String> _rememberToken(String token) {
    final next = <String>[...state.recentTokens, token];
    if (next.length > 30) {
      next.removeRange(0, next.length - 30);
    }
    return List<String>.unmodifiable(next);
  }

  List<AppPushCommand> _sortQueue(List<AppPushCommand> commands) {
    commands.sort((a, b) => _priority(a.action).compareTo(_priority(b.action)));
    return commands;
  }

  int _priority(AppPushAction action) {
    return switch (action) {
      AppPushAction.appBlock => 0,
      AppPushAction.appUpdate => 10,
      AppPushAction.campaignDialog => 20,
      AppPushAction.homeCelebration => 30,
    };
  }

  String _seenKey(String token) {
    return 'push_action_seen_$token';
  }
}

final appPushDialogControllerProvider =
    StateNotifierProvider<AppPushDialogController, AppPushDialogState>((ref) {
      return AppPushDialogController(
        storage: ref.watch(sharedPrefsStorageProvider),
      );
    });

final appPushDialogBootstrapProvider = Provider<void>((ref) {
  final controller = ref.watch(appPushDialogControllerProvider.notifier);
  final pushRuntime = ref.watch(appPushRuntimeProvider);
  final subscription = pushRuntime.notificationEvents.listen((event) {
    unawaited(controller.queueFromPush(event));
  });
  ref.onDispose(subscription.cancel);
});
