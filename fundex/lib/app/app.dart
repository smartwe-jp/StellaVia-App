import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

import 'config/environment_provider.dart';
import 'firebase/push_token_sync_providers.dart';
import 'localization/app_locale_providers.dart';
import 'observability/app_observability_providers.dart';
import 'observability/app_ui_message_localizer.dart';
import 'push/app_push_dialog_host.dart';
import 'push/app_push_dialog_providers.dart';
import 'realtime/app_lifecycle_refresh_scope.dart';
import 'realtime/app_realtime_refresh.dart';
import 'router/app_router.dart';
import 'status_bar/app_status_bar_providers.dart';
import 'network/app_network_providers.dart';
import 'network/app_network_connectivity_providers.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/investment/presentation/providers/fund_project_providers.dart';
import '../features/home/presentation/providers/home_celebration_providers.dart';
import '../features/home/presentation/widgets/home_celebration_dialog.dart';
import '../features/member_profile/presentation/providers/member_profile_providers.dart';
import '../features/settings/presentation/providers/settings_content_providers.dart';

final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<OverlayState> _appNoticeOverlayKey = GlobalKey<OverlayState>();
final _networkOfflineDialogShownProvider = StateProvider<bool>((ref) => false);
final _networkOfflineDialogOpenProvider = StateProvider<bool>((ref) => false);

bool _usesImmersiveHotelStatusBar(String path) {
  final normalized = path.length > 1 && path.endsWith('/')
      ? path.substring(0, path.length - 1)
      : path;
  if (normalized == '/hotel-booking') {
    return true;
  }
  const prefix = '/hotel-booking/';
  if (!normalized.startsWith(prefix)) {
    return false;
  }
  final tail = normalized.substring(prefix.length);
  if (tail.isEmpty || tail.contains('/')) {
    return false;
  }
  return !const <String>{'map', 'member-profile', 'orders'}.contains(tail);
}

class MemberTemplateApp extends ConsumerWidget {
  const MemberTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppNotice.bindHostOverlayKey(_appNoticeOverlayKey);
    ref.watch(pushTokenSyncBootstrapProvider);
    ref.watch(homeCelebrationBootstrapProvider);
    ref.watch(appPushDialogBootstrapProvider);

    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);
    final locale = ref.watch(appLocaleProvider);
    final effectiveLocale = ref.watch(appEffectiveLocaleProvider);
    final immersiveHotelStatusBarHint = ref.watch(
      appImmersiveHotelStatusBarHintProvider,
    );

    ref.listen<AppUiMessage?>(appUiMessageProvider, (previous, next) {
      if (next == null) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messengerContext = _rootScaffoldMessengerKey.currentContext;
        if (messengerContext != null) {
          final message = next.customMessage?.trim().isNotEmpty == true
              ? next.customMessage!.trim()
              : next.key.resolve(AppLocalizations.of(messengerContext));
          AppNotice.show(messengerContext, message: message);
        }
        ref.read(appUiMessageProvider.notifier).clearIfMatches(next.id);
      });
    });

    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final bool wasAuthenticated = previous?.asData?.value ?? false;
      final bool isAuthenticated = next.asData?.value ?? false;
      final bool authStatusChanged = wasAuthenticated != isAuthenticated;
      if (!authStatusChanged) {
        return;
      }
      ref.invalidate(currentAuthUserProvider);
      if (!isAuthenticated) {
        ref.invalidate(memberProfileDetailsProvider);
        ref.invalidate(isMemberProfileCompletedProvider);
        return;
      }
      invalidateAuthenticatedRealtimeProviders(ref);
      unawaited(() async {
        await ref.read(syncMemberProfileFromRemoteUseCaseProvider).call();
        ref.invalidate(memberProfileDetailsProvider);
        ref.invalidate(isMemberProfileCompletedProvider);
      }());
    });

    ref.listen<int>(appNetworkAuthFailureSignalProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      unawaited(ref.read(authSessionProvider.notifier).markUnauthenticated());
    });

    ref.listen<AsyncValue<AppNetworkAvailability>>(
      appNetworkAvailabilityProvider,
      (previous, next) {
        final previousAvailability = previous?.asData?.value;
        final nextAvailability = next.asData?.value;
        if (nextAvailability == AppNetworkAvailability.offline) {
          final alreadyShown = ref.read(_networkOfflineDialogShownProvider);
          if (previousAvailability != AppNetworkAvailability.offline &&
              !alreadyShown) {
            ref.read(_networkOfflineDialogShownProvider.notifier).state = true;
            _scheduleNetworkOfflineDialog(ref);
          }
          return;
        }
        if (previousAvailability != AppNetworkAvailability.offline ||
            nextAvailability != AppNetworkAvailability.online) {
          return;
        }
        ref.read(_networkOfflineDialogShownProvider.notifier).state = false;
        ref.invalidate(fundProjectListProvider);
        final isAuthenticated =
            ref.read(isAuthenticatedProvider).asData?.value ?? false;
        if (!isAuthenticated) {
          return;
        }
        invalidateAuthenticatedRealtimeProviders(ref);
      },
    );

    return MaterialApp.router(
      title: environment.appName,
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        final appChild = AppLifecycleRefreshScope(
          child: _GlobalKeyboardDismissLayer(
            child: child ?? const SizedBox.shrink(),
          ),
        );
        return _AppStatusBarFrame(
          router: router,
          immersiveHotelStatusBarHint: immersiveHotelStatusBarHint,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              appChild,
              const _GlobalCelebrationHost(),
              const AppPushDialogHost(),
              Overlay(
                key: _appNoticeOverlayKey,
                initialEntries: <OverlayEntry>[
                  OverlayEntry(
                    builder: (BuildContext context) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const _LocalizedSettingsContentBootstrap(),
            ],
          ),
        );
      },
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemeFactory.light(locale: effectiveLocale),
      darkTheme: AppThemeFactory.light(locale: effectiveLocale),
      themeMode: ThemeMode.light,
    );
  }
}

class _AppStatusBarFrame extends StatefulWidget {
  const _AppStatusBarFrame({
    required this.router,
    required this.immersiveHotelStatusBarHint,
    required this.child,
  });

  final GoRouter router;
  final bool? immersiveHotelStatusBarHint;
  final Widget child;

  @override
  State<_AppStatusBarFrame> createState() => _AppStatusBarFrameState();
}

class _AppStatusBarFrameState extends State<_AppStatusBarFrame> {
  @override
  void initState() {
    super.initState();
    widget.router.routeInformationProvider.addListener(_handleRouteChanged);
  }

  @override
  void didUpdateWidget(covariant _AppStatusBarFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.router == widget.router) {
      return;
    }
    oldWidget.router.routeInformationProvider.removeListener(
      _handleRouteChanged,
    );
    widget.router.routeInformationProvider.addListener(_handleRouteChanged);
  }

  @override
  void dispose() {
    widget.router.routeInformationProvider.removeListener(_handleRouteChanged);
    super.dispose();
  }

  void _handleRouteChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final brightness = Theme.of(context).brightness;
    final currentLocation =
        widget.router.routeInformationProvider.value.uri.path;
    final isHotelRoute =
        currentLocation == '/hotel-booking' ||
        currentLocation.startsWith('/hotel-booking/');
    final useImmersiveHotelStatusBar =
        isHotelRoute &&
        (widget.immersiveHotelStatusBarHint ??
            _usesImmersiveHotelStatusBar(currentLocation));
    final defaultStatusBarColor = brightness == Brightness.dark
        ? AppColorTokens.statusBarBackgroundDark
        : AppColorTokens.statusBarBackgroundLight;
    final statusBarColor = useImmersiveHotelStatusBar
        ? Colors.transparent
        : defaultStatusBarColor;
    final statusBarOverlayStyle =
        AppThemeFactory.statusBarOverlayStyleFor(brightness).copyWith(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: useImmersiveHotelStatusBar
              ? Brightness.light
              : null,
          statusBarBrightness: useImmersiveHotelStatusBar
              ? Brightness.dark
              : null,
        );
    SystemChrome.setSystemUIOverlayStyle(statusBarOverlayStyle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarOverlayStyle,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.child,
          if (!useImmersiveHotelStatusBar && mediaQuery.viewPadding.top > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: mediaQuery.viewPadding.top,
              child: IgnorePointer(child: ColoredBox(color: statusBarColor)),
            ),
        ],
      ),
    );
  }
}

class _LocalizedSettingsContentBootstrap extends ConsumerWidget {
  const _LocalizedSettingsContentBootstrap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeTag =
        Localizations.maybeLocaleOf(context)?.toLanguageTag() ??
        WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();

    ref.watch(settingsOperatingCompanyContentProvider(localeTag));
    return const SizedBox.shrink();
  }
}

void _scheduleNetworkOfflineDialog(WidgetRef ref, {int remainingRetries = 3}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(
      _showNetworkOfflineDialog(ref, remainingRetries: remainingRetries),
    );
  });
}

Future<void> _showNetworkOfflineDialog(
  WidgetRef ref, {
  required int remainingRetries,
}) async {
  if (ref.read(_networkOfflineDialogOpenProvider)) {
    return;
  }
  final dialogContext =
      appRootNavigatorKey.currentContext ??
      _rootScaffoldMessengerKey.currentContext;
  if (dialogContext == null || !dialogContext.mounted) {
    if (remainingRetries <= 0) {
      ref.read(_networkOfflineDialogShownProvider.notifier).state = false;
      return;
    }
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        final availability = ref
            .read(appNetworkAvailabilityProvider)
            .asData
            ?.value;
        if (availability != AppNetworkAvailability.offline) {
          ref.read(_networkOfflineDialogShownProvider.notifier).state = false;
          return;
        }
        _scheduleNetworkOfflineDialog(
          ref,
          remainingRetries: remainingRetries - 1,
        );
      }),
    );
    return;
  }
  final l10n = AppLocalizations.of(dialogContext);
  ref.read(_networkOfflineDialogOpenProvider.notifier).state = true;
  try {
    await AppDialogs.showAdaptiveAlert<void>(
      context: dialogContext,
      title: l10n.networkOfflineBannerTitle,
      message: l10n.networkOfflineBannerMessage,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
      ],
    );
  } finally {
    ref.read(_networkOfflineDialogOpenProvider.notifier).state = false;
  }
}

class _GlobalCelebrationHost extends ConsumerStatefulWidget {
  const _GlobalCelebrationHost();

  @override
  ConsumerState<_GlobalCelebrationHost> createState() =>
      _GlobalCelebrationHostState();
}

class _GlobalCelebrationHostState
    extends ConsumerState<_GlobalCelebrationHost> {
  static const Duration _presentationRetryDelay = Duration(milliseconds: 300);

  HomeCelebrationEvent? _activeCelebration;
  bool _isCelebrationScheduled = false;

  void _tryPresentCelebration() {
    if (!mounted || _activeCelebration != null || _isCelebrationScheduled) {
      return;
    }

    final isAuthenticated =
        ref.read(isAuthenticatedProvider).asData?.value ?? false;
    final pendingEvent = ref
        .read(homeCelebrationControllerProvider)
        .pendingEvent;
    if (!isAuthenticated || pendingEvent == null) {
      return;
    }
    final currentLocation = _currentLocation();
    if (currentLocation == null || currentLocation == '/splash') {
      _scheduleRetry();
      return;
    }

    _isCelebrationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _isCelebrationScheduled = false;
        return;
      }
      _isCelebrationScheduled = false;
      if (!mounted || _activeCelebration != null) {
        return;
      }

      final currentPending = ref
          .read(homeCelebrationControllerProvider)
          .pendingEvent;
      final stableLocation = _currentLocation();
      if (currentPending == null ||
          currentPending.token != pendingEvent.token ||
          stableLocation == null ||
          stableLocation == '/splash') {
        if (currentPending != null && stableLocation == '/splash') {
          _scheduleRetry();
        }
        return;
      }

      ref
          .read(homeCelebrationControllerProvider.notifier)
          .consumePending(currentPending.token);
      setState(() {
        _activeCelebration = currentPending;
      });
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _scheduleRetry() {
    if (!mounted || _isCelebrationScheduled) {
      return;
    }
    _isCelebrationScheduled = true;
    Future<void>.delayed(_presentationRetryDelay, () {
      _isCelebrationScheduled = false;
      _tryPresentCelebration();
    });
  }

  void _dismissCelebration() {
    if (!mounted || _activeCelebration == null) {
      return;
    }
    setState(() {
      _activeCelebration = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryPresentCelebration();
    });
  }

  String? _currentLocation() {
    try {
      return ref
          .read(appRouterProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .path;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HomeCelebrationState>(homeCelebrationControllerProvider, (
      previous,
      next,
    ) {
      if (previous?.pendingEvent?.token == next.pendingEvent?.token) {
        return;
      }
      _tryPresentCelebration();
    });
    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final wasAuthenticated = previous?.asData?.value ?? false;
      final isAuthenticated = next.asData?.value ?? false;
      if (wasAuthenticated == isAuthenticated) {
        return;
      }
      if (isAuthenticated) {
        _tryPresentCelebration();
      }
    });
    _tryPresentCelebration();
    final activeCelebration = _activeCelebration;
    if (activeCelebration == null) {
      return const SizedBox.shrink();
    }
    return HomeCelebrationDialog(
      event: activeCelebration,
      onDismiss: _dismissCelebration,
    );
  }
}

class _GlobalKeyboardDismissLayer extends StatelessWidget {
  const _GlobalKeyboardDismissLayer({required this.child});

  final Widget child;

  void _handlePointerDown(PointerDownEvent event) {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus == null) {
      return;
    }

    if (_isTapInsideFocusedRenderObject(currentFocus, event.position)) {
      return;
    }

    currentFocus.unfocus();
  }

  bool _isTapInsideFocusedRenderObject(FocusNode node, Offset globalPosition) {
    final renderObject = node.context?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return false;
    }

    final localPosition = renderObject.globalToLocal(globalPosition);
    return renderObject.size.contains(localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      child: child,
    );
  }
}
