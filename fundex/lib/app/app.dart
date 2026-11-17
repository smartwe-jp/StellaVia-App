import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';

import 'accessibility/app_text_scale_providers.dart';
import 'config/environment_provider.dart';
import 'firebase/push_token_sync_providers.dart';
import 'localization/app_locale_providers.dart';
import 'navigation/app_link_coordinator.dart';
import 'observability/app_observability_providers.dart';
import 'observability/app_ui_message_localizer.dart';
import 'push/app_push_dialog_host.dart';
import 'push/app_push_dialog_providers.dart';
import 'realtime/app_lifecycle_refresh_scope.dart';
import 'realtime/app_realtime_refresh.dart';
import 'router/app_router.dart';
import 'network/app_network_providers.dart';
import 'network/app_network_connectivity_providers.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/hotel_booking/presentation/providers/hotel_booking_providers.dart';
import '../features/investment/presentation/providers/fund_project_providers.dart';
import '../features/member_profile/presentation/providers/member_profile_providers.dart';
import '../features/settings/presentation/providers/settings_content_providers.dart';

final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<OverlayState> _appNoticeOverlayKey = GlobalKey<OverlayState>();
final _networkOfflineDialogShownProvider = StateProvider<bool>((ref) => false);
final _networkOfflineDialogOpenProvider = StateProvider<bool>((ref) => false);

class MemberTemplateApp extends ConsumerWidget {
  const MemberTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppNotice.bindHostOverlayKey(_appNoticeOverlayKey);
    ref.watch(pushTokenSyncBootstrapProvider);
    ref.watch(appPushDialogBootstrapProvider);
    ref.watch(appLinkCoordinatorProvider);
    ref.watch(hotelUserLanguageSyncBootstrapProvider);

    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);
    final locale = ref.watch(appLocaleProvider);
    final effectiveLocale = ref.watch(appEffectiveLocaleProvider);
    final textScaleFactor = ref.watch(appTextScaleFactorProvider);

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
        final mediaQuery = MediaQuery.of(context);
        final fixedTextScaleMediaQuery = mediaQuery.copyWith(
          textScaler: TextScaler.linear(textScaleFactor),
        );
        final brightness = Theme.of(context).brightness;
        final statusBarOverlayStyle = AppThemeFactory.statusBarOverlayStyleFor(
          brightness,
        ).copyWith(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(statusBarOverlayStyle);
        final appChild = AppLifecycleRefreshScope(
          child: MediaQuery(
            data: fixedTextScaleMediaQuery,
            child: _GlobalKeyboardDismissLayer(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: statusBarOverlayStyle,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              appChild,
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
