import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';

import 'config/environment_provider.dart';
import 'firebase/push_token_sync_providers.dart';
import 'localization/app_locale_providers.dart';
import 'observability/app_observability_providers.dart';
import 'observability/app_ui_message_localizer.dart';
import 'realtime/app_lifecycle_refresh_scope.dart';
import 'realtime/app_realtime_refresh.dart';
import 'router/app_router.dart';
import 'network/app_network_providers.dart';
import 'network/app_network_connectivity_providers.dart';
import 'theme/app_theme_mode_providers.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/investment/presentation/providers/fund_project_providers.dart';
import '../features/member_profile/presentation/providers/member_profile_providers.dart';

final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<OverlayState> _appNoticeOverlayKey = GlobalKey<OverlayState>();

class MemberTemplateApp extends ConsumerWidget {
  const MemberTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppNotice.bindHostOverlayKey(_appNoticeOverlayKey);
    ref.watch(pushTokenSyncBootstrapProvider);

    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    ref.listen<AppUiMessage?>(appUiMessageProvider, (previous, next) {
      if (next == null) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messengerContext = _rootScaffoldMessengerKey.currentContext;
        if (messengerContext != null) {
          final message = next.key.resolve(
            AppLocalizations.of(messengerContext),
          );
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
        if (previousAvailability != AppNetworkAvailability.offline ||
            nextAvailability != AppNetworkAvailability.online) {
          return;
        }
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
        final mediaQuery = MediaQuery.of(context);
        final brightness = Theme.of(context).brightness;
        final statusBarColor = brightness == Brightness.dark
            ? AppColorTokens.statusBarBackgroundDark
            : AppColorTokens.statusBarBackgroundLight;
        final statusBarOverlayStyle = AppThemeFactory.statusBarOverlayStyleFor(
          brightness,
        ).copyWith(statusBarColor: statusBarColor);
        SystemChrome.setSystemUIOverlayStyle(statusBarOverlayStyle);
        final appChild = AppLifecycleRefreshScope(
          child: _GlobalKeyboardDismissLayer(
            child: child ?? const SizedBox.shrink(),
          ),
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: statusBarOverlayStyle,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              appChild,
              if (mediaQuery.viewPadding.top > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: mediaQuery.viewPadding.top,
                  child: IgnorePointer(
                    child: ColoredBox(color: statusBarColor),
                  ),
                ),
              Overlay(
                key: _appNoticeOverlayKey,
                initialEntries: <OverlayEntry>[
                  OverlayEntry(
                    builder: (BuildContext context) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemeFactory.light(),
      darkTheme: AppThemeFactory.dark(),
      themeMode: themeMode,
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
